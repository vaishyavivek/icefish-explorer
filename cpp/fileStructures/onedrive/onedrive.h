#ifndef ONEDRIVE_H
#define ONEDRIVE_H

#include "../rabstractdirectorymodel.h"
#include "../../models/addressboxmodel.h"
#include <QOAuth2AuthorizationCodeFlow>
#include <QDesktopServices>
#include <QOAuthHttpServerReplyHandler>
#include <QNetworkReply>
#include <QJsonDocument>

class OneDrive : public RAbstractDirectoryModel{
    Q_OBJECT
public:
    explicit OneDrive(RAbstractDirectoryModel *parent = nullptr);

    void updateCurrentDirectory(QString newDirectoryID);
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
    //void requestAccessToken(QVariantMap );
    //void retrieveAccessToken(QNetworkReply *);

    void receiveDirectoryInfo(QNetworkReply *reply);
    void receiveDeletedInfo(QNetworkReply *reply);
    void receiveCreateNewFolderInfo(QNetworkReply *reply);
    void receiveCreateNewFileInfo(QNetworkReply *reply);

private:
    bool currentRequestCompleted;
    bool backRequestReceived, forRequestReceived;
    QString driveId;
    void authorize();
    QOAuth2AuthorizationCodeFlow *oauth2;
};

#endif // ONEDRIVE_H


class CustomHttpListener: public QOAuthHttpServerReplyHandler{
    Q_OBJECT

public:
    CustomHttpListener(QOAuthHttpServerReplyHandler *parent = nullptr)
        :QOAuthHttpServerReplyHandler(QHostAddress("http://localhost"), 2377, parent){}

    QString callback() const override{
        //Q_ASSERT(this->isListening());
        const QUrl url(QString::fromLatin1("http://localhost:2377"));
        return url.toString(QUrl::EncodeDelimiters);
    }


};
