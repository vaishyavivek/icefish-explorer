#include "HeaderFiles/rdirectorymodel.h"
#include "HeaderFiles/filefoldermodel.h"
#include "HeaderFiles/menumodel.h"
#include "HeaderFiles/navigationhistorymodel.h"

#include <QDebug>
#include <QDateTime>

RDirectoryModel::RDirectoryModel(QObject *parent) : QObject(parent){
    pointerToCurrentDirectoryInNavigationHistoryInfoList = -1;
    isHome = false;
}


void RDirectoryModel::updateCurrentDirectory(QString newDirectoryToSwitchTo){
    if(!newDirectoryToSwitchTo.isEmpty()){
        emit backNavBtnEnabled(false);
        emit forNavBtnEnabled(false);

        int notificationLevel = updateCurrentDirectoryInternal(newDirectoryToSwitchTo);
        //if directory switch suceeds then update the history stack list
        if(notificationLevel == 0){
            //in case any previous forward operations were made then remove all of them
            for(int i = navigationHistoryInfoList.length() ; i > pointerToCurrentDirectoryInNavigationHistoryInfoList; i--){
                navigationHistoryInfoList.removeAt(i);
            }

            wildSearchKey = "";
            emit WildSearchKeyChanged();

            NavigationHistoryModel *nhm = new NavigationHistoryModel(newDirectoryToSwitchTo);
            navigationHistoryInfoList.append(nhm);
            pointerToCurrentDirectoryInNavigationHistoryInfoList++;

            backNavBtnEnabled(true);

            setAddressBoxData(newDirectoryToSwitchTo);
        }
        else if(notificationLevel == 1)
            emit notify(Error::PathDoesntExist);
        else if(notificationLevel == 2){
            //setAddressBoxData(newDirectoryToSwitchTo.left(newDirectoryToSwitchTo.lastIndexOf("/")));
            if(pointerToCurrentDirectoryInNavigationHistoryInfoList < navigationHistoryInfoList.length())
                forNavBtnEnabled(true);
            if(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0)
                backNavBtnEnabled(true);
        }
        else
            emit notify(Error::Unknown);
    }
}

int RDirectoryModel::ActiveIndexInCurrentModel() const{
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
    return nhm->ActiveIndex();
}

void RDirectoryModel::setActiveIndexInCurrentModel(const int ActiveIndexInCurrentModel){
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
    nhm->setActiveIndex(ActiveIndexInCurrentModel);
}


/* this is a internal function which takes care of updating secondaryPage for directory to directory navigation
 * we first check whether the address provided is of a directory or a file,
 * if its a file than call Qt-desktopService to open it in external app as prescribed by the DE;
 * else if its new address is a directory, than switch to it
 *
 */
