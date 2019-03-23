#include "onedrive.h"
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include "../../models/fileFolder/filefoldermodel.h"
#include <QUrlQuery>

OneDrive::OneDrive(RAbstractDirectoryModel *parent)
    :RAbstractDirectoryModel (parent){
    authorize();
    backRequestReceived = false;
    forRequestReceived = false;
}

void OneDrive::authorize(){
    oauth2 = new QOAuth2AuthorizationCodeFlow(this);
    oauth2->setClientIdentifier("9d8e7019-7164-4d89-a12a-f9af8c2dc871");
    oauth2->setClientIdentifierSharedKey("1auG(GbOOCKO:.Tg3(b{");
    oauth2->setScope("files.readwrite.all");
    oauth2->setAuthorizationUrl(QUrl("https://login.microsoftonline.com/common/oauth2/v2.0/authorize"));
    oauth2->setAccessTokenUrl(QUrl("https://login.microsoftonline.com/common/oauth2/v2.0/token"));
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, &QDesktopServices::openUrl);
    auto replyHandler = new CustomHttpListener();
    oauth2->setReplyHandler(replyHandler);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::granted, this, &OneDrive::isGranted);
    //connect(oauth2, &QOAuth2AuthorizationCodeFlow::authorizationCallbackReceived, this, &OneDrive::requestAccessToken);
    oauth2->grant();
}

void OneDrive::isGranted(){
    emit backNavBtnEnabled(false);
    emit forNavBtnEnabled(false);
    QUrl query("https://graph.microsoft.com/v1.0/me/drive/root/children");
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &OneDrive::receiveDirectoryInfo);
    oauth2->get(query);
    addressBoxData = "OneDrive";
    emit TitleChanged(addressBoxData);
    currentRequestCompleted = false;
}

void OneDrive::updateCurrentDirectory(QString newDirectoryID){
    emit backNavBtnEnabled(false);
    emit forNavBtnEnabled(false);

    fileFolderList.clear();

    QUrl query("https://graph.microsoft.com/v1.0/drives/" + driveId + "/items/" + newDirectoryID + "/children");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &OneDrive::receiveDirectoryInfo);
    oauth2->get(query);
    addressBoxData = newDirectoryID;
    currentRequestCompleted = false;
}

void OneDrive::receiveDirectoryInfo(QNetworkReply *reply){
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
        QJsonArray jsonArr = jsonDoc.object()["value"].toArray();

        foreach (const QJsonValue &anotherValue, jsonArr) {
            QJsonObject obj = anotherValue.toObject();

            FileFolderModel *newModel = new FileFolderModel();
            newModel->setDisplayName(obj["name"].toString());
            newModel->setDate_Time_Modified(obj["lastModifiedDateTime"].toString());
            newModel->setPath(obj["id"].toString());

            QJsonValue parentRefArr = obj["parentReference"].toObject();
            if(driveId != parentRefArr["driveId"].toString())
                driveId = parentRefArr["driveId"].toString();

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

void OneDrive::updateAddressBoxShortcutMenuList(QString jumpAddress){

}

void OneDrive::setAddressBoxData(QString changedAddress){
    if(changedAddress != addressBoxData)
        changedAddress = addressBoxData;

    addressBoxData = changedAddress;

    addressBoxDataListView.clear();

    AddressBoxModel *rootModel = new AddressBoxModel();
    rootModel->setDisplayName("OneDrive");
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

void OneDrive::setWildSearchKey(const QString &WildSearchKey){

}

void OneDrive::navigateBackward(){
    if((pointerToCurrentDirectoryInNavigationHistoryInfoList) >= 0){

        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList - 1));

        backRequestReceived = true;
        updateCurrentDirectory(nhm->Path());
        emit forNavBtnEnabled(true);
        setAddressBoxData(nhm->Path());
    }
    emit backNavBtnEnabled(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0);
}

void OneDrive::navigateForward(){
    if(pointerToCurrentDirectoryInNavigationHistoryInfoList < navigationHistoryInfoList.length()){
        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList + 1));

        updateCurrentDirectory(nhm->Path());
        forRequestReceived = true;
        emit backNavBtnEnabled(true);
    }
}

void OneDrive::reloadCurrentDirectory(){
    emit reloadBtnEnabled(false);
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
    updateCurrentDirectory(nhm->Path());
}

void OneDrive::deleteFile(int index){
    FileFolderModel *ffm = qobject_cast<FileFolderModel*>(fileFolderList.at(index));

    QVariantMap parameters;
    parameters.insert("path", ffm->Path());

    QUrl query("https://api.OneDriveapi.com/2/files/delete_v2");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &OneDrive::receiveDeletedInfo);
    oauth2->post(query, parameters);
}

void OneDrive::receiveDeletedInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError){
        reloadCurrentDirectory();
    }
}

bool OneDrive::createNewFolder(QString folderName){
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

    QUrl query("https://api.OneDriveapi.com/2/files/delete_v2");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &OneDrive::receiveCreateNewFolderInfo);
    oauth2->post(query, parameters);
    return true;
}

void OneDrive::receiveCreateNewFolderInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError){
        reloadCurrentDirectory();
    }
}

bool OneDrive::createNewFile(QString fileName, QString fileType){
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

    QUrl query("https://api.OneDriveapi.com/2/file_requests/create");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &OneDrive::receiveCreateNewFileInfo);
    oauth2->post(query, parameters);
    return true;
}

void OneDrive::receiveCreateNewFileInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError){
        reloadCurrentDirectory();
    }
}

void OneDrive::performAction(QString filePath, QString action, QString optionalParam){

}

void OneDrive::copyOrCutItems(int type, QString filePath){

}
