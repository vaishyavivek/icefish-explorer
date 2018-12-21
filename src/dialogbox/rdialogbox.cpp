#include "rdialogbox.h"

#include <QFileInfo>
#include "src/fileFolder/filefoldermodel.h"
#include "src/models/navigationhistorymodel.h"


RDialogBox::RDialogBox(QObject *parent) : QObject(parent){
    pointerToCurrentDirectoryInNavigationHistoryInfoList = -1;
    WithFile = false;
    updateDirectory(QDir::homePath());
}

void RDialogBox::updateDirectory(QString Path){
    if(!Path.isEmpty()){

        QDir dir(Path);
        if(dir.exists()){
            t_currentPath = Path;
            emit currentPathChanged();

            for(int i = navigationHistoryInfoList.length() ; i > pointerToCurrentDirectoryInNavigationHistoryInfoList; i--)
                navigationHistoryInfoList.removeAt(i);

            NavigationHistoryModel *nhm = new NavigationHistoryModel(Path);
            navigationHistoryInfoList.append(nhm);
            pointerToCurrentDirectoryInNavigationHistoryInfoList++;

            t_forNavBtnEnabled = false;
            emit forNavBtnEnabledChanged();

            if(pointerToCurrentDirectoryInNavigationHistoryInfoList > 0){
                t_backNavBtnEnabled = true;
                emit backNavBtnEnabledChanged();
            }

            dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
            if(WithFile)
                dir.setFilter(dir.filter() | QDir::Files);

            QFileInfoList fileList = dir.entryInfoList();
            directoryList.clear();

            foreach(QFileInfo file, fileList){
                if(!file.fileName().startsWith("$")){
                    FileFolderModel *fileObj = new FileFolderModel(file);
                    directoryList.append(fileObj);
                }
            }
            emit DirectoryListChanged();
        }
    }
}


void RDialogBox::navigateBackward(){

    if((--pointerToCurrentDirectoryInNavigationHistoryInfoList) >= 0){
        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
        if(!nhm->Path().isEmpty()){

            QDir dir(nhm->Path());
            if(dir.exists()){
                t_currentPath = nhm->Path();
                emit currentPathChanged();

                dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
                if(WithFile)
                    dir.setFilter(dir.filter() | QDir::Files);

                QFileInfoList fileList = dir.entryInfoList();
                directoryList.clear();

                foreach(QFileInfo file, fileList){
                    if(!file.fileName().startsWith("$")){
                        FileFolderModel *fileObj = new FileFolderModel(file);
                        directoryList.append(fileObj);
                    }
                }
                emit DirectoryListChanged();
            }
        }
        t_forNavBtnEnabled = true;
        emit forNavBtnEnabledChanged();
    }
    t_backNavBtnEnabled = pointerToCurrentDirectoryInNavigationHistoryInfoList > 0;
    emit backNavBtnEnabledChanged();
}

void RDialogBox::navigateForward(){

    if((++pointerToCurrentDirectoryInNavigationHistoryInfoList) < navigationHistoryInfoList.length()){

        NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
        if(!nhm->Path().isEmpty()){

            QDir dir(nhm->Path());
            if(dir.exists()){
                t_currentPath = nhm->Path();
                emit currentPathChanged();

                dir.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
                if(WithFile)
                    dir.setFilter(dir.filter() | QDir::Files);

                QFileInfoList fileList = dir.entryInfoList();
                directoryList.clear();

                foreach(QFileInfo file, fileList){
                    if(!file.fileName().startsWith("$")){
                        FileFolderModel *fileObj = new FileFolderModel(file);
                        directoryList.append(fileObj);
                    }
                }
                emit DirectoryListChanged();
            }
        }
        t_backNavBtnEnabled = true;
        emit backNavBtnEnabledChanged();
    }
    t_forNavBtnEnabled = pointerToCurrentDirectoryInNavigationHistoryInfoList < navigationHistoryInfoList.length();
    emit forNavBtnEnabledChanged();
}
