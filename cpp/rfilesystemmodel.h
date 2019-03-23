#ifndef RFILESYSTEMMODEL_H
#define RFILESYSTEMMODEL_H

#include <QObject>
#include <QDir>
#include <QThread>
#include <QFile>
#include <QSettings>

#include "models/notification/notificationmodel.h"

class RFileSystemModel : public QObject
{
    Q_OBJECT
    /* allows accessing tabHeadersBar, having name of current opened directory
     * this list is also responsible for allowing switching to other tabs
     * connected with each tab to allow changing to new name when the current directory in tab changes
     */
    Q_PROPERTY(QList<QObject*> TabHeaderList READ TabHeaderList NOTIFY TabHeaderListChanged)

    /* Provides error/warning data to NotificationPanel
     * connected with each tab via "Notfiy" slot in the NotificationModel class
     * "Notify" will also cause the N*Panel to show up in global view
     */
    Q_PROPERTY(NotificationModel* NModel READ NModel NOTIFY NModelChanged)

    // Provides access to currently mounted partitions list and info
    Q_PROPERTY(QList<QObject*> DiskDataList READ DiskDataList NOTIFY DiskDataListChanged)

    // Provides access to bookmark list, updates everytime the bookmark btn on SidePanel is clicked
    Q_PROPERTY(QList<QObject*> BookmarkDataList READ BookmarkDataList NOTIFY BookmarkDataListChanged)

    // Provides access to recently opened files and directories
    Q_PROPERTY(QList<QObject*> RecentsList READ RecentsList NOTIFY RecentsListChanged)
    // 5 mostly accessed Paths from RecentsList
    Q_PROPERTY(QList<QObject*> MostVisitedPlacesList READ MostVisitedPlacesList NOTIFY MostVisitedPlacesListChanged)

    Q_PROPERTY(QList<QObject*> TrashList READ TrashList NOTIFY TrashListChanged)

    /* Provides index position of AppTheme namely "Light, Dark, ..."
     * 'BackgroundColor' and 'IconColor' are associated with the current theme changed from settings
     * Defaults to Light theme if nothing is found, like started for the first time
     */
    Q_PROPERTY(int AppTheme READ AppTheme WRITE setAppTheme NOTIFY AppThemeChanged)
    Q_PROPERTY(QString BackgroundColor READ BackgroundColor WRITE setBackgroundColor NOTIFY BackgroundColorChanged)
    Q_PROPERTY(QString IconColor READ IconColor WRITE setIconColor NOTIFY IconColorChanged)
    Q_PROPERTY(QString HighlightColor READ HighlightColor WRITE setHighlightColor NOTIFY HighlightColorChanged)
    Q_PROPERTY(QString SelectedColor READ SelectedColor WRITE setSelectedColor NOTIFY SelectedColorChanged)
    Q_PROPERTY(bool IsPinPinned READ IsPinPinned WRITE setIsPinPinned NOTIFY IsPinPinnedChanged)
    /* While opening a new directory in any tab, first preference is given to these global properties and then the per directory settings are applied
     * 'Default(0)': Each directory will follow its own settings
     * 'Enabled(1)' AND 'Disabled(2)': Enforce these properties on each directory loading irrespective of the per directory values
     * Stored using qt provided QSettings class
     */
    Q_PROPERTY(int GlobalIsHiddenItemsShown READ GlobalIsHiddenItemsShown WRITE setGlobalIsHiddenItemsShown NOTIFY GlobalIsHiddenItemsShownChanged)
    Q_PROPERTY(int GlobalIsPreviewAvailable READ GlobalIsPreviewAvailable WRITE setGlobalIsPreviewAvailable NOTIFY GlobalIsPreviewAvailableChanged)
    Q_PROPERTY(int GlobalIconScale READ GlobalIconScale WRITE setGlobalIconScale NOTIFY GlobalIconScaleChanged)
    Q_PROPERTY(int GlobalAnimationDuration READ GlobalAnimationDuration WRITE setGlobalAnimationDuration NOTIFY GlobalAnimationDurationChanged)
    Q_PROPERTY(int GlobalFileFolderView READ GlobalFileFolderView WRITE setGlobalFileFolderView NOTIFY GlobalFileFolderViewChanged)

public:
    explicit RFileSystemModel(QObject *parent = nullptr);

    //void setupDbus();

    //Q_SCRIPTABLE void ShowFolders(const QStringList& uriList, const QString& startUpId);
    //Q_SCRIPTABLE void ShowItems(const QStringList& uriList, const QString& startUpId);


