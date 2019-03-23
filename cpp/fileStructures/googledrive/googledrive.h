#ifndef GOOGLEDRIVE_H
#define GOOGLEDRIVE_H

#include "../rabstractdirectorymodel.h"
#include <QOAuth2AuthorizationCodeFlow>
#include <QDesktopServices>
#include <QOAuthHttpServerReplyHandler>
#include <QNetworkReply>
#include <QJsonDocument>

class GoogleDrive : public RAbstractDirectoryModel{
    Q_OBJECT
public:
    explicit GoogleDrive(RAbstractDirectoryModel *parent = nullptr);

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

private:
    void authorize();
    QOAuth2AuthorizationCodeFlow *oauth2;
};

#endif // GOOGLEDRIVE_H
