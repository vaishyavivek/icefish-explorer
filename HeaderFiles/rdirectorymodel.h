#ifndef RDIRECTORYMODEL_H
#define RDIRECTORYMODEL_H

#include <QObject>
#include <QFileInfo>
#include <QThread>
#include <QDir>
#include <QTextStream>
#include <QMimeDatabase>

#include "notificationmodel.h"
#include "HeaderFiles/rdesktopservices.h"
#include "HeaderFiles/propertiesinfomodel.h"

class RDirectoryModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> FileFolderList READ FileFolderList NOTIFY FileFolderListChanged)
    Q_PROPERTY(int ActiveIndexInCurrentModel READ ActiveIndexInCurrentModel WRITE setActiveIndexInCurrentModel)
    Q_PROPERTY(QString WildSearchKey READ WildSearchKey WRITE setWildSearchKey NOTIFY WildSearchKeyChanged)

    Q_PROPERTY(bool IsBookmarked READ IsBookmarked WRITE setIsBookmarked NOTIFY IsBookmarkedChanged)
    Q_PROPERTY(bool IsHiddenItemsShown READ IsHiddenItemsShown WRITE setIsHiddenItemsShown NOTIFY IsHiddenItemsShownChanged)
    Q_PROPERTY(bool IsPreviewAvailable READ IsPreviewAvailable WRITE setIsPreviewAvailable NOTIFY IsPreviewAvailableChanged)

    Q_PROPERTY(QString SortingRole READ SortingRole WRITE setSortingRole NOTIFY SortingRoleChanged)
    Q_PROPERTY(QString SortingOrder READ SortingOrder WRITE setSortingOrder NOTIFY SortingOrderChanged)
    Q_PROPERTY(QString SortingPreference READ SortingPreference WRITE setSortingPreference NOTIFY SortingPreferenceChanged)

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

public:
    explicit RDirectoryModel(QObject *parent = nullptr);

    QList<QObject*> FileFolderList() const{ return fileFolderList;}

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

    QString SortingRole() const{ return sortingRole;}
    void setSortingRole(const QString &SortingRole);

    QString SortingOrder() const{ return sortingOrder;}
    void setSortingOrder(const QString &SortingOrder);

    QString SortingPreference() const{ return sortingPreference;}
    void setSortingPreference(const QString &SortingPreference);

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

    Q_INVOKABLE void navigateBackward();
    Q_INVOKABLE void navigateForward();
    Q_INVOKABLE void reloadCurrentDirectory();

public slots:
    void deleteFile(int index);

    bool createNewFolder(QString folderName);
    bool createNewFile(QString fileName, QString fileType);

    void performAction(QString filePath, QString action, QString optionalParam = "");
    //bool runDesktopService

signals:
    void TitleChanged(QString newTitle);
    void IconPathChanged(QString newPath);
    void notify(Error);
    void WriteBookmarkThreaded(QString filePath, bool addOrRemove);

    void FileFolderListChanged();
    void activeIndexInCurrentModelChanged();
    void WildSearchKeyChanged();
    void triggerIconCacheThreads();

    void IsBookmarkedChanged();
    void IsHiddenItemsShownChanged();
    void IsPreviewAvailableChanged();
    void SortingRoleChanged();
    void SortingOrderChanged();
    void SortingPreferenceChanged();
    void IconScaleChanged();

    void PropertiesChanged();

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

    void showProperties();

    void changeFileFolderView(int newView);

private:
    int updateCurrentDirectoryInternal(QString directoryToSwitchTo);
    void applyCurrentDirectorySettings(QDir *localDirectory);

    QList<QObject*> getActionMenuFor(QString filePath);

    void setAddressBoxData(QString changedAddress = "");

    void updateSettingsForCurrentDirectory(QString fileOperation, QString newValue);

    QList<QObject*> fileFolderList;

    bool isBookmarked;
    bool isHiddenItemsShown;
    bool isPreviewAvailable;
    QString sortingRole;
    QString sortingOrder;
    QString sortingPreference;
    int iconScale;

    PropertiesInfoModel *properties;

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

    RDesktopServices rds;
};

#endif // RDIRECTORYMODEL_H
