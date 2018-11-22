/*This file is part of reverse-file-manager.

    reverse-file-manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    reverse-file-manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with reverse-file-manager. If not, see <http://www.gnu.org/licenses/>.
*/

#include "HeaderFiles/filefoldermodel.h"
#include <QFile>
#include <QDateTime>
#include <QDebug>

FileFolderModel::FileFolderModel(QObject *parent)
    :QObject(parent){
    iconScale = 32;
}

FileFolderModel::FileFolderModel(const QString &DisplayName, const QString &Path, const QString &Date_Time_Created, const QString &Date_Time_Modified, QObject *parent)
    :QObject(parent), t_DisplayName(DisplayName),
      t_Path(Path), t_DateTimeCreated(Date_Time_Created),
      t_DateTimeModified(Date_Time_Modified){
    iconPath = "/local/Resources/not-found.svg";
}

void FileFolderModel::initIconCacheThread(){
    emit generateIcon(t_Path, 32);
}

void FileFolderModel::setDisplayName(const QString &DisplayName){
    QFile file(t_Path);
    if(t_DisplayName.isEmpty())
        t_DisplayName = DisplayName;
    else if(!DisplayName.isNull() && DisplayName != t_DisplayName && t_Path.length() > 0){
        //qDebug() <<
        if(file.rename(t_Path.left(t_Path.lastIndexOf('/') + 1) + DisplayName)){
            t_DisplayName = DisplayName;
            t_Path = t_Path.left(t_Path.lastIndexOf('/') + 1) + DisplayName;
        }
        else
            qDebug() << "Failed to rename: " + t_Path.left(t_Path.lastIndexOf('/') + 1) + DisplayName;
        emit DisplayNameChanged();
        emit PathChanged();
    }
}

void FileFolderModel::setFileType(QString FileType){
    if(FileType != t_FileType){
        if(!t_FileType.contains("\\"))
            FileType = FileType.replace(FileType.indexOf('-'), 1, "\\");
        t_FileType = FileType;
        emit FileTypeChanged();
        emit FileSizeChanged();
    }
}


QString FileFolderModel::FileSize() const{
    if(t_FileType.contains("directory", Qt::CaseInsensitive)){
        QDir directory(t_Path);
        return QString::number(directory.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot).length()) + " Files/Folders";
    }
    else
        return t_FileSize;
}


void FileFolderModel::setFileSize(double FileSize){
    if(FileSize != 0.0){
        if(FileSize < 1024){
            t_FileSize = QString::number(FileSize);
            if(t_FileSize.contains("."))
                t_FileSize = t_FileSize.left(t_FileSize.indexOf(".") + 3);

            t_FileSize += " Bytes";
        }
        else if(FileSize < 1048576){
            t_FileSize = QString::number(FileSize/1024);
            if(t_FileSize.contains("."))
                t_FileSize = t_FileSize.left(t_FileSize.indexOf(".") + 3);

            t_FileSize += " KBytes";
        }
        else if(FileSize < 1073741824){
            t_FileSize = QString::number(FileSize/(1048576));
            if(t_FileSize.contains("."))
                t_FileSize = t_FileSize.left(t_FileSize.indexOf(".") + 3);

            t_FileSize += " MBytes";
        }
        else if(FileSize > 1073741824){
            t_FileSize = QString::number(FileSize/(1073741824));
            if(t_FileSize.contains("."))
                t_FileSize = t_FileSize.left(t_FileSize.indexOf(".") + 3);

            t_FileSize += " GBytes";
        }
        else
            t_FileSize = "Unknown Size";
    }
    else{
        t_FileSize = "Can't Estimate";
    }
}

void FileFolderModel::setIconPath(const QString IconPath){
    if(iconPath != IconPath){
        iconPath = "file://" + IconPath;
        emit IconPathChanged();
        emit IsPreviewAvailableChanged();
    }
}

void FileFolderModel::setPreviewPath(const QString &PreviewPath){
    if(previewPath != PreviewPath){
        previewPath = "file://" + PreviewPath;
        emit PreviewPathChanged();
        emit IsPreviewAvailableChanged();
    }
}
