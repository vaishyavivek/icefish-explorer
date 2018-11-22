#ifndef RDIRECTORYMODEL_H
#define RDIRECTORYMODEL_H

#include <QObject>
#include <QFileInfo>
#include <QThread>
#include <QDir>
#include <QTextStream>
#include <QMimeDatabase>
#include "notificationmodel.h"

class RDirectoryModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> FileFolderList READ FileFolderList NOTIFY FileFolderListChanged)

    Q_PROPERTY(bool IsHiddenItemsShown READ IsHiddenItemsShown WRITE setIsHiddenItemsShown NOTIFY IsHiddenItemsShownChanged)
    Q_PROPERTY(bool IsPreviewAvailable READ IsPreviewAvailable WRITE setIsPreviewAvailable NOTIFY IsPreviewAvailableChanged)
    Q_PROPERTY(int IconScale READ IconScale WRITE setIconScale NOTIFY IconScaleChanged)
    Q_PROPERTY(bool IsBookmarked READ IsBookmarked WRITE setIsBookmarked NOTIFY IsBookmarkedChanged)

    Q_PROPERTY(bool IsHome READ IsHome NOTIFY IsHomeChanged)
    /*Q_PROPERTY(bool IsDocuments READ IsDocuments NOTIFY IsDocumentsChanged)
    Q_PROPERTY(bool IsDownloads READ IsDownloads NOTIFY IsDownloadsChanged)
    Q_PROPERTY(bool IsMusics READ IsMusics NOTIFY IsMusicsChanged)
    Q_PROPERTY(bool IsPictues READ IsPictues NOTIFY IsPictuesChanged)
    Q_PROPERTY(bool IsVideos READ IsVideos NOTIFY IsVideosChanged)*/

    Q_PROPERTY(QString AddressBoxData READ AddressBoxData NOTIFY AddressBoxDataChanged)
    Q_PROPERTY(QList<QObject*> AddressBoxDataListView READ AddressBoxDataListView NOTIFY AddressBoxDataListViewChanged)
    Q_PROPERTY(QList<QObject*> AddressBoxShortcutMenuList READ AddressBoxShortcutMenuList NOTIFY AddressBoxShortcutMenuListChanged)
    Q_PROPERTY(int AddressBoxShortcutMenuListCount READ AddressBoxShortcutMenuListCount NOTIFY AddressBoxShortcutMenuListCountChanged)

public:
    explicit RDirectoryModel(QObject *parent = nullptr);

    QList<QObject*> FileFolderList() const{ return fileFolderList;}

    bool IsHiddenItemsShown() const{ return isHiddenItemsShown;}
    void setIsHiddenItemsShown(const bool IsHiddenItemsShown);

    bool IsPreviewAvailable() const{ return isPreviewAvailable;}
    void setIsPreviewAvailable(const bool IsPreviewAvailable);

    int IconScale() const{ return iconScale;}
    void setIconScale(const int IconScale);

    bool IsBookmarked() const{ return isBookmarked;}
    void setIsBookmarked(const bool IsBookmarked);


    bool IsHome() const{ return isHome;}

    QString AddressBoxData() const{return addressBoxData;}
    QList<QObject*> AddressBoxDataListView() const{return addressBoxDataListView;}

    QList<QObject*> AddressBoxShortcutMenuList() const{return addressBoxShortcutMenuList;}
    int AddressBoxShortcutMenuListCount() const{return addressBoxShortcutMenuList.length();}

    Q_INVOKABLE void updateCurrentDirectory(QString newDirectoryToSwitchTo);
    Q_INVOKABLE void updateAddressBoxShortcutMenuList(QString jumpAddress = "");

    Q_INVOKABLE void navigateBackward();
    Q_INVOKABLE void navigateForward();
    Q_INVOKABLE void reloadCurrentDirectory();

public slots:
    void deleteFile(int index);
    bool createNewFolder(QString folderName);
    bool createNewFile(QString fileName, QString fileType);

signals:
    void TitleChanged(QString newTitle);
    void IconPathChanged(QString newPath);
    void notify(Error);
    void WriteBookmarkThreaded(QString filePath, bool addOrRemove);

    void FileFolderListChanged();
    void triggerIconCacheThreads();

    void IsHiddenItemsShownChanged();
    void IsPreviewAvailableChanged();
    void IconScaleChanged();
    void IsBookmarkedChanged();

    void IsHomeChanged();

    void backNavBtnEnabled(bool newValue);
    void forNavBtnEnabled(bool newValue);
    void reloadBtnEnabled(bool newValue);

    void AddressBoxDataChanged();
    void AddressBoxDataListViewChanged();
    void AddressBoxShortcutMenuListChanged();
    void AddressBoxShortcutMenuListCountChanged();

    void askAddressBoxToSwitchToListViewMode(bool newValue);

    void createNew_ChooseAnother(QString suggestedName);

    void changeFileFolderView(int newView);
    void changeSortOrderButtonView(int newValue);

private:
    int updateCurrentDirectoryInternal(QString directoryToSwitchTo);
    void applyCurrentDirectorySettings(QDir *localDirectory);

    QList<QObject*> getActionMenuFor(QString filePath);

    void setAddressBoxData(QString changedAddress = "");

    void updateSettingsForCurrentDirectory(QString fileOperation, QString newValue);

    QList<QObject*> fileFolderList;

    bool isHiddenItemsShown;
    bool isPreviewAvailable;
    int iconScale;
    bool isBookmarked;

    //<TODO>
    bool isHome;
    bool isDocuments;
    bool isDownloads;
    bool isMusics;
    bool isPictures;
    bool isVideos;
    //</TODO>

    //used for tracking navigation
    QList<QString> navigationHistoryInfoList;
    int pointerToCurrentDirectoryInNavigationHistoryInfoList;

    QMimeDatabase mimeDb;

    QString addressBoxData;
    QList<QObject*> addressBoxShortcutMenuList;
    QList<QObject*> addressBoxDataListView;

};

#endif // RDIRECTORYMODEL_H
