#include "dropbox.h"
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include "../../models/fileFolder/filefoldermodel.h"

Dropbox::Dropbox(RAbstractDirectoryModel *parent)
    :RAbstractDirectoryModel (parent){
    authorize();
    backRequestReceived = false;
    forRequestReceived = false;
}

void Dropbox::authorize(){
    oauth2 = new QOAuth2AuthorizationCodeFlow(this);
    oauth2->setClientIdentifier("gw8ah1xnvyidcqc");
    oauth2->setClientIdentifierSharedKey("q3obr0ioxi0jqjy");
    oauth2->setAuthorizationUrl(QUrl("https://www.dropbox.com/oauth2/authorize"));
    oauth2->setAccessTokenUrl(QUrl("https://api.dropboxapi.com/oauth2/token"));
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, &QDesktopServices::openUrl);
    auto replyHandler = new QOAuthHttpServerReplyHandler(2377, this);
    oauth2->setReplyHandler(replyHandler);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::granted, this, &Dropbox::isGranted);
    oauth2->grant();
}

void Dropbox::isGranted(){
    updateCurrentDirectory("");
}

void Dropbox::updateCurrentDirectory(QString newDirectoryToSwitchTo){
    emit backNavBtnEnabled(false);
    emit forNavBtnEnabled(false);

    fileFolderList.clear();
    QVariantMap parameters;
    parameters.insert("path", newDirectoryToSwitchTo);
    //parameters.insert("recursive", false);
    parameters.insert("include_deleted", false);
    parameters.insert("include_has_explicit_shared_members", false);
    parameters.insert("include_mounted_folders", true);

    QUrl query("https://api.dropboxapi.com/2/files/list_folder");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &Dropbox::receiveDirectoryInfo);
    oauth2->post(query, parameters);
    addressBoxData = newDirectoryToSwitchTo;
    currentRequestCompleted = false;
}

void Dropbox::receiveDirectoryInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError && !currentRequestCompleted){
        if(!forRequestReceived && !backRequestReceived){
            for(int i = navigationHistoryInfoList.length() ; i > pointerToCurrentDirectoryInNavigationHistoryInfoList; i--){
                navigationHistoryInfoList.removeAt(i);
            }
        }

        QDir localDirectory(addressBoxData);
        wildSearchKey = "";
        emit WildSearchKeyChanged();

        getIsBookmarked(&localDirectory);
        getIsHiddenItemsShown(&localDirectory);
        getIsPreviewAvailable(&localDirectory);
        getCurrentView(&localDirectory);
        getSortingRole(&localDirectory);
        getSortingOrder(&localDirectory);
        getSortingPreference(&localDirectory);
        getIconScale(&localDirectory);

        QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
        QJsonArray jsonArr = jsonDoc.object()["entries"].toArray();

        foreach (const QJsonValue &anotherValue, jsonArr) {
            QJsonObject obj = anotherValue.toObject();

            FileFolderModel *newModel = new FileFolderModel();
            newModel->setDisplayName(obj["name"].toString());
            newModel->setPath(obj["path_display"].toString());
            newModel->setDate_Time_Modified(obj["client_modified"].toString());
            newModel->setFileType(obj[".tag"].toString());
            newModel->setFileSize(obj["size"].toInt());
            fileFolderList.append(newModel);
        }
        emit FileFolderListChanged();
        emit FileFolderListCountChanged();

        if(!backRequestReceived){
            pointerToCurrentDirectoryInNavigationHistoryInfoList++;
            if(!forRequestReceived){
                NavigationHistoryModel *nhm = new NavigationHistoryModel(addressBoxData);
                navigationHistoryInfoList.append(nhm);
            }
            else
                emit forNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList + 1 < navigationHistoryInfoList.length());
            forRequestReceived = false;
            backNavBtnEnabled(true);
        }
        else{
            pointerToCurrentDirectoryInNavigationHistoryInfoList--;
            backRequestReceived = false;
            forNavBtnEnabled(true);
        }

        setAddressBoxData(addressBoxData);
        currentRequestCompleted = true;
        reloadBtnEnabled(true);
    }
}

void Dropbox::updateAddressBoxShortcutMenuList(QString jumpAddress){

}

void Dropbox::setAddressBoxData(QString changedAddress){
    if(changedAddress != addressBoxData)
        changedAddress = addressBoxData;

    addressBoxData = changedAddress;

    addressBoxDataListView.clear();

    AddressBoxModel *rootModel = new AddressBoxModel();
    rootModel->setDisplayName("Dropbox");
    rootModel->setPath("");
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

void Dropbox::setWildSearchKey(const QString &WildSearchKey){

}

void Dropbox::navigateBackward(){
    if((pointerToCurrentDirectoryInNavigationHistoryInfoList) >= 0){

        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList - 1));

        backRequestReceived = true;
        updateCurrentDirectory(nhm->Path());
        emit forNavBtnEnabled(true);
        setAddressBoxData(nhm->Path());
    }
    emit backNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0);
}

void Dropbox::navigateForward(){
    if(pointerToCurrentDirectoryInNavigationHistoryInfoList < navigationHistoryInfoList.length()){
        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList + 1));

        updateCurrentDirectory(nhm->Path());
        forRequestReceived = true;
        emit backNavBtnEnabled(true);
    }
}

void Dropbox::reloadCurrentDirectory(){
    emit reloadBtnEnabled(false);
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
    updateCurrentDirectory(nhm->Path());
}

void Dropbox::deleteFile(int index){
    FileFolderModel *ffm = qobject_cast<FileFolderModel*>(fileFolderList.at(index));

    QVariantMap parameters;
    parameters.insert("path", ffm->Path());

    QUrl query("https://api.dropboxapi.com/2/files/delete_v2");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &Dropbox::receiveDeletedInfo);
    oauth2->post(query, parameters);
}

void Dropbox::receiveDeletedInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError){
        reloadCurrentDirectory();
    }
}

bool Dropbox::createNewFolder(QString folderName){
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));

    foreach(QObject *obj, fileFolderList){
        FileFolderModel *ffm = qobject_cast<FileFolderModel*>(obj);
        if(ffm->DisplayName().compare(folderName) == 0){
            emit notify(Error::FileAlreadyExist);
            return false;
        }
    }

    QVariantMap parameters;
    parameters.insert("path", nhm->Path() + "/" + folderName);
    parameters.insert("autorename", true);

    QUrl query("https://api.dropboxapi.com/2/files/delete_v2");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &Dropbox::receiveCreateNewFolderInfo);
    oauth2->post(query, parameters);
    return true;
}

void Dropbox::receiveCreateNewFolderInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError){
        reloadCurrentDirectory();
    }
}

bool Dropbox::createNewFile(QString fileName, QString fileType){
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));

    foreach(QObject *obj, fileFolderList){
        FileFolderModel *ffm = qobject_cast<FileFolderModel*>(obj);
        if(ffm->DisplayName().compare(fileName) == 0){
            emit notify(Error::FileAlreadyExist);
            return false;
        }
    }

    QVariantMap parameters;
    parameters.insert("title", fileName);
    parameters.insert("path", nhm->Path());

    QUrl query("https://api.dropboxapi.com/2/file_requests/create");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &Dropbox::receiveCreateNewFileInfo);
    oauth2->post(query, parameters);
    return true;
}

void Dropbox::receiveCreateNewFileInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError){
        reloadCurrentDirectory();
    }
}

void Dropbox::performAction(QString filePath, QString action, QString optionalParam){

}

void Dropbox::copyOrCutItems(int type, QString filePath){

}
