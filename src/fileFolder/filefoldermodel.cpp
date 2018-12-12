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

#include "filefoldermodel.h"
#include <QFile>
#include <QDateTime>
#include <QDebug>

FileFolderModel::FileFolderModel(QObject *parent)
    :QObject(parent){}

QString FileFolderModel::DisplayName() const{
    if(t_DisplayName.isEmpty())
        return fileInfo.fileName();
    else
        return t_DisplayName;
}

void FileFolderModel::setDisplayName(const QString &DisplayName){
    QFile file(t_Path);
    if(t_DisplayName.isEmpty())
        t_DisplayName = DisplayName;
    else if(!DisplayName.isNull() && DisplayName != t_DisplayName && t_Path.length() > 0){
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

void FileFolderModel::changeTabTitle(const QString &Title){
    if(t_DisplayName != Title){
        t_DisplayName = Title;
        emit DisplayNameChanged();
    }
}


void FileFolderModel::setFileType(QString FileType){
    if(FileType != t_FileType){
        if(!t_FileType.contains("\\"))
            FileType = FileType.replace(FileType.indexOf('-'), 1, "\\");
        t_FileType = FileType;
        emit FileTypeChanged();
    }
}


QString FileFolderModel::FileSize() const{
    if(t_FileType.contains("directory", Qt::CaseInsensitive)){
        QDir directory(fileInfo.filePath());
        return QString::number(directory.entryInfoList(QDir::Dirs | QDir::Files | QDir::NoDotAndDotDot).length()) + " Files/Folders";
    }
    else
        return getFileSize(fileInfo.size());
}


QString FileFolderModel::getFileSize(double FileSize) const{
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
