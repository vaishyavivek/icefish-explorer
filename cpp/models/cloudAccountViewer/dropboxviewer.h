/* $Id: dropboxviewer.h
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

#ifndef DROPBOXVIEWER_H
#define DROPBOXVIEWER_H

#include "cloudaccountviewer.h"


class DropboxViewer: public CloudAccountViewer{
    Q_OBJECT

public:
    explicit DropboxViewer(QObject *parent = nullptr)
        :CloudAccountViewer(parent){

        setCloudName("Dropbox");
        setCloudIcon("dropbox");
        setIsLinked(2);


        QString token = settings.value("dropbox/token").toString();
        if(token.isEmpty())
            setIsLinked(0);
        else{
            manager = new QNetworkAccessManager(this);
            connect(manager, &QNetworkAccessManager::finished, this, &DropboxViewer::receiveAccountInfo);

            request.setUrl(QUrl("https://api.dropboxapi.com/2/users/get_current_account"));
            request.setRawHeader(QByteArray("Authorization"), "Bearer " + token.toUtf8());

            buffer.open(QBuffer::ReadWrite);
            manager->post(request, &buffer);

            accountInfoReceived = false;
        }
    }

private slots:
    void receiveAccountInfo(QNetworkReply *reply) override{
        if(reply->error() == QNetworkReply::NoError && !accountInfoReceived){
            QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
            auto jsonObj = jsonDoc.object();

            auto accountId = jsonObj["account_id"].toString();
            setUserId(accountId);
            emit UserIdChanged();

            auto nameObj = jsonObj["name"].toObject();
            setUserName(nameObj["display_name"].toString());
            emit UserNameChanged();

            auto email = jsonObj["email"].toString();
            setEmail(email);
            emit EmailChanged();

            auto accountType = jsonObj["account_type"].toObject()[".tag"].toString();
            setAccountType(accountType);
            emit AccountTypeChanged();

            auto locale = jsonObj["locale"].toString() + jsonObj["country"].toString();
            setLocale(locale);
            emit LocaleChanged();

            setIsLinked(1);
            emit IsLinkedChanged();
            accountInfoReceived = true;

            connect(manager, &QNetworkAccessManager::finished, this, &DropboxViewer::receiveSpaceInfo);
            request.setUrl(QUrl("https://api.dropboxapi.com/2/users/get_space_usage"));
            manager->post(request, &buffer);

            spaceInfoReceived = false;
        }
    }

    void receiveSpaceInfo(QNetworkReply *reply) override{
        if(reply->error() == QNetworkReply::NoError && !spaceInfoReceived){
            QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
            auto jsonObj = jsonDoc.object();

            auto used = jsonObj["used"].toDouble();
            setUsedSpace(used);
            emit UsedSpaceChanged();

            auto allocated = jsonObj["allocation"].toObject()["allocated"].toDouble();
            setAllocatedSpace(allocated);
            emit AllocatedSpaceChanged();
            spaceInfoReceived = true;
            setSpaceUsage();
        }
    }

private:
    QBuffer buffer;
};

#endif // DROPBOXVIEWER_H
