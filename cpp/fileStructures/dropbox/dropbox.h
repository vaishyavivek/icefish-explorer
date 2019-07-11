/* $Id: dropbox.h
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

