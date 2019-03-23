#ifndef MIMEINFOPROVIDER_H
#define MIMEINFOPROVIDER_H

#include <QObject>
#include <QThread>
#include <QMimeDatabase>
#include <QMimeType>

class MimeExtractorThread: public QObject{
    Q_OBJECT

public:
    MimeExtractorThread(QObject *parent = nullptr)
        :QObject(parent){}

public slots:
    void findInfo(QString Path){
        QMimeDatabase mimeDb;
        QMimeType mime = mimeDb.mimeTypeForFile(Path);
        emit getMimeShortInfo(mime.iconName());
    }

signals:
    void getMimeShortInfo(QString);
    void getMimeDescription(QString);
};


class MimeInfoProvider: public QObject{
    Q_OBJECT
    Q_PROPERTY(QString FilePath READ FilePath WRITE setFilePath NOTIFY FilePathChanged)
    Q_PROPERTY(QString MimeShortInfo READ MimeShortInfo NOTIFY MimeShortInfoChanged)
    Q_PROPERTY(QString MimeDescription READ MimeDescription NOTIFY MimeDescriptionChanged)

public:
    MimeInfoProvider(QObject *parent = nullptr)
        :QObject(parent){
    }

    QString MimeShortInfo() const{ return mimeShortInfo;}
    QString MimeDescription() const{ return mimeDescription;}

    QString FilePath() const{ return filePath;}
    void setFilePath(const QString &FilePath){
        //filePath = FilePath;
        QThread thread;
        MimeExtractorThread met;
        met.moveToThread(&thread);
        connect(&met, &MimeExtractorThread::getMimeShortInfo, this, &MimeInfoProvider::setMimeShortInfo);
        connect(this, &MimeInfoProvider::startThread, &met, &MimeExtractorThread::findInfo);
        thread.start();
        emit startThread(FilePath);
    }

signals:
    void startThread(QString);
    void FilePathChanged();
    void MimeShortInfoChanged();
    void MimeDescriptionChanged();

public slots:
    void setMimeShortInfo(QString MimeShortInfo){
        mimeShortInfo = MimeShortInfo;
        emit MimeShortInfoChanged();
    }
    void setMimeDescription(QString MimeDescription){
        mimeDescription = MimeDescription;
        emit MimeDescriptionChanged();
    }

private:
    QString filePath, mimeShortInfo, mimeDescription;
};

Q_DECLARE_METATYPE(MimeInfoProvider*)

#endif // MIMEINFOPROVIDER_H
