/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
#include <sys/vfs.h>
#include <QCoreApplication>

#include "rfilesystemmodel.h"
#include "fileStructures/local/localfiles.h"
#include "fileStructures/dropbox/dropbox.h"
#include "fileStructures/onedrive/onedrive.h"
#include "fileStructures/googledrive/googledrive.h"
#include "models/diskInfo/diskinfomodel.h"
#include "models/fileFolder/filefoldermodel.h"
#include "models/bookmarkInfo/bookmarkinfomodel.h"
#include "models/recentsInfo/recentsinfomodel.h"
#include "models/trashInfo/trashinfomodel.h"
#include "models/desktopfilemodel.h"
//#include <QDBusConnection>
//#include <QDBusConnectionInterface>

RFileSystemModel::RFileSystemModel(QObject *parent)
    : QObject(parent){
    GetAttachedDiskList();

    BookmarkKeeper *bookObj = new BookmarkKeeper();
    bookObj->moveToThread(&bookmarkKeeperThread);

    connect(&bookmarkKeeperThread, &QThread::finished, bookObj, &QObject::deleteLater);
    connect(this, &RFileSystemModel::addBookmark, bookObj, &BookmarkKeeper::add);
    connect(this, &RFileSystemModel::removeBookmark, bookObj, &BookmarkKeeper::remove);
    bookmarkKeeperThread.start();

    nm = new NotificationModel();

    HistoryKeeper *hisObj = new HistoryKeeper();
    hisObj->moveToThread(&historyKeeperThread);

    connect(&historyKeeperThread, &QThread::finished, hisObj, &QObject::deleteLater);
    connect(this, &RFileSystemModel::writeHistoryThreaded, hisObj, &HistoryKeeper::WriteHistoryAsync);

    historyKeeperThread.start();

    backgroundColor1 = settings.value("global/backgroundColor1").toString();
    backgroundColor2 = settings.value("global/backgroundColor2").toString();
    iconColor1 = settings.value("global/iconColor1").toString();
    iconColor2 = settings.value("global/iconColor2").toString();
    animationDuration = settings.value("global/animationDuration").toInt();
    isPinPinned = settings.value("global/isPinPinned").toBool();

    dropboxViewer = new DropboxViewer();
    oneDriveViewerObj = new OneDriveViewer();
    googleDriveViewerObj = new GoogleDriveViewer();

    rvp = new RPhotoModel();
    emit PhotoViewProviderChanged();
}


/*void RFileSystemModel::setupDbus(){
    QDBusConnection::sessionBus().registerObject(QStringLiteral("/org/freedesktop/FileManager1"), this,
                                                 QDBusConnection::ExportScriptableContents | QDBusConnection::ExportAdaptors);
    QDBusConnection::sessionBus().interface()->registerService(QStringLiteral("org.freedesktop.FileManager1"),
                                                                   QDBusConnectionInterface::QueueService);
}

void RFileSystemModel::ShowFolders(const QStringList &uriList, const QString &startUpId){
    Q_UNUSED(startUpId);
    foreach(QString uri, uriList){
        QDir dir(uri);
        if(dir.exists())
            createNewTab(uri);
    }
}

void RFileSystemModel::ShowItems(const QStringList &uriList, const QString &startUpId){
    Q_UNUSED(startUpId);
}*/


void RFileSystemModel::writeBookmarkAsync(QString filePath, bool addOrRemove){
    addOrRemove ? emit addBookmark(filePath) : emit removeBookmark(filePath);
    updateStoredBookmarkList();
}


