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
#ifndef DISKINFOMODEL_H
#define DISKINFOMODEL_H

#include <QObject>

class DiskInfoModel : public QObject{

    Q_OBJECT
    //label of disk, like 'local disk' on windows
    Q_PROPERTY(QString DisplayName READ DisplayName WRITE setDisplayName NOTIFY DisplayNameChanged)
    //dev/path name of the disk, like 'c' 'd' on windows
    Q_PROPERTY(QString DevName READ DevName WRITE setDevName NOTIFY DevNameChanged)
    //mount point usually gives /mnt/ like output
    Q_PROPERTY(QString MountPoint READ MountPoint WRITE setMountPoint NOTIFY MountPointChanged)
    //FileSystem of disk - ntfs,ext4 etc
    Q_PROPERTY(QString FileSystem READ FileSystem WRITE setFileSystem NOTIFY FileSystemChanged)
    //total disk size, returns value in Gbytes, Mbytes etc, if not mounted- null
    Q_PROPERTY(double TotalVolumeSize READ TotalVolumeSize WRITE setTotalVolumeSize NOTIFY TotalVolumeSizeChanged)
    //used disk size, if not mounted, null
    Q_PROPERTY(double UsedVolumeSize READ UsedVolumeSize WRITE setUsedVolumeSize NOTIFY UsedVolumeSizeChanged)

    Q_PROPERTY(QString DiskUsageAnalysis READ DiskUsageAnalysis NOTIFY DiskUsageAnalysisChanged)
    //icon based on disk size to show the the disk usage
    Q_PROPERTY(QString IconPath READ IconPath NOTIFY IconPathChanged)

    Q_PROPERTY(double PercentDocuments READ PercentDocuments WRITE setPercentDocuments NOTIFY PercentDocumentsChanged)
    Q_PROPERTY(double PercentVideos READ PercentVideos WRITE setPercentVideos NOTIFY PercentVideosChanged)
    Q_PROPERTY(double PercentMusic READ PercentMusic WRITE setPercentMusic NOTIFY PercentMusicChanged)
    Q_PROPERTY(double PercentImages READ PercentImages WRITE setPercentImages NOTIFY PercentImagesChanged)
    Q_PROPERTY(double PercentEbooks READ PercentEbooks WRITE setPercentEbooks NOTIFY PercentEbooksChanged)
    Q_PROPERTY(double PercentArchives READ PercentArchives WRITE setPercentArchives NOTIFY PercentArchivesChanged)
    Q_PROPERTY(double PercentOthers READ PercentOthers WRITE setPercentOthers NOTIFY PercentOthersChanged)

    Q_PROPERTY(QString PathToPercentFiles READ PathToPercentFiles WRITE setPathToPercentFiles NOTIFY PathToPercentFilesChanged)

public:
    DiskInfoModel(QObject *parent = nullptr);

    DiskInfoModel(const QString &DisplayName,const QString &DevName, const QString &MountPoint,const QString &FileSystem, QObject *parent = nullptr);

    QString DisplayName() const { return m_DisplayName;}
    void setDisplayName(QString DisplayName) { m_DisplayName = DisplayName; }

    QString DevName() const { return m_DevName;}
    void setDevName(QString DevName) { m_DevName = DevName;}

    QString MountPoint() const { return m_MountPoint;}
    void setMountPoint(QString MountPoint) { m_MountPoint = MountPoint;}

    QString FileSystem() const { return m_FileSystem;}
    void setFileSystem(QString FileSystem) { m_FileSystem = FileSystem;}

    double TotalVolumeSize() const { return totalVolumeSize;}
    void setTotalVolumeSize(double TotalVolumeSize) { totalVolumeSize = TotalVolumeSize;}

    double UsedVolumeSize() const { return usedVolumeSize;}
    void setUsedVolumeSize(double UsedVolumeSize) { usedVolumeSize = UsedVolumeSize;}

    QString DiskUsageAnalysis() const{ return diskUsageAnalysis; }

    QString IconPath() const { return t_icon;}

    double PercentDocuments() const {return percentDocuments;}
    void setPercentDocuments(const double PercentDocuments){ percentDocuments = PercentDocuments;}

    double PercentVideos() const { return percentVideos;}
    void setPercentVideos(const double PercentVideos){ percentVideos = PercentVideos;}

    double PercentMusic() const { return percentMusic;}
    void setPercentMusic(const double PercentMusic){ percentMusic = PercentMusic;}

    double PercentImages() const { return percentImages;}
    void setPercentImages(const double PercentImages){ percentImages = PercentImages;}

    double PercentEbooks() const { return percentEbooks;}
    void setPercentEbooks(const double PercentEbooks){ percentEbooks = PercentEbooks;}

    double PercentArchives() const { return percentArchives;}
    void setPercentArchives(const double PercentArchives){ percentArchives = PercentArchives;}

    double PercentOthers() const { return percentOthers;}
    void setPercentOthers(const double PercentOthers){ percentOthers = PercentOthers;}

    QString PathToPercentFiles() const { return pathToPercentFiles;}
    void setPathToPercentFiles(const QString &PathToPercentFiles){ pathToPercentFiles = PathToPercentFiles;}

    void GenerateExtras();

signals:
    void DisplayNameChanged();
    void DevNameChanged();
    void MountPointChanged();
    void FileSystemChanged();
    void TotalVolumeSizeChanged();
    void UsedVolumeSizeChanged();
    void DiskUsageAnalysisChanged();
    void IconPathChanged();

    void PercentDocumentsChanged();
    void PercentVideosChanged();
    void PercentMusicChanged();
    void PercentImagesChanged();
    void PercentEbooksChanged();
    void PercentArchivesChanged();
    void PercentOthersChanged();
    void PathToPercentFilesChanged();

private:
    QString m_DisplayName;
    QString m_DevName;
    QString m_MountPoint;
    QString m_FileSystem;
    QString t_icon;

    double totalVolumeSize;
    double usedVolumeSize;
    QString diskUsageAnalysis;

    double percentDocuments;
    double percentVideos;
    double percentMusic;
    double percentImages;
    double percentEbooks;
    double percentArchives;
    double percentOthers;
    QString pathToPercentFiles;
};

#endif // FILEINFOMODEL_H
