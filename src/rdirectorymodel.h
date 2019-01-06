#ifndef RDIRECTORYMODEL_H
#define RDIRECTORYMODEL_H

#include <QObject>
#include <QFileInfo>
#include <QThread>
#include <QDir>
#include <QTextStream>
#include <QMimeDatabase>
#include <QSettings>
#include <QFileSystemWatcher>

#include "notification/notificationmodel.h"
#include "propertiesInfo/propertiesinfomodel.h"

class RDirectoryModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> FileFolderList READ FileFolderList NOTIFY FileFolderListChanged)
    Q_PROPERTY(int FileFolderListCount READ FileFolderListCount NOTIFY FileFolderListCountChanged)
    Q_PROPERTY(int ActiveIndexInCurrentModel READ ActiveIndexInCurrentModel WRITE setActiveIndexInCurrentModel)
    Q_PROPERTY(QString WildSearchKey READ WildSearchKey WRITE setWildSearchKey NOTIFY WildSearchKeyChanged)

    Q_PROPERTY(bool IsBookmarked READ IsBookmarked WRITE setIsBookmarked NOTIFY IsBookmarkedChanged)
    Q_PROPERTY(bool IsHiddenItemsShown READ IsHiddenItemsShown WRITE setIsHiddenItemsShown NOTIFY IsHiddenItemsShownChanged)
    Q_PROPERTY(bool IsPreviewAvailable READ IsPreviewAvailable WRITE setIsPreviewAvailable NOTIFY IsPreviewAvailableChanged)

    Q_PROPERTY(int CurrentView READ CurrentView WRITE setCurrentView NOTIFY CurrentViewChanged)

    Q_PROPERTY(int SortingRole READ SortingRole WRITE setSortingRole NOTIFY SortingRoleChanged)
    Q_PROPERTY(int SortingOrder READ SortingOrder WRITE setSortingOrder NOTIFY SortingOrderChanged)
    Q_PROPERTY(int SortingPreference READ SortingPreference WRITE setSortingPreference NOTIFY SortingPreferenceChanged)

    Q_PROPERTY(int IconScale READ IconScale WRITE setIconScale NOTIFY IconScaleChanged)

    Q_PROPERTY(PropertiesInfoModel* Properties READ Properties NOTIFY PropertiesChanged)

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

    Q_PROPERTY(int ClipboardContentCount READ ClipboardContentCount NOTIFY ClipboardContentCountChanged)
    Q_PROPERTY(int ClipboardOperationType READ ClipboardOperationType NOTIFY ClipboardOperationTypeChanged)

public:
    explicit RDirectoryModel(QObject *parent = nullptr);

    QList<QObject*> FileFolderList() const{ return fileFolderList;}
    int FileFolderListCount() const{ return fileFolderList.length();}

    int ActiveIndexInCurrentModel() const;
    void setActiveIndexInCurrentModel(const int ActiveIndexInCurrentModel);

    QString WildSearchKey() const{ return wildSearchKey;}
    void setWildSearchKey(const QString &WildSearchKey);


    bool IsBookmarked() const{ return isBookmarked;}
    void setIsBookmarked(const bool IsBookmarked);

    bool IsHiddenItemsShown() const{ return isHiddenItemsShown;}
    void setIsHiddenItemsShown(const bool IsHiddenItemsShown);

    bool IsPreviewAvailable() const{ return isPreviewAvailable;}
    void setIsPreviewAvailable(const bool IsPreviewAvailable);

    int CurrentView() const{ return currentView;}
    void setCurrentView(const int &CurrentView);

    int SortingRole() const{ return sortingRole;}
    void setSortingRole(const int &SortingRole);

    int SortingOrder() const{ return sortingOrder;}
    void setSortingOrder(const int &SortingOrder);

    int SortingPreference() const{ return sortingPreference;}
    void setSortingPreference(const int &SortingPreference);

    int IconScale() const{ return iconScale;}
    void setIconScale(const int IconScale);


    PropertiesInfoModel* Properties(){return properties;}

    bool IsHome() const{ return isHome;}

    QString AddressBoxData() const{return addressBoxData;}
    QList<QObject*> AddressBoxDataListView() const{return addressBoxDataListView;}

    QList<QObject*> AddressBoxShortcutMenuList() const{return addressBoxShortcutMenuList;}
    int AddressBoxShortcutMenuListCount() const{return addressBoxShortcutMenuList.length();}

    Q_INVOKABLE void updateCurrentDirectory(QString newDirectoryToSwitchTo);
    Q_INVOKABLE void updateAddressBoxShortcutMenuList(QString jumpAddress = "");

    QList<QObject*> getAssociatedServicesList(QString fileName);
    bool runDesktopService(QString filePath);
    bool runDesktopService(QString filePath, QString desktopFilePath);

    Q_INVOKABLE void navigateBackward();
    Q_INVOKABLE void navigateForward();
    Q_INVOKABLE void reloadCurrentDirectory();

    int ClipboardContentCount() const{ return clipboardContentCount;}
    int ClipboardOperationType() const{ return lastOperationType;}

