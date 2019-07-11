/* $Id: rphotodetailsmodel.h
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

#ifndef RPHOTODETAILSMODEL_H
#define RPHOTODETAILSMODEL_H

#include <QObject>
#include <QFileInfo>
#include <QImage>
#include <QDateTime>

class RPhotoDetailsModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString FilePath READ FilePath WRITE setFilePath NOTIFY FilePathChanged)
    Q_PROPERTY(QString ImageDimensions READ ImageDimensions NOTIFY ImageDimensionsChanged)
    Q_PROPERTY(QString FileName READ FileName NOTIFY FileNameChanged)
    Q_PROPERTY(QString TimeModified READ TimeModified NOTIFY TimeModifiedChanged)
    Q_PROPERTY(QString FileSize READ FileSize NOTIFY FileSizeChanged)

public:
    explicit RPhotoDetailsModel(QObject *parent = nullptr);

    QString FilePath() const{ return fileInfo.filePath();}
    void setFilePath(const QString &FilePath);

    QString ImageDimensions() const;

    QString FileName() const;

    QString TimeModified() const;

    QString FileSize() const;

signals:
    void FilePathChanged();
    void ImageDimensionsChanged();
    void FileNameChanged();
    void TimeModifiedChanged();
    void FileSizeChanged();

private:
    QFileInfo  fileInfo;
    QImage *image;
};

#endif // RPHOTODETAILSMODEL_H
