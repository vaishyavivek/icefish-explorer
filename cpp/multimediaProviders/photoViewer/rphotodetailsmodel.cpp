/* $Id: rphotodetailsmodel.cpp
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

#include "rphotodetailsmodel.h"

RPhotoDetailsModel::RPhotoDetailsModel(QObject *parent) : QObject(parent){
    image = new QImage();
}


void RPhotoDetailsModel::setFilePath(const QString &FilePath){
    if(fileInfo.filePath() != FilePath){
        fileInfo.setFile(FilePath);
        emit FilePathChanged();
        image = new QImage(FilePath);
        emit ImageDimensionsChanged();
        emit FileNameChanged();
        emit TimeModifiedChanged();
        emit FileSizeChanged();
    }
}

QString RPhotoDetailsModel::ImageDimensions() const{
    return image->isNull() ? "" : QString::number(image->width()) + "x" + QString::number(image->height());
}

QString RPhotoDetailsModel::FileName() const{
    return fileInfo.fileName();
}

QString RPhotoDetailsModel::TimeModified() const{
    return fileInfo.lastModified().toString("MMM dd yy hh:mm A t");
}

QString RPhotoDetailsModel::FileSize() const{
    double FileSize = fileInfo.size();
    QString fileSize;
    if(FileSize != 0.0){
        if(FileSize < 1024){
            fileSize = QString::number(FileSize);
            if(fileSize.contains("."))
                fileSize = fileSize.left(fileSize.indexOf(".") + 3);

            fileSize += " Bytes";
        }
        else if(FileSize < 1048576){
            fileSize = QString::number(FileSize/1024);
            if(fileSize.contains("."))
                fileSize = fileSize.left(fileSize.indexOf(".") + 3);

            fileSize += " KBytes";
        }
        else if(FileSize < 1073741824){
            fileSize = QString::number(FileSize/(1048576));
            if(fileSize.contains("."))
                fileSize = fileSize.left(fileSize.indexOf(".") + 3);

            fileSize += " MBytes";
        }
        else if(FileSize > 1073741824){
            fileSize = QString::number(FileSize/(1073741824));
            if(fileSize.contains("."))
                fileSize = fileSize.left(fileSize.indexOf(".") + 3);

            fileSize += " GBytes";
        }
        else
            fileSize = "Unknown Size";
    }
    else
        fileSize = "Can't Estimate";
    return fileSize;
}