int RDirectoryModel::updateCurrentDirectoryInternal(QString directoryToSwitchTo){

    QFileInfo file = QFileInfo(directoryToSwitchTo);

    if(file.exists()){
        //emit WriteHistoryThreaded(directoryToSwitchTo);
        if(file.isDir()){
            emit TitleChanged(directoryToSwitchTo.mid(directoryToSwitchTo.lastIndexOf('/') + 1));
            //RDesktopServices rds;
            emit IconPathChanged(rds.getThemeIcon(directoryToSwitchTo, 64));

            QDir localDirectory(directoryToSwitchTo);
            applyCurrentDirectorySettings(&localDirectory);
            QFileInfoList infoList = localDirectory.entryInfoList();

            //clear current list to update it
            fileFolderList.clear();

            QThread *iconCacheThread = new QThread();

            foreach (QFileInfo file, infoList) {
                if((!file.fileName().startsWith("$"))
                        && (!(file.fileName() == ".rfmDirectorySetting"))
                        && (!(file.fileName() == ".RevProgIFace"))){

                    FileFolderModel *newModel =  new FileFolderModel(file.fileName(), file.filePath(),
                                                                     file.birthTime().toString("ddd MMMM d yyyy | hh:mm:ss"),
                                                                     file.lastModified().toString("ddd MMMM d yyyy | hh:mm:ss"));

                    newModel->setFileSize(file.size());
                    newModel->setIsHidden(file.isHidden());
                    newModel->setIsPreviewAvailable(isPreviewAvailable);
                    newModel->setActionsMenu(getActionMenuFor(file.filePath()));

                    RDesktopServices *rds = new RDesktopServices();
                    rds->moveToThread(iconCacheThread);
                    connect(iconCacheThread, &QThread::finished, rds, &RDesktopServices::deleteLater);

                    connect(newModel, &FileFolderModel::generateIcon, rds, &RDesktopServices::getThemeIcon);
                    connect(newModel, &FileFolderModel::generateIcon, rds, &RDesktopServices::constructCachedPreview);

                    connect(rds, &RDesktopServices::provideCachedIcon, newModel, &FileFolderModel::setIconPath);
                    connect(rds, &RDesktopServices::provideCachedPreview , newModel, &FileFolderModel::setPreviewPath);

                    connect(rds, &RDesktopServices::provideFileType, newModel, &FileFolderModel::setFileType);

                    connect(this, &RDirectoryModel::triggerIconCacheThreads, newModel, &FileFolderModel::initIconCacheThread);

                    fileFolderList.append(newModel);
                }
            }
            emit FileFolderListChanged();
            iconCacheThread->start();
            emit triggerIconCacheThreads();
            return 0;//no error
        }
        else if(file.isFile()){
            rds.runDesktopService(directoryToSwitchTo);
            return 2;//destop service opened
        }
        else return 3;//unknown error
    }
    else
        return 1;//file doesn't exist
}


void RDirectoryModel::applyCurrentDirectorySettings(QDir *localDirectory){

    //set default settings
    localDirectory->setFilter(QDir::NoDotAndDotDot | QDir::Dirs | QDir::Files);

    if(!wildSearchKey.isEmpty())
        localDirectory->setNameFilters(QStringList() << ("*" + wildSearchKey + "*"));

    localDirectory->setSorting(QDir::DirsFirst | QDir::Name);

    isHiddenItemsShown = false;
    isPreviewAvailable = false;
    iconScale = 48;
    isBookmarked = false;
    sortingRole = "Name";
    sortingOrder = "Ascending";
    sortingPreference = "DirectoryFirst";

    QFile dirInfo(localDirectory->path() + "/.rfmDirectorySetting");
    if(dirInfo.open(QIODevice::ReadOnly)){
        QTextStream stream(&dirInfo);
        QString info;

        do {
            info = stream.readLine();
            if(info.startsWith("HiddenFilesShown")){
                info = info.section('=', 1);
                if(info.startsWith("1")){
                    localDirectory->setFilter(localDirectory->filter() | QDir::Hidden);
                    isHiddenItemsShown = true;
                }
            }
            if(info.startsWith("PreviewAvailable")){
                info = info.section('=', 1);
                isPreviewAvailable = info.startsWith("1");
            }
            else if(info.startsWith("SortingRole")){
                info = info.section('=', 1);
                sortingRole = info;
                if(info.compare("Type"))
                    localDirectory->setSorting(QDir::Type);
                else if(info.compare("Size"))
                    localDirectory->setSorting(QDir::Size);
                else if(info.compare("Time"))
                    localDirectory->setSorting(QDir::Time);
            }
            else if(info.startsWith("SortingOrder")){
                info = info.section('=', 1);
                if(info.compare("Descending")){
                    sortingOrder = info;
                    localDirectory->setSorting(localDirectory->sorting() | QDir::Reversed);
                }
            }
            else if(info.startsWith("SortingPreference")){
                info = info.section('=', 1);
                if(info.compare("FileFirst")){
                    sortingPreference = "FileFirst";
                    localDirectory->setSorting(localDirectory->sorting() | QDir::DirsLast);
                }
                else
                    localDirectory->setSorting(localDirectory->sorting() | QDir::DirsFirst);
            }
            else if(info.startsWith("CurrentView")){
                info = info.section('=', 1);
                if(info.startsWith("00"))
                    emit changeFileFolderView(0);
                else if(info.startsWith("01"))
                    emit changeFileFolderView(1);
            }
            else if(info.startsWith("ScaleFactor")){
                info = info.section('=', 1);
                iconScale = info.toInt();
            }
            else if(info.startsWith("Bookmarked")){
                info = info.section('=', 1);
                isBookmarked = info.startsWith("1");
            }
        }while (!info.isNull());
    }

    emit IsBookmarkedChanged();
    emit IsHiddenItemsShownChanged();
    emit IsPreviewAvailableChanged();
    emit SortingRoleChanged();
    emit SortingOrderChanged();
    emit SortingPreferenceChanged();
    emit IconScaleChanged();

}


