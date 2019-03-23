/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
#include "rdialogbox.h"

#include <QFileInfo>
#include "../fileFolder/filefoldermodel.h"
#include "../navigationhistorymodel.h"


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
