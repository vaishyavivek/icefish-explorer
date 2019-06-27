#ifndef RPHOTODETAILSMODEL_H
#define RPHOTODETAILSMODEL_H

#include <QObject>
#include <QFileInfo>
#include <QImage>
#include <QDateTime>

class RPhotoDetailsModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString FilePath READ FilePath WRITE setFilePath NOTIFY FilePathChanged)
    Q_PROPERTY(QString ImageDimensions READ ImageDimensions NOTIFY ImageDimensionsChanged)
    Q_PROPERTY(QString FileName READ FileName NOTIFY FileNameChanged)
    Q_PROPERTY(QString TimeModified READ TimeModified NOTIFY TimeModifiedChanged)
    Q_PROPERTY(QString FileSize READ FileSize NOTIFY FileSizeChanged)

public:
    explicit RPhotoDetailsModel(QObject *parent = nullptr);

    QString FilePath() const{ return fileInfo.filePath();}
    void setFilePath(const QString &FilePath);

    QString ImageDimensions() const;

    QString FileName() const;

    QString TimeModified() const;

    QString FileSize() const;

signals:
    void FilePathChanged();
    void ImageDimensionsChanged();
    void FileNameChanged();
    void TimeModifiedChanged();
    void FileSizeChanged();

private:
    QFileInfo  fileInfo;
    QImage *image;
};

#endif // RPHOTODETAILSMODEL_H
