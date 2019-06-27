#include "rphotodetailsmodel.h"

RPhotoDetailsModel::RPhotoDetailsModel(QObject *parent) : QObject(parent){
    image = new QImage();
}


void RPhotoDetailsModel::setFilePath(const QString &FilePath){
    if(fileInfo.filePath() != FilePath){
        fileInfo.setFile(FilePath);
        emit FilePathChanged();
        image = new QImage(FilePath);
        emit ImageDimensionsChanged();
        emit FileNameChanged();
        emit TimeModifiedChanged();
        emit FileSizeChanged();
    }
}

QString RPhotoDetailsModel::ImageDimensions() const{
    return image->isNull() ? "" : QString::number(image->width()) + "x" + QString::number(image->height());
}

QString RPhotoDetailsModel::FileName() const{
    return fileInfo.fileName();
}

QString RPhotoDetailsModel::TimeModified() const{
    return fileInfo.lastModified().toString("MMM dd yy hh:mm A t");
}

QString RPhotoDetailsModel::FileSize() const{
    double FileSize = fileInfo.size();
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