void RDirectoryModel::setIsBookmarked(const bool IsBookmarked){
    isBookmarked = IsBookmarked;
    updateSettingsForCurrentDirectory("Bookmarked", isBookmarked ? "1" : "0");
    emit WriteBookmarkThreaded(addressBoxData, isBookmarked);
    emit IsBookmarkedChanged();
}

void RDirectoryModel::setIsHiddenItemsShown(const bool IsHiddenItemsShown){
    isHiddenItemsShown = IsHiddenItemsShown;
    updateSettingsForCurrentDirectory("HiddenFilesShown", isHiddenItemsShown ? "1" : "0");
    emit IsHiddenItemsShownChanged();
    reloadCurrentDirectory();
}

void RDirectoryModel::setIsPreviewAvailable(const bool IsPreviewAvailable){
    isPreviewAvailable = IsPreviewAvailable;
    updateSettingsForCurrentDirectory("PreviewAvailable", isPreviewAvailable ? "1" : "0");
    emit IsPreviewAvailableChanged();
}


void RDirectoryModel::setSortingRole(const QString &SortingRole){
    sortingRole = SortingRole;
    updateSettingsForCurrentDirectory("SortingRole", SortingRole);
}

void RDirectoryModel::setSortingOrder(const QString &SortingOrder){
    sortingOrder = SortingOrder;
    updateSettingsForCurrentDirectory("SortingOrder", SortingOrder);
}

void RDirectoryModel::setSortingPreference(const QString &SortingPreference){
    sortingPreference = SortingPreference;
    updateSettingsForCurrentDirectory("SortingPreference", sortingPreference);
}


void RDirectoryModel::setIconScale(const int IconScale){
    iconScale = IconScale;
    updateSettingsForCurrentDirectory("ScaleFactor", QString::number(iconScale));
    emit IconScaleChanged();
}



QList<QObject*> RDirectoryModel::getActionMenuFor(QString filePath){

    QList<QObject*> menu;

    MenuModel *open = new MenuModel();
    open->setServiceName("Open with");
    open->setHasSubmenu(true);
    open->setAction("open-with");
    open->setSubmenu(rds.getAssociatedServicesList(filePath));

    if(!open->Submenu().isEmpty())
        menu.append(open);

    MenuModel *cut = new MenuModel();
    cut->setServiceName("Cut");
    cut->setAction("cut");
    menu.append(cut);

    MenuModel *copy = new MenuModel();
    copy->setServiceName("Copy");
    copy->setAction("copy");
    menu.append(copy);

    MenuModel *share = new MenuModel();
    share->setServiceName("Share with");
    share->setAction("share");
    menu.append(share);

    MenuModel *properties = new MenuModel();
    properties->setServiceName("Properties");
    properties->setAction("properties");
    menu.append(properties);

    return menu;
}




/* to update the URLbox whenever there's a change in the current directory
 * we're using normal FileFolderModel as the template for sake of simplicity and to reduce source code size
 * by default a 'Root' is added if the current directory is root instead of ordinary '/'
 */

