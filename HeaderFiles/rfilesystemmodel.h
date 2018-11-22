#ifndef RFILESYSTEMMODEL_H
#define RFILESYSTEMMODEL_H

#include <QObject>
#include <QDir>
#include <QThread>
#include <QFile>

#include "notificationmodel.h"

class RFileSystemModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> TabHeaderList READ TabHeaderList NOTIFY TabHeaderListChanged)
    Q_PROPERTY(int TabHeaderListCount READ TabHeaderListCount NOTIFY TabHeaderListCountChanged)

    Q_PROPERTY(NotificationModel* NModel READ NModel NOTIFY NModelChanged)

    Q_PROPERTY(QList<QObject*> DiskDataList READ DiskDataList NOTIFY DiskDataListChanged)
    Q_PROPERTY(int DiskDataListCount READ DiskDataListCount NOTIFY DiskDataListCountChanged)

    Q_PROPERTY(QList<QObject*> BookmarkDataList READ BookmarkDataList NOTIFY BookmarkDataListChanged)

public:
    explicit RFileSystemModel(QObject *parent = nullptr);

    QList<QObject*> TabHeaderList() const{ return tabHeaderList;}
    int TabHeaderListCount() const{ return tabHeaderList.length();}

    NotificationModel* NModel() const{ return nm;}

    Q_INVOKABLE void createNewTab(QString Path = QDir::homePath());
    Q_INVOKABLE QObject* getTabData();
    Q_INVOKABLE QObject* getTabData(int index);
    Q_INVOKABLE void updateCurrentDirectoryOnCurrentView(QString stdName, int activeIndex);
    Q_INVOKABLE void deleteTab(int index);

    QList<QObject*> DiskDataList() const{ return diskDataList;}
    int DiskDataListCount() const{ return diskDataList.length();}

    QList<QObject*> BookmarkDataList() const{ return bookmarkDataList;}

    ~RFileSystemModel();

public slots:
    void writeBookmarkAsync(QString filePath, bool addOrRemove);
    void updateStoredBookmarkList();

signals:
    void NModelChanged();

    void addBookmark(QString);
    void removeBookmark(QString);

    void TabHeaderListChanged();
    void TabHeaderListCountChanged();
    void DiskDataListChanged();
    void DiskDataListCountChanged();
    void BookmarkDataListChanged();

private:
    void GetAttachedDiskList();

    QList<QObject*> tabHeaderList;
    QList<QObject*> tabDataList;

    QList<QObject*> diskDataList;

    QThread bookmarkKeeperThread;
    QList<QObject*> bookmarkDataList;

    NotificationModel *nm;
};

#endif // RFILESYSTEMMODEL_H
