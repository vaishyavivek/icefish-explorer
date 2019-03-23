#ifndef DROPBOX_H
#define DROPBOX_H

#include "../rabstractdirectorymodel.h"
#include "../../models/addressboxmodel.h"
#include <QOAuth2AuthorizationCodeFlow>
#include <QDesktopServices>
#include <QOAuthHttpServerReplyHandler>
#include <QNetworkReply>
#include <QJsonDocument>

class Dropbox : public RAbstractDirectoryModel{
    Q_OBJECT
public:
    explicit Dropbox(RAbstractDirectoryModel *parent = nullptr);

    void updateCurrentDirectory(QString newDirectoryToSwitchTo);
    void updateAddressBoxShortcutMenuList(QString jumpAddress = "");
    void setAddressBoxData(QString changedAddress = "");
    void setWildSearchKey(const QString &WildSearchKey);

    void navigateBackward();
    void navigateForward();
    void reloadCurrentDirectory();

public slots:
    void deleteFile(int index);
    bool createNewFolder(QString folderName);
    bool createNewFile(QString fileName, QString fileType);
    void performAction(QString filePath, QString action, QString optionalParam = "");
    void copyOrCutItems(int type, QString filePath = "");

    void isGranted();

private slots:
    void receiveDirectoryInfo(QNetworkReply *reply);
    void receiveDeletedInfo(QNetworkReply *reply);
    void receiveCreateNewFolderInfo(QNetworkReply *reply);
    void receiveCreateNewFileInfo(QNetworkReply *reply);

private:
    bool currentRequestCompleted;
    bool backRequestReceived, forRequestReceived;
    void authorize();
    QOAuth2AuthorizationCodeFlow *oauth2;
};

#endif // DROPBOX_H

