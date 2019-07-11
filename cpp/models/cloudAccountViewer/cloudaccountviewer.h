/* $Id: cloudaccountviewer.h
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

#ifndef CLOUDACCOUNTVIEWER_H
#define CLOUDACCOUNTVIEWER_H

#include <QObject>
#include <QSettings>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkAccessManager>
#include <QBuffer>

class CloudAccountViewer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int IsLinked READ IsLinked WRITE setIsLinked NOTIFY IsLinkedChanged)
    Q_PROPERTY(QString CloudName READ CloudName WRITE setCloudName NOTIFY CloudNameChanged)
    Q_PROPERTY(QString CloudIcon READ CloudIcon WRITE setCloudIcon NOTIFY CloudIconChanged)
    Q_PROPERTY(QString UserId READ UserId WRITE setUserId NOTIFY UserIdChanged)
    Q_PROPERTY(QString UserName READ UserName WRITE setUserName NOTIFY UserNameChanged)
    Q_PROPERTY(QString UserImage READ UserImage WRITE setUserImage NOTIFY UserImageChanged)
    Q_PROPERTY(QString Email READ Email WRITE setEmail NOTIFY EmailChanged)
    Q_PROPERTY(QString Locale READ Locale WRITE setLocale NOTIFY LocaleChanged)
    Q_PROPERTY(QString AccountType READ AccountType WRITE setAccountType NOTIFY AccountTypeChanged)
    Q_PROPERTY(double UsedSpace READ UsedSpace WRITE setUsedSpace NOTIFY UsedSpaceChanged)
    Q_PROPERTY(double AllocatedSpace READ AllocatedSpace WRITE setAllocatedSpace NOTIFY AllocatedSpaceChanged)
    Q_PROPERTY(QString SpaceUsage READ SpaceUsage NOTIFY SpaceUsageChanged)

public:
    explicit CloudAccountViewer(QObject *parent = nullptr);

    int IsLinked() const{ return isLinked;}
    void setIsLinked(const int IsLinked){ isLinked = IsLinked;}

    QString CloudName() const{ return cloudName;}
    void setCloudName(const QString &CloudName){ cloudName = CloudName;}

    QString CloudIcon() const{ return cloudIcon;}
    void setCloudIcon(const QString &CloudIcon){ cloudIcon = CloudIcon;}

    QString UserId() const{ return userId;}
    void setUserId(const QString &UserId){ userId = UserId;}

    QString UserName() const{ return userName;}
    void setUserName(const QString &UserName){ userName = UserName;}

    QString UserImage() const{ return userImage;}
    void setUserImage(const QString &UserImage){ userImage = UserImage;}

    QString Email() const{ return email;}
    void setEmail(const QString &Email){ email = Email;}

    QString Locale() const{ return locale;}
    void setLocale(const QString &Locale){ locale = Locale;}

    QString AccountType() const{ return accountType;}
    void setAccountType(const QString &AccountType){ accountType = AccountType;}

    double UsedSpace() const{ return usedSpace;}
    void setUsedSpace(const double &UsedSpace){ usedSpace = UsedSpace;}

    double AllocatedSpace() const{ return allocatedSpace;}
    void setAllocatedSpace(const double &AllocatedSpace){ allocatedSpace = AllocatedSpace;}

    QString SpaceUsage() const{ return spaceUsage;}
    void setSpaceUsage();

signals:
    void IsLinkedChanged();
    void CloudNameChanged();
    void CloudIconChanged();
    void UserIdChanged();
    void UserNameChanged();
    void UserImageChanged();
    void EmailChanged();
    void LocaleChanged();
    void AccountTypeChanged();
    void UsedSpaceChanged();
    void AllocatedSpaceChanged();
    void SpaceUsageChanged();

protected slots:
    virtual void receiveAccountInfo(QNetworkReply *reply) = 0;
    virtual void receiveSpaceInfo(QNetworkReply *reply) = 0;

private:
    int isLinked;
    QString cloudName;
    QString cloudIcon;
    QString userId;
    QString userName;
    QString userImage;
    QString email;
    QString locale;
    QString accountType;
    double usedSpace;
    double allocatedSpace;
    QString spaceUsage;

protected:
    QNetworkAccessManager *manager;
    QNetworkRequest request;
    QSettings settings;
    bool accountInfoReceived, spaceInfoReceived;
};

#endif // CLOUDACCOUNTVIEWER_H
