/* $Id: propertiesinfomodel.cpp
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

#include "propertiesinfomodel.h"


void SizeCalculator::calculate(QFileInfo file){

    if(file.exists()){
        if(file.isFile()){
            totalSize += file.size();
            subFiles++;
        }
        else if(file.isDir()){
            QDir dir(file.absoluteFilePath());
            subFolders++;
            QFileInfoList fileList = dir.entryInfoList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot | QDir::NoSymLinks);
            foreach (QFileInfo anotherFile, fileList) {
                calculate(anotherFile);
            }
            totalSize += 4096;
        }
    }
}

QString SizeCalculator::formattedFileSize(){
    if(totalSize < 1000)
        return QString::number(static_cast<double>(totalSize), 'f', 2) + " Bytes ";
    else if(totalSize < 1000000)
        return QString::number(static_cast<double>(totalSize)/1000, 'f', 2) + " KBytes ";
    else if(totalSize < 1000000000)
        return QString::number(static_cast<double>(totalSize)/1000000, 'f', 2) + " MBytes ";
    else
        return QString::number(static_cast<double>(totalSize)/1000000000, 'f', 2) + " GBytes ";
}








PropertiesInfoModel::PropertiesInfoModel(QObject *parent) : QObject(parent){}

QString PropertiesInfoModel::Name() const{
    return file.baseName();
}

void PropertiesInfoModel::setName(const QString &Name){}


QString PropertiesInfoModel::Path() const{
    return file.canonicalPath();
}


QString PropertiesInfoModel::Type() const{
    return mimeDb.mimeTypeForFile(file.filePath()).iconName() +
            (file.completeSuffix().isEmpty() ? "" : (" (" + file.completeSuffix()  + ")"));
}


QString PropertiesInfoModel::IconPath() const{
    if(mimeDb.mimeTypeForFile(file.filePath()).iconName().contains("image"))
        return file.absoluteFilePath();
    return "image://mime/" + mimeDb.mimeTypeForFile(file.filePath()).iconName();
}


QString PropertiesInfoModel::Size() const{
    return  size;
}


QString PropertiesInfoModel::Created() const{
    return file.birthTime().toString("ddd MMMM d yyyy | hh:mm:ss");
}

QString PropertiesInfoModel::Modified() const{
    return file.lastModified().toString("ddd MMMM d yyyy | hh:mm:ss");
}

bool PropertiesInfoModel::IsHidden() const{
    return file.isHidden();
}

void PropertiesInfoModel::setIsHidden(const bool IsHidden){}

QString PropertiesInfoModel::Owner() const{
    return file.owner();
}

QString PropertiesInfoModel::Group() const{
    return file.group();
}


bool PropertiesInfoModel::ReadOwner() const{
    return file.permission(QFile::ReadOwner);
}

void PropertiesInfoModel::setReadOwner(const bool ReadOwner){

}

bool PropertiesInfoModel::WriteOwner() const{
    return file.permission(QFile::WriteOwner);
}

void PropertiesInfoModel::setWriteOwner(const bool WriteOwner){}

bool PropertiesInfoModel::ExecOwner() const{
    return file.permission(QFile::ExeOwner);
}

void PropertiesInfoModel::setExecOwner(const bool ExecOwner){}


bool PropertiesInfoModel::ReadUser() const{
    return file.permission(QFile::ReadUser);
}

void PropertiesInfoModel::setReadUser(const bool ReadUser){}

bool PropertiesInfoModel::WriteUser() const{
    return file.permission(QFile::WriteUser);
}

void PropertiesInfoModel::setWriteUser(const bool WriteUser){}

bool PropertiesInfoModel::ExecUser() const{
    return file.permission(QFile::ExeUser);
}

void PropertiesInfoModel::setExecUser(const bool ExecUser){}


bool PropertiesInfoModel::ReadGroup() const{
    return file.permission(QFile::ReadGroup);
}

void PropertiesInfoModel::setReadGroup(const bool ReadGroup){}

bool PropertiesInfoModel::WriteGroup() const{
    return file.permission(QFile::WriteGroup);
}

void PropertiesInfoModel::setWriteGroup(const bool WriteGroup){}

bool PropertiesInfoModel::ExecGroup() const{
    return file.permission(QFile::ExeGroup);
}

void PropertiesInfoModel::setExecGroup(const bool ExecGroup){}


bool PropertiesInfoModel::ReadOther() const{
    return file.permission(QFile::ReadOther);
}

void PropertiesInfoModel::setReadOther(const bool ReadOther){}

bool PropertiesInfoModel::WriteOther() const{
    return file.permission(QFile::WriteOther);
}

void PropertiesInfoModel::setWriteOther(const bool WriteOther){}

bool PropertiesInfoModel::ExecOther() const{
    return file.permission(QFile::ExeOther);
}

void PropertiesInfoModel::setExecOther(const bool ExecOther){}