public slots:
    void deleteFile(int index);

    bool createNewFolder(QString folderName);
    bool createNewFile(QString fileName, QString fileType);

    QList<QObject*> getActionMenuFor(QString filePath);
    void performAction(QString filePath, QString action, QString optionalParam = "");

    void enableClipboardPasting();
    void copyOrCutItems(int type, QString filePath = "");

signals:
    void TitleChanged(QString newTitle);
    void notify(Error);
    void WriteBookmarkThreaded(QString filePath, bool addOrRemove);
    void WriteHistoryTabbed(QString fileVisited);

    void FileFolderListChanged();
    void FileFolderListCountChanged();
    void activeIndexInCurrentModelChanged();
    void WildSearchKeyChanged();

    void IsBookmarkedChanged();
    void IsHiddenItemsShownChanged();
    void IsPreviewAvailableChanged();
    void CurrentViewChanged();
    void SortingRoleChanged();
    void SortingOrderChanged();
    void SortingPreferenceChanged();
    void IconScaleChanged();

    void PropertiesChanged();
    void showProperties();

    void IsHomeChanged();

    void backNavBtnEnabled(bool newValue);
    void forNavBtnEnabled(bool newValue);
    void reloadBtnEnabled(bool newValue);
    void requestToReloadFromQml();

    void AddressBoxDataChanged();
    void AddressBoxDataListViewChanged();
    void AddressBoxShortcutMenuListChanged();
    void AddressBoxShortcutMenuListCountChanged();

    void createNew_ChooseAnother(QString suggestedName);

    void ClipboardOperationTypeChanged();
    void ClipboardContentCountChanged();

private:

    void getIsBookmarked(QDir *localDirectory);

    void getIsHiddenItemsShown(QDir *localDirectory);

    void getIsPreviewAvailable(QDir *localDirectory);

    void getCurrentView(QDir *localDirectory);

    void getIconScale(QDir *localDirectory);

    void getSortingRole(QDir *localDirectory);

    void getSortingOrder(QDir *localDirectory);

    void getSortingPreference(QDir *localDirectory);


    int updateCurrentDirectoryInternal(QString directoryToSwitchTo);

    void setAddressBoxData(QString changedAddress = "");

    QList<QObject*> fileFolderList;

    bool isBookmarked;
    bool isHiddenItemsShown;
    bool isPreviewAvailable;
    int currentView;
    int sortingRole;
    int sortingOrder;
    int sortingPreference;
    int iconScale;

    PropertiesInfoModel *properties;

    int clipboardContentCount;
    int lastOperationType;

    //<TODO>
    bool isHome;
    bool isDocuments;
    bool isDownloads;
    bool isMusics;
    bool isPictures;
    bool isVideos;
    //</TODO>

    //used for tracking navigation
    QList<QObject*> navigationHistoryInfoList;
    int pointerToCurrentDirectoryInNavigationHistoryInfoList;

    QString wildSearchKey;

    QMimeDatabase mimeDb;

    QString addressBoxData;
    QList<QObject*> addressBoxShortcutMenuList;
    QList<QObject*> addressBoxDataListView;

    QSettings settings;
    QFileSystemWatcher watcher;
};

#endif // RDIRECTORYMODEL_H
