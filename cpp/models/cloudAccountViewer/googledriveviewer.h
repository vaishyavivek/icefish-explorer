#ifndef GOOGLEDRIVEVIEWER_H
#define GOOGLEDRIVEVIEWER_H

#include "cloudaccountviewer.h"

class GoogleDriveViewer: public CloudAccountViewer{
    Q_OBJECT

public:
    explicit GoogleDriveViewer(QObject *parent = nullptr)
        :CloudAccountViewer(parent){

        setCloudName("Google Drive");
        setCloudIcon("google-drive");
        setIsLinked(2);


        QString token = settings.value("googledrive/token").toString();
        if(token.isEmpty())
            setIsLinked(0);
        else{
            manager = new QNetworkAccessManager(this);
            connect(manager, &QNetworkAccessManager::finished, this, &GoogleDriveViewer::receiveAccountInfo);

            /*request.setUrl(QUrl("https://api.dropboxapi.com/2/users/get_current_account"));
            request.setRawHeader(QByteArray("Authorization"), "Bearer " + token.toUtf8());

            buffer.open(QBuffer::ReadWrite);
            manager->post(request, &buffer);*/

            accountInfoReceived = false;
        }
    }

private slots:
    void receiveAccountInfo(QNetworkReply *reply) override{
        if(reply->error() == QNetworkReply::NoError && !accountInfoReceived){

        }
    }

    void receiveSpaceInfo(QNetworkReply *reply) override{
        if(reply->error() == QNetworkReply::NoError && !spaceInfoReceived){

        }
    }
};

#endif // GOOGLEDRIVEVIEWER_H