void RDirectoryModel::setAddressBoxData(QString changedAddress){
    //for trash
    if(changedAddress == "rfm://trash"){
        addressBoxData = "Trash:/";

        addressBoxDataListView.clear();
        FileFolderModel *trashModel = new FileFolderModel();
        trashModel->setDisplayName("Trash");
        trashModel->setPath("");
        addressBoxDataListView.append(trashModel);

        emit askAddressBoxToSwitchToListViewMode(true);
    }
    else if(changedAddress != ""){

        if(changedAddress != addressBoxData)
            addressBoxData = changedAddress;

        isHome = changedAddress.startsWith(QDir::homePath());
        emit IsHomeChanged();

        addressBoxDataListView.clear();

        FileFolderModel *rootModel = new FileFolderModel();
        rootModel->setDisplayName("Root");
        rootModel->setPath("/");
        addressBoxDataListView.append(rootModel);

        changedAddress = changedAddress.section("/", 1);
        changedAddress.append("/");

        QString refToPreviousData = "/";

        while (changedAddress.indexOf("/") > 1) {
            FileFolderModel *newModel = new FileFolderModel();

            QString nextSection = changedAddress.left(changedAddress.indexOf("/"));
            newModel->setDisplayName(nextSection);

            refToPreviousData.append(nextSection + "/");
            newModel->setPath(refToPreviousData);

            addressBoxDataListView.append(newModel);
            changedAddress = changedAddress.section("/", 1);
        }

        emit askAddressBoxToSwitchToListViewMode(true);
    }
    else{
        addressBoxData = "";
        addressBoxDataListView.clear();
        emit askAddressBoxToSwitchToListViewMode(false);
    }

    emit AddressBoxDataChanged();
    emit AddressBoxDataListViewChanged();
}


void RDirectoryModel::navigateBackward(){
    /* this works while popping things out of the navigationHistoryInfoList at the index one less than pointer,
     * then switch to that directory without making any changes to the HistoryList,
     * if succusfull than enable homeBtn, that was previously disabled,
     * enable forwardBtn in any case.
     * at last, if there's still something that can be popped than enable historyBtn else leave it disabled.
     */
    if((--pointerToCurrentDirectoryInNavigationHistoryInfoList) >= 0){

        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));

        if(updateCurrentDirectoryInternal(nhm->Path()) != 0)
            qDebug() << "Failed to navigate backward";

        emit forNavBtnEnabled(true);

        setAddressBoxData(nhm->Path());
    }
    emit backNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0);
}


void RDirectoryModel::navigateForward(){
    /* this works while popping things out of HistoryList after pointer
     * than switch to it and enable homeBtn, BackBtn.
     * if current page is not secondaryPage than switch to it.
     * if there's still anything left in future HistoryList than enable forwardBtn
     */

    if((++pointerToCurrentDirectoryInNavigationHistoryInfoList) < navigationHistoryInfoList.length()){

        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));

        if(updateCurrentDirectoryInternal(nhm->Path()) == 0){
            emit backNavBtnEnabled(true);
            setAddressBoxData(nhm->Path());
        }
        else
            qDebug() << "Failed to navigate forward";
    }
    emit forNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList < navigationHistoryInfoList.length());
}


void RDirectoryModel::reloadCurrentDirectory(){
    emit reloadBtnEnabled(false);
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));

    wildSearchKey = "";
    if(updateCurrentDirectoryInternal(nhm->Path()) == 0){
        emit forNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList < navigationHistoryInfoList.length());
        emit backNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0);
        emit reloadBtnEnabled(true);

    }
    else
        qDebug() << "Failed to reload, please restart the app";
}


void RDirectoryModel::setWildSearchKey(const QString &WildSearchKey){
    if(wildSearchKey != WildSearchKey){
        wildSearchKey = WildSearchKey;
        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
        updateCurrentDirectoryInternal(nhm->Path());
    }
}


void RDirectoryModel::updateAddressBoxShortcutMenuList(QString jumpAddress){
    QDir shortcutMenu(jumpAddress);
    if(shortcutMenu.exists()){
        addressBoxShortcutMenuList.clear();
        foreach (QFileInfo anotherFile, shortcutMenu.entryInfoList(QDir::Dirs | QDir::NoDotAndDotDot)) {
            FileFolderModel *newModel = new FileFolderModel();
            newModel->setDisplayName(anotherFile.fileName());
            newModel->setPath(anotherFile.filePath());
            addressBoxShortcutMenuList.append(newModel);
        }
        emit AddressBoxShortcutMenuListChanged();
    }
}


