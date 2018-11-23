#include "HeaderFiles/rfilesystemmodel.h"

#include <sys/vfs.h>
#include "HeaderFiles/diskinfomodel.h"
#include "HeaderFiles/filefoldermodel.h"
#include "HeaderFiles/bookmarkinfomodel.h"
#include "HeaderFiles/rdirectorymodel.h"

RFileSystemModel::RFileSystemModel(QObject *parent)
    : QObject(parent){
    GetAttachedDiskList();

    BookmarkKeeper *bookObj = new BookmarkKeeper();
    bookObj->moveToThread(&bookmarkKeeperThread);

    connect(&bookmarkKeeperThread, &QThread::finished, bookObj, &QObject::deleteLater);
    connect(this, &RFileSystemModel::addBookmark, bookObj, &BookmarkKeeper::add);
    connect(this, &RFileSystemModel::removeBookmark, bookObj, &BookmarkKeeper::remove);
    bookmarkKeeperThread.start();

    nm = new NotificationModel();
    //GetStoredBookmarkList();
}

void RFileSystemModel::writeBookmarkAsync(QString filePath, bool addOrRemove){
    addOrRemove ? emit addBookmark(filePath) : emit removeBookmark(filePath);
    updateStoredBookmarkList();
}


void RFileSystemModel::GetAttachedDiskList(){

    diskDataList.clear();

    QFile partitionsFile("/proc/partitions");
    if(partitionsFile.open(QIODevice::ReadOnly)){
        QString allPartitionsDataHolder = partitionsFile.readAll();
        partitionsFile.close();

        QStringList allVolumesList = allPartitionsDataHolder.split('\n', QString::SkipEmptyParts);


        QFile fstabFile("/etc/mtab");
        if(fstabFile.open(QIODevice::ReadOnly)){
            QString allPartitionsMountData = fstabFile.readAll();
            fstabFile.close();
            QStringList allVolumesMountDataList = allPartitionsMountData.split('\n', QString::SkipEmptyParts);

            int totalPartitionCount = allVolumesList.length();
            for(int i = 0; i < totalPartitionCount; i++){
                QString volume = allVolumesList.at(i);
                if(volume.at(volume.length() - 1).isDigit()){
                    QStringList volumeData = volume.split(' ', QString::SkipEmptyParts);

                    DiskInfoModel *newDisk = new DiskInfoModel();
                    newDisk->setDevName(volumeData.at(3));

                    for(int j = 0; j < allVolumesMountDataList.length(); j++){
                        QString mountData = allVolumesMountDataList.at(j);
                        if(mountData.startsWith("/dev/")){
                            if(mountData.startsWith("/dev/" + volumeData.at(3))){
                                QStringList mountDataList = mountData.split(' ', QString::SkipEmptyParts);

                                newDisk->setMountPoint(mountDataList.at(1));
                                newDisk->setFileSystem(mountDataList.at(2));

                                struct statfs64 vfs;
                                if(!statfs64(mountDataList.at(1).toUtf8(), &vfs)){
                                    newDisk->setTotalVolumeSize(vfs.f_blocks * static_cast<double>(vfs.f_bsize) / 1048576);
                                    newDisk->setUsedVolumeSize(vfs.f_bfree * static_cast<double>(vfs.f_bsize) / 1048576);
                                }

                                if(volumeData.at(0) == '8'){
                                    if(mountDataList.at(1) == '/')
                                        newDisk->setDisplayName("Root");
                                    else if(!mountDataList.at(2).isEmpty())
                                        newDisk->setDisplayName("Disk");
                                }
                                else if(volumeData.at(0) == "13"){
                                    newDisk->setDisplayName("Optical Disk");
                                }

                                newDisk->GenerateExtras();
                                diskDataList.append(newDisk);

                                allVolumesMountDataList.removeAt(j);
                                j--;
                                break;
                            }
                        }
                        else{
                            allVolumesMountDataList.removeAt(j);
                            j--;
                        }
                    }
                }
            }
        }
    }
    emit DiskDataListChanged();
}


void RFileSystemModel::updateStoredBookmarkList(){
    bookmarkDataList.clear();
    QFile bookmarkFile(QDir::homePath() + "/.cache/reverse-files/bookmarks.rde");
    if(bookmarkFile.open(QIODevice::ReadOnly)){
        QString wholeFile = bookmarkFile.readAll();
        QStringList book = wholeFile.split('\n', QString::SkipEmptyParts);
        RDesktopServices rds;
        QString folderIcon = "file://" + rds.getThemeIcon("std-name:folder");
        foreach (wholeFile, book) {
            BookmarkInfoModel *model = new BookmarkInfoModel();
            model->setActualPath(wholeFile);

            if(wholeFile.endsWith('/'))
                wholeFile = wholeFile.mid(0, wholeFile.length() - 1);

            model->setDisplayName(wholeFile.mid(wholeFile.lastIndexOf('/') + 1));
            model->setIconPath(folderIcon);
            bookmarkDataList.append(model);
        }
    }
    emit BookmarkDataListChanged();
}

void RFileSystemModel::createNewTab(QString Path){
    FileFolderModel *ffm = new FileFolderModel();
    RDirectoryModel *newTab = new RDirectoryModel();

    connect(newTab, &RDirectoryModel::TitleChanged, ffm, &FileFolderModel::setDisplayName);
    connect(newTab, &RDirectoryModel::IconPathChanged, ffm, &FileFolderModel::setIconPath);
    connect(newTab, &RDirectoryModel::notify, nm, &NotificationModel::Notify);

    newTab->updateCurrentDirectory(Path);

    tabDataList.append(newTab);
    tabHeaderList.append(ffm);

    emit TabHeaderListCountChanged();
    emit TabHeaderListChanged();

    connect(newTab, &RDirectoryModel::WriteBookmarkThreaded, this, &RFileSystemModel::writeBookmarkAsync);
}

QObject* RFileSystemModel::getTabData(){
    return  tabDataList.last();
}

QObject* RFileSystemModel::getTabData(int index){
    if(index < tabDataList.length())
        return tabDataList.at(index);
    else
        return nullptr;
}

void RFileSystemModel::updateCurrentDirectoryOnCurrentView(QString stdName, int activeIndex){
    if(!stdName.contains("/")){
        if(stdName.compare("home") == 0)
            qobject_cast<RDirectoryModel*>(getTabData(activeIndex))->updateCurrentDirectory(QDir::homePath());
        else
            qobject_cast<RDirectoryModel*>(getTabData(activeIndex))->updateCurrentDirectory(QDir::homePath() + "/" + stdName);
    }
    else
        qobject_cast<RDirectoryModel*>(getTabData(activeIndex))->updateCurrentDirectory(stdName);
}


void RFileSystemModel::deleteTab(int index){
    if(index < tabHeaderList.length())
        tabHeaderList.removeAt(index);
    if(index < tabDataList.length())
        tabDataList.removeAt(index);

    if(tabHeaderList.length() == 0)
        delete this;

    emit TabHeaderListCountChanged();
    emit TabHeaderListChanged();
}

RFileSystemModel::~RFileSystemModel(){
    deleteLater();
}
