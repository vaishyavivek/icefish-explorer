#ifndef RFILESYSTEMMODEL_H
#define RFILESYSTEMMODEL_H

#include <QObject>
#include <QDir>
#include <QThread>
#include <QFile>
#include <QSettings>

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

    Q_PROPERTY(int GlobalIsHiddenItemsShown READ GlobalIsHiddenItemsShown WRITE setGlobalIsHiddenItemsShown NOTIFY GlobalIsHiddenItemsShownChanged)
    Q_PROPERTY(int GlobalIsPreviewAvailable READ GlobalIsPreviewAvailable WRITE setGlobalIsPreviewAvailable NOTIFY GlobalIsPreviewAvailableChanged)
    Q_PROPERTY(int GlobalIconScale READ GlobalIconScale WRITE setGlobalIconScale NOTIFY GlobalIconScaleChanged)

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

    int GlobalIsHiddenItemsShown() const;
    void setGlobalIsHiddenItemsShown(const int GlobalIsHiddenItemsShown);

    int GlobalIsPreviewAvailable() const;
    void setGlobalIsPreviewAvailable(const int GlobalIsPreviewAvailable);

    int GlobalIconScale() const;
    void setGlobalIconScale(const int GlobalIconScale);

    ~RFileSystemModel();

public slots:
    //void setGlabalIsHiddenItemsShown(int value);


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

    void GlobalIsHiddenItemsShownChanged();
    void GlobalIsPreviewAvailableChanged();
    void GlobalIconScaleChanged();

private:
    void GetAttachedDiskList();

    QList<QObject*> tabHeaderList;
    QList<QObject*> tabDataList;

    QList<QObject*> diskDataList;

    QThread bookmarkKeeperThread;
    QList<QObject*> bookmarkDataList;

    NotificationModel *nm;
    QSettings settings;
};

#endif // RFILESYSTEMMODEL_H
