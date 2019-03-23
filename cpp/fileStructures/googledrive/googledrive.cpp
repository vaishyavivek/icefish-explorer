#include "googledrive.h"
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include "../../models/fileFolder/filefoldermodel.h"

GoogleDrive::GoogleDrive(RAbstractDirectoryModel *parent)
    :RAbstractDirectoryModel (parent){
    authorize();
}

void GoogleDrive::authorize(){
    oauth2 = new QOAuth2AuthorizationCodeFlow(this);
    oauth2->setClientIdentifier("597675045346-va3odvu1lcl3pavj9ofarct4rq1grgne.apps.googleusercontent.com");
    oauth2->setClientIdentifierSharedKey("_ekr0D7RVYScr2WYgAqAAj5i");
    oauth2->setAuthorizationUrl(QUrl("https://www.GoogleDrive.com/oauth2/authorize"));
    oauth2->setAccessTokenUrl(QUrl("https://api.GoogleDriveapi.com/oauth2/token"));
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, &QDesktopServices::openUrl);
    auto replyHandler = new QOAuthHttpServerReplyHandler(2377, this);
    oauth2->setReplyHandler(replyHandler);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::granted, this, &GoogleDrive::isGranted);
    oauth2->grant();
}

void GoogleDrive::isGranted(){
    updateCurrentDirectory("");
}

void GoogleDrive::updateCurrentDirectory(QString newDirectoryToSwitchTo){
    fileFolderList.clear();
    QVariantMap parameters;
    parameters.insert("path", newDirectoryToSwitchTo);
    //parameters.insert("recursive", false);
    parameters.insert("include_deleted", false);
    parameters.insert("include_has_explicit_shared_members", false);
    parameters.insert("include_mounted_folders", true);

    QUrl query("https://api.GoogleDriveapi.com/2/files/list_folder");

    oauth2->setContentType(QAbstractOAuth::ContentType::Json);
    connect(oauth2, &QOAuth2AuthorizationCodeFlow::finished, this, &GoogleDrive::receiveDirectoryInfo);
    oauth2->post(query, parameters);
}

void GoogleDrive::receiveDirectoryInfo(QNetworkReply *reply){
    if(reply->error() == QNetworkReply::NoError){
        QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
        QJsonArray jsonArr = jsonDoc.object()["entries"].toArray();

        foreach (const QJsonValue &anotherValue, jsonArr) {
            QJsonObject obj = anotherValue.toObject();

            FileFolderModel *newModel = new FileFolderModel();
            newModel->setDisplayName(obj["name"].toString());
            newModel->setPath(obj["path_display"].toString());
            newModel->setDate_Time_Modified(obj["client_modified"].toString());
            //newModel->setFileSize(obj["size"].toDouble());
            fileFolderList.append(newModel);
        }
        emit FileFolderListChanged();
        emit FileFolderListCountChanged();

        qDebug() << jsonArr;
    }
}

void GoogleDrive::updateAddressBoxShortcutMenuList(QString jumpAddress){

}

void GoogleDrive::setAddressBoxData(QString changedAddress){

}

void GoogleDrive::setWildSearchKey(const QString &WildSearchKey){

}

void GoogleDrive::navigateBackward(){

}

void GoogleDrive::navigateForward(){

}

void GoogleDrive::reloadCurrentDirectory(){

}

void GoogleDrive::deleteFile(int index){

}

bool GoogleDrive::createNewFolder(QString folderName){

}

bool GoogleDrive::createNewFile(QString fileName, QString fileType){

}

void GoogleDrive::performAction(QString filePath, QString action, QString optionalParam){

}

void GoogleDrive::copyOrCutItems(int type, QString filePath){

}