void RFileSystemModel::GetAttachedDiskList(){

    diskDataList.clear();

    QFile partitionsFile("/proc/partitions");
    if(partitionsFile.open(QIODevice::ReadOnly)){
        QString allPartitionsDataHolder = partitionsFile.readAll();
        partitionsFile.close();

        QStringList allVolumesList = allPartitionsDataHolder.split('\n', QString::SkipEmptyParts);


        QFile fstabFile("/etc/mtab");
        if(fstabFile.open(QIODevice::ReadOnly)){
            QString allPartitionsMountData = fstabFile.readAll();
            fstabFile.close();
            QStringList allVolumesMountDataList = allPartitionsMountData.split('\n', QString::SkipEmptyParts);

            int totalPartitionCount = allVolumesList.length();
            for(int i = 0; i < totalPartitionCount; i++){
                QString volume = allVolumesList.at(i);
                if(volume.at(volume.length() - 1).isDigit()){
                    QStringList volumeData = volume.split(' ', QString::SkipEmptyParts);

                    DiskInfoModel *newDisk = new DiskInfoModel();
                    newDisk->setDevName(volumeData.at(3));

                    for(int j = 0; j < allVolumesMountDataList.length(); j++){
                        QString mountData = allVolumesMountDataList.at(j);
                        if(mountData.startsWith("/dev/")){
                            if(mountData.startsWith("/dev/" + volumeData.at(3))){
                                QStringList mountDataList = mountData.split(' ', QString::SkipEmptyParts);

                                newDisk->setMountPoint(mountDataList.at(1));
                                newDisk->setFileSystem(mountDataList.at(2));

                                struct statfs64 vfs;
                                if(!statfs64(mountDataList.at(1).toUtf8(), &vfs)){
                                    newDisk->setTotalVolumeSize(vfs.f_blocks * static_cast<double>(vfs.f_bsize) / 1048576);
                                    newDisk->setUsedVolumeSize(vfs.f_bfree * static_cast<double>(vfs.f_bsize) / 1048576);
                                }

                                if(volumeData.at(0) == '8'){
                                    if(mountDataList.at(1) == '/')
                                        newDisk->setDisplayName("Root");
                                    else if(!mountDataList.at(2).isEmpty())
                                        newDisk->setDisplayName("Disk");
                                }
                                else if(volumeData.at(0) == "13"){
                                    newDisk->setDisplayName("Optical Disk");
                                }

                                newDisk->GenerateExtras();
                                diskDataList.append(newDisk);

                                allVolumesMountDataList.removeAt(j);
                                j--;
                                break;
                            }
                        }
                        else{
                            allVolumesMountDataList.removeAt(j);
                            j--;
                        }
                    }
                }
            }
        }
    }
    emit DiskDataListChanged();
}


void RFileSystemModel::prepareRecentsList(){

    recentsList.clear();
    QFile historyFile(QDir::homePath() + "/.config/" + QCoreApplication::organizationName() + "/FileHistory.conf" );
    if(historyFile.open(QIODevice::ReadOnly)){
        QString buffer = historyFile.readAll();
        QStringList historyList = buffer.split('\n', QString::SkipEmptyParts);
        QMimeType mime;
        foreach (buffer, historyList) {
            QStringList dataList = buffer.split('|', QString::SkipEmptyParts);
            RecentsInfoModel *model = new RecentsInfoModel();
            model->setDateAccessed(dataList.at(1));
            model->setTimeAccessed(dataList.at(2));
            model->setActualPath(dataList.at(3));

            //set the filename, if it is only '/' then mark it as root
            buffer = dataList.at(3);
            buffer = buffer.mid(buffer.lastIndexOf('/') + 1);
            model->setDisplayName(buffer.isEmpty() ? "Root" : buffer);

            recentsList.prepend(model);
        }
    }
    emit RecentsListChanged();
}

void RFileSystemModel::prepareMostVisitedPlacesList(){

    mostVisitedPlacesList.clear();
    QFile historyFile(QDir::homePath() + "/.config" + QCoreApplication::organizationName() + "/MostVisitedPlaces.conf");
    if(historyFile.open(QIODevice::ReadOnly)){
        QString buffer = historyFile.readAll();
        QStringList historyList = buffer.split('\n', QString::SkipEmptyParts);
        QMimeType mime;
        foreach (buffer, historyList) {
            QStringList dataList = buffer.split('|', QString::SkipEmptyParts);
            RecentsInfoModel *model = new RecentsInfoModel();
            model->setDateAccessed(dataList.at(1));
            model->setTimeAccessed(dataList.at(2));
            model->setActualPath(dataList.at(3));

            buffer = dataList.at(3);
            buffer = buffer.mid(buffer.lastIndexOf('/') + 1);
            model->setDisplayName(buffer.isEmpty() ? "Root" : buffer);

            mostVisitedPlacesList.append(model);
        }
        emit MostVisitedPlacesListChanged();
    }
}


