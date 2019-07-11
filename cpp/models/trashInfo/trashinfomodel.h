/* $Id: trashinfomodel.h
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

#ifndef TRASHINFOMODEL_H
#define TRASHINFOMODEL_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include "../notification/notificationmodel.h"

class TrashInfoModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString DisplayName READ DisplayName WRITE setDisplayName NOTIFY DisplayNameChanged)
    Q_PROPERTY(QString CurrentPath READ CurrentPath WRITE setCurrentPath NOTIFY CurrentPathChanged)
    Q_PROPERTY(QString ActualPath READ ActualPath WRITE setActualPath NOTIFY ActualPathChanged)
    Q_PROPERTY(QString DeletedDate READ DeletedDate WRITE setDeletedDate NOTIFY DeletedDateChanged)
    Q_PROPERTY(QString FileSize READ FileSize NOTIFY FileSizeChanged)
    Q_PROPERTY(QString FileType READ FileType WRITE setFileType NOTIFY FileTypeChanged)
    Q_PROPERTY(QString IconPath READ IconPath WRITE setIconPath NOTIFY IconPathChanged)

public:
    TrashInfoModel(QObject *parent = nullptr)
        :QObject (parent){}

    TrashInfoModel(const QString &DisplayName, const QString &ActualPath, const QString &DeletedDate, QObject *parent = nullptr)
        :QObject(parent), displayName(DisplayName), actualPath(ActualPath), deletedDate(DeletedDate) {}

    QString DisplayName() const{return displayName;}
    void setDisplayName(QString DisplayName){ displayName = DisplayName;}

    QString CurrentPath() const{return currentPath;}
    void setCurrentPath(QString CurrentPath){ currentPath = CurrentPath;}

    QString ActualPath() const{return actualPath;}
    void setActualPath(QString ActualPath){actualPath = ActualPath;}

    QString DeletedDate() const{return deletedDate;}
    void setDeletedDate(QString DeletedDate){deletedDate = DeletedDate;}

    QString FileSize() const{return fileSize;}
    void setFileSize(double FileSize);

    QString FileType() const { return fileType;}
    void setFileType(QString FileType){fileType = FileType;}

    QString IconPath() const {return iconPath;}
    void setIconPath(QString IconPath){ iconPath = IconPath;}

public slots:
    void recover();
    void remove();

signals:
    void notify(Error);
    void removeDelegate();
    void DisplayNameChanged();
    void CurrentPathChanged();
    void ActualPathChanged();
    void DeletedDateChanged();
    void FileSizeChanged();
    void FileTypeChanged();
    void IconPathChanged();

private:
    QString displayName;
    QString currentPath;
    QString actualPath;
    QString deletedDate;
    QString fileSize;
    QString fileType;
    QString iconPath;
};

#endif // TRASHINFOMODEL_H
