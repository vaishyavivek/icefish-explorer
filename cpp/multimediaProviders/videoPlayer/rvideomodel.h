#ifndef RVIDEOMODEL_H
#define RVIDEOMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QCoreApplication>
#include <QSqlDatabase>
#include <QDir>

#include "../cachecreatorthread.h"
#include "../querymodel.h"


class RVideoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QueryModel* PQmodel READ PQmodel NOTIFY PQmodelChanged)
    Q_PROPERTY(int VideoCount READ VideoCount NOTIFY VideoCountChanged)
    Q_PROPERTY(QString CurrentVideoPath READ CurrentVideoPath NOTIFY CurrentVideoPathChanged)
    Q_PROPERTY(int ActiveIndex READ ActiveIndex WRITE setActiveIndex NOTIFY ActiveIndexChanged)

public:
    explicit RVideoModel(QObject *parent = nullptr);

    QueryModel *PQmodel() const{ return pqModel;}

    int VideoCount() const{ return pqModel->rowCount();}

    QString CurrentVideoPath() const{ return currentVideoPath;}

    int ActiveIndex() const{ return activeIndex;}
    void setActiveIndex(const int ActiveIndex);

    ~RVideoModel(){
        if(ccThread->isRunning())
            ccThread->wait();
        ccThread->terminate();
    }

signals:
    void PQmodelChanged();
    void VideoCountChanged();
    void CurrentVideoPathChanged();
    void ActiveIndexChanged();

public slots:
    void updateCacheDatabase();
    void updatePQmodelFromCache();

private:
    CacheCreatorThread *ccThread;
    QueryModel *pqModel;
    QString cachePath;
    QString currentVideoPath;
    int activeIndex;
};

#endif // RVIDEOMODEL_H