void RFileSystemModel::prepareTrashList(QString nameFilter){
    //this is dir where Unix/Linux alike systems keep their trash content by default
    QDir trashDir(QDir::homePath() + "/.local/share/Trash/files");
    //get all the directories and files in trash, sorted according to their time of deletion- newest first

    trashDir.setFilter(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);
    trashDir.setSorting(QDir::Time | QDir::Reversed);
    if(!nameFilter.isEmpty())
        trashDir.setNameFilters(QStringList() << ("*" + nameFilter + "*"));

    QFileInfoList trashedFileDataList = trashDir.entryInfoList();

    //clear the trash list- it is done in order to process any subsequent trash update request
    trashList.clear();

    foreach (QFileInfo anotherTrashedFile, trashedFileDataList) {

        TrashInfoModel *trashObj = new TrashInfoModel();

        trashObj->setDisplayName(anotherTrashedFile.fileName());
        trashObj->setCurrentPath(anotherTrashedFile.filePath());

        /* Unix/Linux stores the info about deleted files in the ~/.local/share/Trash/info/ dir in the form--
         * "Path='the-actual-path-where-the-file-was-deleted-from'
         * DeletionDate='YYYY-MM-DDTHH:MM:SS'"
         */
        QString trashInfoDir = QDir::homePath() + "/.local/share/Trash/info/" + anotherTrashedFile.fileName() + ".trashinfo";
        QFile trashedFileInfo(trashInfoDir);

        if(trashedFileInfo.open(QIODevice::ReadOnly)){

            QTextStream stream(&trashedFileInfo);

            QString anotherLine = stream.readLine();

            anotherLine = stream.readLine();
            anotherLine = anotherLine.right(anotherLine.length() - 5);
            trashObj->setActualPath(anotherLine);

            anotherLine = stream.readLine();
            anotherLine = anotherLine.right(anotherLine.length() - 13);
            trashObj->setDeletedDate(anotherLine);

            trashedFileInfo.close();

            trashList.append(trashObj);
        }
    }
    emit TrashListChanged();
}


void RFileSystemModel::updateStoredBookmarkList(){
    bookmarkDataList.clear();
    QFile bookmarkFile(QDir::homePath() + "/.cache/reverse-files/bookmarks.rde");
    if(bookmarkFile.open(QIODevice::ReadOnly)){
        QString wholeFile = bookmarkFile.readAll();
        QStringList book = wholeFile.split('\n', QString::SkipEmptyParts);
        QString folderIcon = "image://xdg/inode-directory";
        foreach (wholeFile, book) {
            BookmarkInfoModel *model = new BookmarkInfoModel();
            model->setActualPath(wholeFile);

            if(wholeFile.endsWith('/'))
                wholeFile = wholeFile.mid(0, wholeFile.length() - 1);

            model->setDisplayName(wholeFile.mid(wholeFile.lastIndexOf('/') + 1));
            model->setIconPath(folderIcon);
            bookmarkDataList.append(model);
        }
    }
    emit BookmarkDataListChanged();
}


