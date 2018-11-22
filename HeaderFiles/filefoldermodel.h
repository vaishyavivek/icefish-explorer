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
#include "rdesktopservices.h"


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
    Q_PROPERTY(QString Date_Time_Created READ Date_Time_Created WRITE setDate_Time_Created NOTIFY Date_Time_CreatedChanged)
    //date and time when the file/folder was last time modified
    Q_PROPERTY(QString Date_Time_Modified READ Date_Time_Modified WRITE setDate_Time_Modified NOTIFY Date_Time_ModifiedChanged)
    //if the current file is visible or not
    Q_PROPERTY(bool IsHidden READ IsHidden WRITE setIsHidden NOTIFY IsHiddenChanged)

    Q_PROPERTY(bool IsPreviewAvailable READ IsPreviewAvailable WRITE setIsPreviewAvailable NOTIFY IsPreviewAvailableChanged)
    //image preview in case of an image/ small text preview for documents
    Q_PROPERTY(QString PreviewPath READ PreviewPath WRITE setPreviewPath NOTIFY PreviewPathChanged)

    //path to file icon in rfm database or thumb in case of image
    Q_PROPERTY(QString IconPath READ IconPath WRITE setIconPath NOTIFY IconPathChanged)

    Q_PROPERTY(int IconScale READ IconScale WRITE setIconScale NOTIFY IconScaleChanged)

    Q_PROPERTY(QList<QObject*> ActionsMenu READ ActionsMenu WRITE setActionsMenu NOTIFY ActionsMenuChanged)
    Q_PROPERTY(int ActionsMenuCount READ ActionsMenuCount NOTIFY ActionsMenuCountChanged)


public:
    FileFolderModel(QObject *parent = nullptr);

    FileFolderModel(const QString &DisplayName, const QString &Path, const QString &Date_Time_Created, const QString &Date_Time_Modified, QObject *parent = nullptr);

    bool Selected() const{ return selected;}
    void setSelected(const bool Selected){ selected = Selected;}

    QString DisplayName() const{return t_DisplayName;}
    void setDisplayName(const QString &DisplayName);

    QString FileType() const{ return t_FileType;}
    void setFileType(QString FileType);

    QString Section() const{return t_Section;}
    void setSection(QString Section){ if(Section!=t_Section) t_Section=Section;}

    QString Path() const{return t_Path;}
    void setPath(QString Path){ if(Path != t_Path) t_Path = Path;}

    QString FileSize() const;
    void setFileSize(double FileSize);

    QString Date_Time_Created() const{return t_DateTimeCreated;}
    void setDate_Time_Created(QString Date_Time_Created){if(Date_Time_Created != t_DateTimeCreated) t_DateTimeCreated = Date_Time_Created;}

    QString Date_Time_Modified() const{return t_DateTimeModified;}
    void setDate_Time_Modified(QString Date_Time_Modified){if(Date_Time_Modified != t_DateTimeModified) t_DateTimeModified = Date_Time_Modified;}

    bool IsHidden() const{return isHidden;}
    void setIsHidden(bool newValue) { isHidden = newValue; }

    bool IsPreviewAvailable() const{ return isPreviewAvailable;}
    void setIsPreviewAvailable(bool IsPreviewAvailable){
        isPreviewAvailable = IsPreviewAvailable;
        emit IsPreviewAvailableChanged();
    }

    QString PreviewPath() const{
        if(previewPath.isEmpty())
            return iconPath;
        return previewPath;
    }
    void setPreviewPath(const QString &PreviewPath);

    QString IconPath() const { return iconPath;}
    void setIconPath(const QString IconPath);

    int IconScale() const{ return iconScale;}
    void setIconScale(int IconScale){ iconScale = IconScale;}

    QList<QObject*> ActionsMenu() const{ return actionsMenu;}
    void setActionsMenu(const QList<QObject*> ActionsMenu){ actionsMenu.append(ActionsMenu);}

    int ActionsMenuCount() const{ return actionsMenu.length();}

public slots:
    void initIconCacheThread();

signals:
    void SelectedChanged();
    void DisplayNameChanged();
    void FileTypeChanged();
    void SectionChanged();
    void FileSizeChanged();
    void PathChanged();
    void Date_Time_CreatedChanged();
    void Date_Time_ModifiedChanged();
    void IsHiddenChanged();

    void generateIcon(QString FilePath, int Scale);

    bool IsPreviewAvailableChanged();
    void PreviewPathChanged();

    void IconPathChanged();
    void IconScaleChanged();

    void ActionsMenuChanged();
    void ActionsMenuCountChanged();


private:
    bool selected;
    QString t_DisplayName;
    QString t_FileType;
    QString t_Section;
    QString t_Path;
    QString t_FileSize;
    QString t_DateTimeCreated;
    QString t_DateTimeModified;
    bool isHidden;
    bool isPreviewAvailable;
    QString previewPath;
    QString iconPath;
    int iconScale;
    QList<QObject*> actionsMenu;
};

#endif // FILEFOLDERMODEL_H
