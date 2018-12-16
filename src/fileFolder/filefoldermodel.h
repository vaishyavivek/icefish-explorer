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

#ifndef FILEFOLDERMODEL_H
#define FILEFOLDERMODEL_H

#include <QObject>
#include <QDir>
#include <QDateTime>
#include <QFileInfo>
#include "src/rdesktopservices.h"


class FileFolderModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool Selected READ Selected WRITE setSelected NOTIFY SelectedChanged)
    //file/folder name
    Q_PROPERTY(QString DisplayName READ DisplayName WRITE setDisplayName NOTIFY DisplayNameChanged)
    //path of the file/folder
    Q_PROPERTY(QString Path READ Path WRITE setPath NOTIFY PathChanged)
    //file/folder FileType
    Q_PROPERTY(QString FileType READ FileType WRITE setFileType NOTIFY FileTypeChanged)
    //file/folder size
    Q_PROPERTY(QString FileSize READ FileSize NOTIFY FileSizeChanged)
    //date and time when the file/ folder was created
    Q_PROPERTY(QString Date_Time_Created READ Date_Time_Created NOTIFY Date_Time_CreatedChanged)
    //date and time when the file/folder was last time modified
    Q_PROPERTY(QString Date_Time_Modified READ Date_Time_Modified NOTIFY Date_Time_ModifiedChanged)
    //if the current file is visible or not
    Q_PROPERTY(bool IsHidden READ IsHidden WRITE setIsHidden NOTIFY IsHiddenChanged)

    Q_PROPERTY(QList<QObject*> ActionsMenu READ ActionsMenu WRITE setActionsMenu NOTIFY ActionsMenuChanged)
    Q_PROPERTY(int ActionsMenuCount READ ActionsMenuCount NOTIFY ActionsMenuCountChanged)

public:
    FileFolderModel(QObject *parent = nullptr)
        :QObject(parent){}

    FileFolderModel(QFileInfo FileInfo, QObject *parent = nullptr);

    bool Selected() const{ return selected;}
    void setSelected(const bool Selected){ selected = Selected;}

    QString DisplayName() const;
    void setDisplayName(const QString &DisplayName);
    void changeTabTitle(const QString &Title);

    QString FileType() const{ return (fileInfo.isDir() ? "Directory" : fileInfo.completeSuffix());}
    void setFileType(QString FileType);

    QString Path() const{return fileInfo.filePath();}
    void setPath(QString Path){ if(Path != t_Path) t_Path = Path;}

    QString FileSize() const;
    QString getFileSize(double FileSize) const;

    QString Date_Time_Created() const{return fileInfo.birthTime().toString("dd/MM/yy hh:mm");}

    QString Date_Time_Modified() const{return fileInfo.lastModified().toString("dd/MM/yy hh:mm");}

    bool IsHidden() const{return fileInfo.isHidden();}
    void setIsHidden(bool newValue) { isHidden = newValue; }

    QList<QObject*> ActionsMenu() const{ return actionsMenu;}
    void setActionsMenu(const QList<QObject*> ActionsMenu){
        actionsMenu = ActionsMenu;
        emit ActionsMenuCountChanged();
        emit ActionsMenuChanged();
    }

    int ActionsMenuCount() const{ return actionsMenu.length();}

signals:
    void SelectedChanged();
    void DisplayNameChanged();
    void FileTypeChanged();
    void FileSizeChanged();
    void PathChanged();
    void Date_Time_CreatedChanged();
    void Date_Time_ModifiedChanged();
    void IsHiddenChanged();

    void ActionsMenuChanged();
    void ActionsMenuCountChanged();
    void startThread(QString);

private:
    QFileInfo fileInfo;

    bool selected;
    QString t_DisplayName;
    QString t_FileType;
    QString t_Path;
    bool isHidden;

    QList<QObject*> actionsMenu;
};

#endif // FILEFOLDERMODEL_H
