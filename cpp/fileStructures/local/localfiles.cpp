/* $Id: localfiles.cpp
 * IceFish Explorer is a free File Manager for Linux Desktops for managing
 * local files as well as files on cloud, Dropbox, Onedrive, Googledrive.
 * Additionally, it also serves as a multimedia explorer for your photos,
 * music, videos, documents and other files by providing built-in plugins
 * to open them.
 * © IceFish Community, 2019
 *
 * This file is part of IceFish Explorer.
 *
 * IceFish Explorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * IceFish Explorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with IceFish Explorer.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * The project is hosted here,
 * http://www.icefish.tech/index/explorer/0-5
*/

#include "localfiles.h"

LocalFiles::LocalFiles(QObject *parent)
    :RAbstractDirectoryModel (parent){

    updateCurrentDirectory(QDir::homePath());
    connect(&watcher, &QFileSystemWatcher::directoryChanged, this, &LocalFiles::requestToReloadFromQml);

    clipboardContentCount = 0;
    connect(QApplication::clipboard(), &QClipboard::dataChanged, this, &LocalFiles::enableClipboardPasting);
    emit enableClipboardPasting();
}

void LocalFiles::updateCurrentDirectory(QString newDirectoryToSwitchTo){
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


/* this is a internal function which takes care of updating secondaryPage for directory to directory navigation
 * we first check whether the address provided is of a directory or a file,
 * if its a file than call Qt-desktopService to open it in external app as prescribed by the DE;
 * else if its new address is a directory, than switch to it
 *
 */
int LocalFiles::updateCurrentDirectoryInternal(QString directoryToSwitchTo){

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
            emit FileFolderListCountChanged();
            return 0;//no error
        }
        else if(file.isFile()){
            runDesktopService(directoryToSwitchTo);
            return 2;//destop service opened
        }
        else return 3;//unknown error
    }
    else
        return 1;//file doesn't exist
}

bool LocalFiles::runDesktopService(QString filePath){
    return QProcess::startDetached("xdg-open " + filePath);
}

bool LocalFiles::runDesktopService(QString filePath, QString desktopFilePath){

    QFile desktopFile("/usr/share/applications/" + desktopFilePath);
    if(desktopFile.open(QIODevice::ReadOnly)){
        QString wholeFile = desktopFile.readAll();
        wholeFile = wholeFile.mid(wholeFile.indexOf("Exec=") + 5);
        wholeFile = wholeFile.left(wholeFile.indexOf('\n'));
        if(wholeFile.contains('%'))
            wholeFile = wholeFile.left(wholeFile.indexOf('%'));

        if(!QProcess::startDetached(wholeFile + "\"" + filePath + "\""))
            QProcess::startDetached(wholeFile, QStringList() << filePath);

        desktopFile.close();
        return true;
    }
    return false;
}

/* to update the URLbox whenever there's a change in the current directory
 * we're using normal FileFolderModel as the template for sake of simplicity and to reduce source code size
 * by default a 'Root' is added if the current directory is root instead of ordinary '/'
 */

void LocalFiles::setAddressBoxData(QString changedAddress){

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


void LocalFiles::copyOrCutItems(int type, QString filePath){
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


void LocalFiles::navigateBackward(){
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


void LocalFiles::navigateForward(){
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


void LocalFiles::reloadCurrentDirectory(){
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

void LocalFiles::setWildSearchKey(const QString &WildSearchKey){
    if(wildSearchKey != WildSearchKey){
        wildSearchKey = WildSearchKey;
        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
        updateCurrentDirectoryInternal(nhm->Path());
    }
}

void LocalFiles::deleteFile(int index){
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
        emit FileFolderListCountChanged();
    }
    else
        notify(Error::NoPermission);
}


bool LocalFiles::createNewFolder(QString folderName){
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


bool LocalFiles::createNewFile(QString fileName, QString fileType){
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


void LocalFiles::updateAddressBoxShortcutMenuList(QString jumpAddress){
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

void LocalFiles::performAction(QString filePath, QString action, QString optionalParam){
    if(action == "open-with")
        runDesktopService(filePath, optionalParam);
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
