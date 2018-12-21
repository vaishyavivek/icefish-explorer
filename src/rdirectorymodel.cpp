#include "rdirectorymodel.h"
#include "fileFolder/filefoldermodel.h"
#include "models/menumodel.h"
#include "models/navigationhistorymodel.h"
#include "models/addressboxmodel.h"

#include <QDebug>
#include <QDateTime>
#include <QtWidgets/QApplication>
#include <QMimeData>
#include <QUrl>
#include <QByteArray>
#include <QDataStream>
#include <QDrag>
#include <QClipboard>

RDirectoryModel::RDirectoryModel(QObject *parent) : QObject(parent){
    pointerToCurrentDirectoryInNavigationHistoryInfoList = -1;
    properties = new PropertiesInfoModel();
    isHome = false;
    updateCurrentDirectory(QDir::homePath());

    connect(&watcher, &QFileSystemWatcher::directoryChanged, this, &RDirectoryModel::requestToReloadFromQml);

    clipboardContentCount = 0;
    lastOperationType = 0;
    connect(QApplication::clipboard(), &QClipboard::dataChanged, this, &RDirectoryModel::enableClipboardPasting);
    emit enableClipboardPasting();
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
        emit WriteHistoryTabbed(directoryToSwitchTo);

        if(file.isDir()){
            emit TitleChanged(directoryToSwitchTo.mid(directoryToSwitchTo.lastIndexOf('/') + 1));

            QDir localDirectory(directoryToSwitchTo);
            localDirectory.setFilter(QDir::NoDotAndDotDot | QDir::Dirs | QDir::Files);

            if(!wildSearchKey.isEmpty())
                localDirectory.setNameFilters(QStringList() << ("*" + wildSearchKey + "*"));

            getIsBookmarked(&localDirectory);
            getIsHiddenItemsShown(&localDirectory);
            getIsPreviewAvailable(&localDirectory);
            getCurrentView(&localDirectory);
            getSortingRole(&localDirectory);
            getSortingOrder(&localDirectory);
            getSortingPreference(&localDirectory);
            getIconScale(&localDirectory);

            QFileInfoList infoList = localDirectory.entryInfoList();

            if(!watcher.directories().isEmpty())
                watcher.removePaths(watcher.directories());
            watcher.addPath(directoryToSwitchTo);

            //clear current list to update it
            fileFolderList.clear();

            foreach (QFileInfo file, infoList) {
                if((!file.fileName().startsWith("$"))){

                    FileFolderModel *newModel = new FileFolderModel(file);
                    //newModel->setFileType(mimeDb.mimeTypeForFile(file.filePath()).iconName());
                    fileFolderList.append(newModel);
                }
            }
            emit FileFolderListChanged();
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



void RDirectoryModel::setIsBookmarked(const bool IsBookmarked){
    isBookmarked = IsBookmarked;
    settings.setValue(addressBoxData + "/isBookmarked", IsBookmarked);
    emit WriteBookmarkThreaded(addressBoxData, isBookmarked);
    emit IsBookmarkedChanged();
}

void RDirectoryModel::getIsBookmarked(QDir *localDirectory){
    isBookmarked = settings.value(localDirectory->path() + "/isBookmarked").toBool();
    emit IsBookmarkedChanged();
}



void RDirectoryModel::setIsHiddenItemsShown(const bool IsHiddenItemsShown){
    isHiddenItemsShown = IsHiddenItemsShown;
    settings.setValue(addressBoxData + "/isHiddenItemsShown", IsHiddenItemsShown);
    emit IsHiddenItemsShownChanged();
    emit requestToReloadFromQml();
}

void RDirectoryModel::getIsHiddenItemsShown(QDir *localDirectory){

    int globalHidden = settings.value("global/isHiddenItemsShown").toInt();

    isHiddenItemsShown = settings.value(localDirectory->path() + "/isHiddenItemsShown").toBool();

    isHiddenItemsShown = (globalHidden == 1 || (globalHidden == 0 && isHiddenItemsShown));

    if(isHiddenItemsShown)
        localDirectory->setFilter(localDirectory->filter() | QDir::Hidden);

    emit IsHiddenItemsShownChanged();
}



void RDirectoryModel::setIsPreviewAvailable(const bool IsPreviewAvailable){
    if(settings.value("global/isPreviewAvailable").toInt() == 0){
        isPreviewAvailable = IsPreviewAvailable;
        settings.setValue(addressBoxData + "/isPreviewAvailable", IsPreviewAvailable);
        emit IsPreviewAvailableChanged();
    }
}

void RDirectoryModel::getIsPreviewAvailable(QDir *localDirectory){
    int globalPreview = settings.value("global/isPreviewAvailable").toInt();

    isPreviewAvailable = settings.value(localDirectory->path() + "/isPreviewAvailable").toBool();

    isPreviewAvailable = (globalPreview == 1 || (globalPreview == 0 && isPreviewAvailable));

    emit IsPreviewAvailableChanged();
}



void RDirectoryModel::setCurrentView(const int &CurrentView){
    if(settings.value("global/currentView").toInt() == 0){
        currentView = CurrentView;
        settings.setValue(addressBoxData + "/currentView", CurrentView);
        emit CurrentViewChanged();
    }
}

void RDirectoryModel::getCurrentView(QDir *localDirectory){
    int globalView = settings.value("global/currentView").toInt();
    currentView = settings.value(localDirectory->path() + "/currentView").toInt();
    currentView = (globalView == 0) ? currentView : globalView;
    emit CurrentViewChanged();
}



void RDirectoryModel::setSortingRole(const int &SortingRole){
    sortingRole = SortingRole;
    settings.setValue(addressBoxData + "/sortingRole", SortingRole);
}

void RDirectoryModel::getSortingRole(QDir *localDirectory){
    sortingRole = settings.value(localDirectory->path() + "/sortingRole").toInt();

    switch (sortingRole) {
    case 1:
        localDirectory->setSorting(QDir::Type);
        break;
    case 2:
        localDirectory->setSorting(QDir::Size);
        break;
    case 3:
        localDirectory->setSorting(QDir::Time);
        break;
    default:
        localDirectory->setSorting(QDir::Name);
    }
    emit SortingRoleChanged();
}



void RDirectoryModel::setSortingOrder(const int &SortingOrder){
    sortingOrder = SortingOrder;
    settings.setValue(addressBoxData + "/sortingOrder", SortingOrder);
}

void RDirectoryModel::getSortingOrder(QDir *localDirectory){
    sortingOrder = settings.value(localDirectory->path() + "/sortingOrder").toInt();

    if(sortingOrder == 1)
        localDirectory->setSorting(localDirectory->sorting() | QDir::Reversed);
    emit SortingOrderChanged();
}



void RDirectoryModel::setSortingPreference(const int &SortingPreference){
    sortingPreference = SortingPreference;
    settings.setValue(addressBoxData + "/sortingPreference", SortingPreference);
}

void RDirectoryModel::getSortingPreference(QDir *localDirectory){
    sortingPreference = settings.value(localDirectory->path() + "/sortingPreference").toInt();

    if(sortingPreference == 1)
        localDirectory->setSorting(localDirectory->sorting() | QDir::DirsLast);
    else
        localDirectory->setSorting(localDirectory->sorting() | QDir::DirsFirst);
    emit SortingPreferenceChanged();
}



void RDirectoryModel::setIconScale(const int IconScale){
    iconScale = IconScale;
    settings.setValue(addressBoxData + "/iconScale", IconScale);
    emit IconScaleChanged();
}

void RDirectoryModel::getIconScale(QDir *localDirectory){
    iconScale = settings.value("global/iconScale").toInt();

    if(iconScale == 32){
        QVariant var = settings.value(localDirectory->path() + "/iconScale");
        iconScale = (var.isNull() ? 32 : var.toInt());
    }
    emit IconScaleChanged();
}



void RDirectoryModel::enableClipboardPasting(){
    const QMimeData *mime = QApplication::clipboard()->mimeData();
    if(mime->hasUrls())
        clipboardContentCount = mime->urls().length();
    else
        clipboardContentCount = 0;
    emit ClipboardContentCountChanged();
}

void RDirectoryModel::copyOrCutItems(int type, QString filePath){
    QClipboard *clipboard = QApplication::clipboard();
    lastOperationType = type;
    if(filePath.isEmpty()){
        QList<QUrl> urlList;
        foreach(QObject *file, fileFolderList){
            FileFolderModel *fileModel = qobject_cast<FileFolderModel*>(file);
            if(fileModel->Selected())
                urlList.append(QUrl::fromLocalFile(fileModel->Path()));
            fileModel->deleteLater();
        }
        QMimeData *data = new QMimeData;
        data->setUrls(urlList);
        clipboard->setMimeData(data);
    }
    else if(!filePath.isEmpty()){
        QMimeData *data = new QMimeData;
        QList<QUrl> urllist;
        urllist.append(QUrl::fromLocalFile(filePath));
        data->setUrls(urllist);
        clipboard->setMimeData(data);
    }
    emit ClipboardOperationTypeChanged();
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

    QFileInfo dir(filePath);
    if(dir.isDir()){
        MenuModel *newTab = new MenuModel();
        newTab->setServiceName("Open in New tab");
        newTab->setAction("newtab");
        menu.append(newTab);
    }


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

    if(!changedAddress.isEmpty() && changedAddress.compare(addressBoxData) != 0){
        addressBoxData = changedAddress;

        addressBoxDataListView.clear();

        AddressBoxModel *rootModel = new AddressBoxModel();
        rootModel->setDisplayName("Root");
        rootModel->setPath("/");
        addressBoxDataListView.append(rootModel);

        changedAddress = changedAddress.section("/", 1);
        changedAddress.append("/");

        QString refToPreviousData = "/";

        while (changedAddress.indexOf("/") > 1) {
            AddressBoxModel *newModel = new AddressBoxModel();

            QString nextSection = changedAddress.left(changedAddress.indexOf("/"));
            newModel->setDisplayName(nextSection);

            refToPreviousData.append(nextSection + "/");
            newModel->setPath(refToPreviousData);

            addressBoxDataListView.append(newModel);
            changedAddress = changedAddress.section("/", 1);
        }

        emit AddressBoxDataChanged();
        emit AddressBoxDataListViewChanged();
    }
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
        //emit forNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0);
        //if(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0)
        emit forNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList < navigationHistoryInfoList.length() - 1);
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
            AddressBoxModel *newModel = new AddressBoxModel();
            newModel->setDisplayName(anotherFile.fileName());
            newModel->setPath(anotherFile.filePath());
            addressBoxShortcutMenuList.append(newModel);
        }
        emit AddressBoxShortcutMenuListChanged();
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

    if(file.rename(QDir::homePath() + "/.local/share/Trash/files/" + onlyFileName)){
        QFile trashInfo(QDir::homePath() + "/.local/share/Trash/info/" + onlyFileName + ".trashinfo");
        trashInfo.open(QIODevice::WriteOnly);
        QTextStream stream(&trashInfo);
        stream << "[Trash Info]" << "\n";
        stream << "Path=" << model->DisplayName() << "\n";
        stream << "DeletionDate=" << QDateTime::currentDateTime().toString("yyyy-MM-ddThh:mm:ss");
        fileFolderList.removeAt(index);
        emit FileFolderListChanged();
    }
    else
        notify(Error::NoPermission);
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
    return true;
}


void RDirectoryModel::performAction(QString filePath, QString action, QString optionalParam){
    if(action == "open-with")
        rds.runDesktopService(filePath, optionalParam);
    else if(action == "copy")
        copyOrCutItems(0, filePath);
    else if(action == "cut")
        copyOrCutItems(1, filePath);
    else if(action == "properties"){
        properties->setProperties(filePath);
        emit PropertiesChanged();
        emit showProperties();
    }
}
