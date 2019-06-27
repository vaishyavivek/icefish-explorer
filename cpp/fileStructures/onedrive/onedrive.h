/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
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

    void getRootDirectory();
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