    /* Handles Tab Creation/ Navigation/ Deletion stuffs
     * can be invoked from any part of QML code
     */
    //as the name suggest
    Q_INVOKABLE void createNewTab(QString Path = QDir::homePath());
    //returns pointer to lastly added new Tab and QML code links that pointer with the newly created TabUI handler
    Q_INVOKABLE QObject* getTabData();
    //NOT USED YET
    Q_INVOKABLE QObject* getTabData(int index);
    //NOT USED YET
    Q_INVOKABLE void updateCurrentDirectoryOnCurrentView(QString stdName, int activeIndex);
    //as the name suggest
    Q_INVOKABLE void deleteTab(int index);


    //following all the methods are just C++ wrappers to properties declared above using Q_Property

    QList<QObject*> TabHeaderList() const{ return tabHeaderList;}

    NotificationModel* NModel() const{ return nm;}

    QList<QObject*> DiskDataList() const{ return diskDataList;}

    QList<QObject*> BookmarkDataList() const{ return bookmarkDataList;}

    QList<QObject*> RecentsList() const{ return recentsList;}
    QList<QObject*> MostVisitedPlacesList() const{ return mostVisitedPlacesList;}

    QList<QObject*> TrashList() const{ return trashList;}

    int AppTheme() const;
    void setAppTheme(const int AppTheme);

    QString BackgroundColor() const;
    void setBackgroundColor(const QString &BackgroundColor);

    QString IconColor() const;
    void setIconColor(const QString &IconColor);

    QString HighlightColor() const;
    void setHighlightColor(const QString &HighlightColor);

    QString SelectedColor() const;
    void setSelectedColor(const QString &SelectedColor);

    bool IsPinPinned() const;
    void setIsPinPinned(const bool IsPinPinned);

    int GlobalIsHiddenItemsShown() const;
    void setGlobalIsHiddenItemsShown(const int GlobalIsHiddenItemsShown);

    int GlobalIsPreviewAvailable() const;
    void setGlobalIsPreviewAvailable(const int GlobalIsPreviewAvailable);

    int GlobalIconScale() const;
    void setGlobalIconScale(const int GlobalIconScale);

    int GlobalAnimationDuration() const;
    void setGlobalAnimationDuration(const int GlobalAnimationDuration);

    int GlobalFileFolderView() const;
    void setGlobalFileFolderView(const int &GlobalFileFolderView);

    ~RFileSystemModel();

public slots:
    // A Threaded slot called everytime a new place is bookmarked, only does the job of calling actual Threaded BookmarkKeeper class
    void writeBookmarkAsync(QString filePath, bool addOrRemove);

    // Called everytime the BookmarkBtn on SidePanel is clicked, will refresh all the bookmarks stored
    void updateStoredBookmarkList();

    // Called everytime the RecentsBtn is clicked on SidePanel to refresh the recents list
    // Currently removal from list is not implemented
    void prepareRecentsList();
    void prepareMostVisitedPlacesList();

    void prepareTrashList(QString nameFilter = "");

signals:
    void createQmlTab();

    void NModelChanged();

    // Signals to notify BookmarkKeeper Thread to add or remove the currently bookmarked place
    void addBookmark(QString);
    void removeBookmark(QString);

    // Following all are just Notifiers to make QML code aware of the changes in C++ code
    void TabHeaderListChanged();
    void DiskDataListChanged();
    void BookmarkDataListChanged();
    void RecentsListChanged();
    void MostVisitedPlacesListChanged();
    void TrashListChanged();

    void AppThemeChanged();
    void BackgroundColorChanged();
    void IconColorChanged();
    void HighlightColorChanged();
    void SelectedColorChanged();
    void IsPinPinnedChanged();

    void GlobalIsHiddenItemsShownChanged();
    void GlobalIsPreviewAvailableChanged();
    void GlobalIconScaleChanged();
    void GlobalAnimationDurationChanged();
    void GlobalFileFolderViewChanged();

    // Linked with Each TabModel to allow async writing of recent events
    void writeHistoryThreaded(QString fileAccessed);

private:
    // Called once when the application starts to retrieve currently attached partitions
    // ONLY Linux implementation is present, comment it out if compiling on Windows
    void GetAttachedDiskList();

    QList<QObject*> tabHeaderList;
    QList<QObject*> tabDataList;

    QList<QObject*> diskDataList;

    QThread bookmarkKeeperThread;
    QList<QObject*> bookmarkDataList;

    QThread historyKeeperThread;
    QList<QObject*> recentsList;
    QList<QObject*> mostVisitedPlacesList;

    QList<QObject*> trashList;

    NotificationModel *nm;

    QString backgroundColor;
    QString iconColor;
    QString highlightColor;
    QString selectedColor;
    int animationDuration;
    bool isPinPinned;

    // Global Settings handler object
    QSettings settings;
};

#endif // RFILESYSTEMMODEL_H
