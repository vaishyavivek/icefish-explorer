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








PropertiesInfoModel::PropertiesInfoModel(QObject *parent) : QObject(parent)
{
    rds = new RDesktopServices();
}

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
    return rds->getThemeIcon(file.absoluteFilePath(), 128);
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