void RFileSystemModel::createNewTab(QString Path){
    if(Path.startsWith("startpage")){
        FileFolderModel *ffm = new FileFolderModel(QFileInfo(Path));
        ffm->setFileType("folder");
        ffm->changeTabTitle("Start Page");

        sph = new StartPageHandler();
        emit StartPageHandleChanged();

        tabHeaderList.append(ffm);
        emit TabHeaderListChanged();
    }
    else if(Path.startsWith("pictures")){
        FileFolderModel *ffm = new FileFolderModel(QFileInfo(Path));
        ffm->setFileType("camera-photo");
        ffm->changeTabTitle("Photo Viewer");

        tabHeaderList.append(ffm);
        emit TabHeaderListChanged();

        emit cppTabListChanged("/qml/Tabs/PhotosViewer/GalleryView.qml");
    }
    else if(!Path.startsWith("cloud://")){
        FileFolderModel *ffm = new FileFolderModel(QFileInfo(Path));
        ffm->setFileType("Directory");
        LocalFiles *newTab = new LocalFiles();

        connect(newTab, &LocalFiles::TitleChanged, ffm, &FileFolderModel::changeTabTitle);
        connect(newTab, &LocalFiles::notify, nm, &NotificationModel::Notify);

        tabHeaderList.append(ffm);
        emit TabHeaderListChanged();

        tabDataList.append(newTab);
        newTab->updateCurrentDirectory(Path);

        connect(newTab, &LocalFiles::WriteBookmarkThreaded, this, &RFileSystemModel::writeBookmarkAsync);
        connect(newTab, &LocalFiles::WriteHistoryTabbed, this, &RFileSystemModel::writeHistoryThreaded);

        emit cppTabListChanged();
    }
    else if(Path.contains("dropbox")){
        FileFolderModel *ffm = new FileFolderModel(QFileInfo(Path));
        ffm->setFileType("dropbox");
        ffm->setDisplayName("Dropbox");
        Dropbox *dbTab = new Dropbox();

        connect(dbTab, &Dropbox::TitleChanged, ffm, &FileFolderModel::changeTabTitle);
        connect(dbTab, &Dropbox::notify, nm, &NotificationModel::Notify);

        tabHeaderList.append(ffm);
        emit TabHeaderListChanged();

        tabDataList.append(dbTab);
        emit cppTabListChanged();
    }
    else if(Path.contains("onedrive")){
        FileFolderModel *ffm = new FileFolderModel(QFileInfo(Path));
        ffm->setFileType("skydrive");
        ffm->setDisplayName("OneDrive");
        OneDrive *odTab = new OneDrive();

        connect(odTab, &OneDrive::TitleChanged, ffm, &FileFolderModel::changeTabTitle);
        connect(odTab, &OneDrive::notify, nm, &NotificationModel::Notify);

        tabHeaderList.append(ffm);
        emit TabHeaderListChanged();

        tabDataList.append(odTab);
        emit cppTabListChanged();
    }
    else if(Path.contains("google-drive")){
        FileFolderModel *ffm = new FileFolderModel(QFileInfo(Path));
        ffm->setFileType("google-drive");
        ffm->setDisplayName("Google Drive");
        GoogleDrive *gdTab = new GoogleDrive();

        connect(gdTab, &GoogleDrive::TitleChanged, ffm, &FileFolderModel::changeTabTitle);
        connect(gdTab, &GoogleDrive::notify, nm, &NotificationModel::Notify);

        tabHeaderList.append(ffm);
        emit TabHeaderListChanged();

        tabDataList.append(gdTab);
        emit cppTabListChanged();
    }
}

int RFileSystemModel::doesTabExist(QString key){
    int i = -1;
    for(i = 0; i < tabHeaderList.length(); i++){
        auto ffm = qobject_cast<FileFolderModel*>(tabHeaderList.at(i));
        if(ffm->DisplayName() == key)
            return i;
    }
    return -1;
}



QObject* RFileSystemModel::getTabData(){
    return  tabDataList.last();
}

QObject* RFileSystemModel::getTabData(int index){
    if(index < tabDataList.length())
        return tabDataList.at(index);
    else
        return nullptr;
}


void RFileSystemModel::updateCurrentDirectoryOnCurrentView(QString stdName, int activeIndex){
    if(activeIndex > 0){
        if(!stdName.contains("/")){
            if(stdName.compare("home") == 0)
                qobject_cast<LocalFiles*>(getTabData(activeIndex))->updateCurrentDirectory(QDir::homePath());
            else
                qobject_cast<LocalFiles*>(getTabData(activeIndex))->updateCurrentDirectory(QDir::homePath() + "/" + stdName);
        }
        else
            qobject_cast<LocalFiles*>(getTabData(activeIndex))->updateCurrentDirectory(stdName);
    }
    else{
        if(!stdName.contains("/"))
            stdName = QDir::homePath() + ((stdName.compare("home") == 0) ? "" : "/" + stdName);
        createNewTab(stdName);
    }
}


void RFileSystemModel::deleteTab(int index){
    if(index < tabHeaderList.length())
        tabHeaderList.removeAt(index);
    if(index < tabDataList.length())
        tabDataList.removeAt(index);

    if(tabHeaderList.length() == 0)
        delete this;

    emit TabHeaderListChanged();
}



int RFileSystemModel::AppTheme() const{
    return settings.value("global/appTheme").toInt();
}

void RFileSystemModel::setAppTheme(const int AppTheme){
    settings.setValue("global/appTheme", AppTheme);
}

QString RFileSystemModel::BackgroundColor1() const{
    return backgroundColor1;
}