void RDirectoryModel::updateSettingsForCurrentDirectory(QString fileOperation, QString newValue){
    QString currentDirectory = addressBoxData;
    QFile settingFile(currentDirectory + "/.rfmDirectorySetting");

    if(settingFile.open(QIODevice::ReadOnly)){
        QByteArray wholeSetting = settingFile.readAll();

        int indexOfSettingValue = wholeSetting.indexOf(fileOperation);
        int nextNewline = wholeSetting.indexOf('\n', indexOfSettingValue);
        nextNewline -= wholeSetting.indexOf('=', indexOfSettingValue);

        if(indexOfSettingValue > 0)
            wholeSetting.replace(indexOfSettingValue + fileOperation.length() + 1,
                                 nextNewline, newValue.toUtf8() + '\n');
        else
            wholeSetting.append(fileOperation + "=" + newValue + "\n");

        settingFile.close();
        if(settingFile.open(QIODevice::WriteOnly | QIODevice::Truncate)){
            settingFile.write(wholeSetting);
            settingFile.close();
        }
    }
    else if(settingFile.open(QIODevice::WriteOnly)) {
        settingFile.write("[Settings]\n");
        settingFile.write((fileOperation + "=" + newValue + "\n").toUtf8());
        settingFile.close();
    }
}


void RDirectoryModel::deleteFile(int index){
    FileFolderModel *model = qobject_cast<FileFolderModel*>(fileFolderList.at(index));

    QFile file(model->Path());
    QString onlyFileName = model->DisplayName();

    bool exist = true;
    for(int i = 0; exist; i++){
        QFile tempFile(QDir::homePath() + "/.local/share/Trash/files/" + onlyFileName);
        if(tempFile.exists()){
            if(onlyFileName.contains("."))
                onlyFileName = onlyFileName.insert(onlyFileName.indexOf("."), QString::number(i));
            else
                onlyFileName.append("(" + QString::number(i) + ")");
        }
        else
            exist = false;
    }

    if(file.rename(QDir::homePath() + "/.local/share/Trash/files" + onlyFileName)){
        QFile trashInfo(QDir::homePath() + "/.local/share/Trash/info" + onlyFileName + ".trashinfo");
        trashInfo.open(QIODevice::WriteOnly);
        QTextStream stream(&trashInfo);
        stream << "[Trash Info]" << "\n";
        stream << "Path=" << model->DisplayName() << "\n";
        stream << "DeletionDate=" << QDateTime::currentDateTime().toString("yyyy-MM-ddThh:mm:ss");
        fileFolderList.removeAt(index);
        emit FileFolderListChanged();
    }
    else
        qDebug() << "Failed to delete file: " + model->DisplayName();
}


bool RDirectoryModel::createNewFolder(QString folderName){
    QDir dir(addressBoxData);

    QFileInfo fileInfo(addressBoxData + "/" + folderName);


    if(fileInfo.exists()){
        int retryCounter = 0;
        while(fileInfo.exists()){
            fileInfo.setFile(addressBoxData + "/" + folderName + " (" + QString::number(++retryCounter) + ")");
        }
        emit createNew_ChooseAnother(fileInfo.fileName());
        emit notify(Error::FileAlreadyExist);
        return false;
    }

    dir.mkdir(folderName);
    reloadCurrentDirectory();
    return true;
}


bool RDirectoryModel::createNewFile(QString fileName, QString fileType){
    QFileInfo fileInfo(addressBoxData + "/" + fileName + "." + fileType);

    if(fileInfo.exists()){
        int retryCounter = 0;
        while(fileInfo.exists()){
            fileInfo.setFile(addressBoxData + "/" + fileName + " (" + QString::number(++retryCounter) + ")" + "." + fileType);
        }
        emit createNew_ChooseAnother(fileInfo.baseName());
        emit notify(Error::FileAlreadyExist);
        return false;
    }

    QFile file(fileInfo.absoluteFilePath());
    if(!file.open(QIODevice::WriteOnly))
        file.close();

    reloadCurrentDirectory();
    return true;
}


void RDirectoryModel::performAction(QString filePath, QString action, QString optionalParam){
    if(action == "open-with"){
        rds.runDesktopService(filePath, optionalParam);
    }
}
