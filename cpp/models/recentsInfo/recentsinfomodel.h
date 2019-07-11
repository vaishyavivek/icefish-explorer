/* $Id: recentsinfomodel.h
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

#ifndef RECENTSINFOMODEL_H
#define RECENTSINFOMODEL_H

#include <QObject>

class RecentsInfoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString DisplayName READ DisplayName WRITE setDisplayName NOTIFY DisplayNameChanged)
    Q_PROPERTY(QString ActualPath READ ActualPath WRITE setActualPath NOTIFY ActualPathChanged)
    Q_PROPERTY(QString TimeAccessed READ TimeAccessed WRITE setTimeAccessed NOTIFY TimeAccessedChanged)
    Q_PROPERTY(QString DateAccessed READ DateAccessed WRITE setDateAccessed NOTIFY DateAccessedChanged)
    Q_PROPERTY(QString IconPath READ IconPath WRITE setIconPath NOTIFY IconPathChanged)

public:
    explicit RecentsInfoModel(QObject *parent = nullptr);

    QString DisplayName() const {return displayName;}
    void setDisplayName(const QString &DisplayName) { displayName = DisplayName;}

    QString ActualPath() const { return actualPath;}
    void setActualPath(const QString &ActualPath) {actualPath = ActualPath;}

    QString TimeAccessed() const { return timeAccessed;}
    void setTimeAccessed(const QString &TimeAccessed) { timeAccessed = TimeAccessed;}

    QString DateAccessed() const { return dateAccessed;}
    void setDateAccessed(const QString &DateAccessed) { dateAccessed = DateAccessed;}

    QString IconPath() const { return iconPath;}
    void setIconPath(const QString &IconPath){ iconPath = IconPath;}

signals:
    void DisplayNameChanged();
    void ActualPathChanged();
    void TimeAccessedChanged();
    void DateAccessedChanged();
    void IconPathChanged();

private:
    QString displayName;
    QString actualPath;
    QString timeAccessed;
    QString dateAccessed;
    QString iconPath;
};

#endif // RECENTSINFOMODEL_H

#ifndef HISTORYKEEPER_H
#define HISTORYKEEPER_H

class HistoryKeeper: public QObject{
    Q_OBJECT
public:
    HistoryKeeper(QObject *parent = nullptr);

public slots:
    void WriteHistoryAsync(QString fileAccessed);

private:
    void refineMostlyVisitedSites();

    QString historyFilePath;
};

#endif //HISTORYKEEPER_H