void RFileSystemModel::setBackgroundColor1(const QString &BackgroundColor1){
    if(backgroundColor1 != BackgroundColor1){
        backgroundColor1 = BackgroundColor1;
        settings.setValue("global/backgroundColor1", BackgroundColor1);
        emit BackgroundColor1Changed();
    }
}

QString RFileSystemModel::BackgroundColor2() const{
    return backgroundColor2;
}

void RFileSystemModel::setBackgroundColor2(const QString &BackgroundColor2){
    if(backgroundColor2 != BackgroundColor2){
        backgroundColor2 = BackgroundColor2;
        settings.setValue("global/backgroundColor2", BackgroundColor2);
        emit BackgroundColor2Changed();
    }
}

QString RFileSystemModel::IconColor1() const{
    return iconColor1;
}

void RFileSystemModel::setIconColor1(const QString &IconColor1){
    if(iconColor1 != IconColor1){
        iconColor1 = IconColor1;
        settings.setValue("global/iconColor1", iconColor1);
        emit IconColor1Changed();
    }
}

QString RFileSystemModel::IconColor2() const{
    return iconColor2;
}

void RFileSystemModel::setIconColor2(const QString &IconColor2){
    if(iconColor2 != IconColor2){
        iconColor2 = IconColor2;
        settings.setValue("global/iconColor2", iconColor2);
        emit IconColor2Changed();
    }
}


QString RFileSystemModel::HighlightColor() const{
    return highlightColor;
}

void RFileSystemModel::setHighlightColor(const QString &HighlightColor){
    if(highlightColor != HighlightColor){
        highlightColor = HighlightColor;
        settings.setValue("global/highlightColor", highlightColor);
        emit HighlightColorChanged();
    }
}

QString RFileSystemModel::SelectedColor() const{
    return selectedColor;
}

void RFileSystemModel::setSelectedColor(const QString &SelectedColor){
    if(selectedColor != SelectedColor){
        selectedColor = SelectedColor;
        settings.setValue("global/selectedColor", selectedColor);
        emit SelectedColorChanged();
    }
}

int RFileSystemModel::GlobalIsHiddenItemsShown() const{
    return settings.value("global/isHiddenItemsShown").toInt();
}

void RFileSystemModel::setGlobalIsHiddenItemsShown(const int GlobalIsHiddenItemsShown){
    settings.setValue("global/isHiddenItemsShown", GlobalIsHiddenItemsShown);
}


int RFileSystemModel::GlobalIsPreviewAvailable() const{
    return settings.value("global/isPreviewAvailable").toInt();
}

void RFileSystemModel::setGlobalIsPreviewAvailable(const int GlobalIsPreviewAvailable){
    settings.setValue("global/isPreviewAvailable", GlobalIsPreviewAvailable);
}


int RFileSystemModel::GlobalIconScale() const{
    //by default icons will be scaled to 'small'
    QVariant temp = settings.value("global/iconScale");
    return (temp.isNull() ? 1 : temp.toInt()/16 - 1);
}

void RFileSystemModel::setGlobalIconScale(const int GlobalIconScale){
    settings.setValue("global/iconScale", (GlobalIconScale + 1)*16);
}

int RFileSystemModel::GlobalAnimationDuration() const{
    return animationDuration;
}

void RFileSystemModel::setGlobalAnimationDuration(const int GlobalAnimationDuration){
    if(animationDuration != GlobalAnimationDuration){
        animationDuration = GlobalAnimationDuration;
        settings.setValue("global/animationDuration", GlobalAnimationDuration);
        emit GlobalAnimationDurationChanged();
    }
}

bool RFileSystemModel::IsPinPinned() const{
    return isPinPinned;
}

void RFileSystemModel::setIsPinPinned(const bool IsPinPinned){
    if(IsPinPinned != isPinPinned){
        isPinPinned = IsPinPinned;
        settings.setValue("global/isPinPinned", IsPinPinned);
        emit IsPinPinnedChanged();
    }
}

int RFileSystemModel::GlobalFileFolderView() const{
    return settings.value("global/currentView").toInt();
}

void RFileSystemModel::setGlobalFileFolderView(const int &GlobalFileFolderView){
    settings.setValue("global/currentView", GlobalFileFolderView);
}

