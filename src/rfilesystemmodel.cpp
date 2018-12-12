#include <sys/vfs.h>

#include "rfilesystemmodel.h"
#include "rdirectorymodel.h"
#include "diskInfo/diskinfomodel.h"
#include "fileFolder/filefoldermodel.h"
#include "bookmarkInfo/bookmarkinfomodel.h"
#include "recentsInfo/recentsinfomodel.h"
#include "models/trashinfomodel.h"


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

    backgroundColor = settings.value("global/backgroundColor").toString();
    iconColor = settings.value("global/iconColor").toString();
    animationDuration = settings.value("global/animationDuration").toInt();
}

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
    QFile historyFile(QDir::homePath() + "/.RevProgIFace/FileHistory.rde");
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
    QFile historyFile(QDir::homePath() + "/.RevProgIFace/MostVisitedPlaces.rde");
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
        RDesktopServices rds;
        QString folderIcon = "file://" + rds.getThemeIcon("std-name:folder");
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
    FileFolderModel *ffm = new FileFolderModel(QFileInfo(Path));
    RDirectoryModel *newTab = new RDirectoryModel();

    connect(newTab, &RDirectoryModel::TitleChanged, ffm, &FileFolderModel::changeTabTitle);
    connect(newTab, &RDirectoryModel::notify, nm, &NotificationModel::Notify);

    newTab->updateCurrentDirectory(Path);

    tabDataList.append(newTab);
    tabHeaderList.append(ffm);

    emit TabHeaderListChanged();

    connect(newTab, &RDirectoryModel::WriteBookmarkThreaded, this, &RFileSystemModel::writeBookmarkAsync);
    connect(newTab, &RDirectoryModel::WriteHistoryTabbed, this, &RFileSystemModel::writeHistoryThreaded);
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
    if(!stdName.contains("/")){
        if(stdName.compare("home") == 0)
            qobject_cast<RDirectoryModel*>(getTabData(activeIndex))->updateCurrentDirectory(QDir::homePath());
        else
            qobject_cast<RDirectoryModel*>(getTabData(activeIndex))->updateCurrentDirectory(QDir::homePath() + "/" + stdName);
    }
    else
        qobject_cast<RDirectoryModel*>(getTabData(activeIndex))->updateCurrentDirectory(stdName);
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

QString RFileSystemModel::BackgroundColor() const{
    return backgroundColor;
}

void RFileSystemModel::setBackgroundColor(const QString &BackgroundColor){
    if(backgroundColor != BackgroundColor){
        backgroundColor = BackgroundColor;
        settings.setValue("global/backgroundColor", BackgroundColor);
        emit BackgroundColorChanged();
    }
}

QString RFileSystemModel::IconColor() const{
    return iconColor;
}

void RFileSystemModel::setIconColor(const QString &IconColor){
    if(iconColor != IconColor){
        iconColor = IconColor;
        settings.setValue("global/iconColor", iconColor);
        emit IconColorChanged();
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

RFileSystemModel::~RFileSystemModel(){
    deleteLater();
}
