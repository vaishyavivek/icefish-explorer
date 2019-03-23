#ifndef LOCALFILES_H
#define LOCALFILES_H

#include "../rabstractdirectorymodel.h"
#include "../../models/fileFolder/filefoldermodel.h"
#include "../../models/addressboxmodel.h"
#include <QFileSystemWatcher>

class LocalFiles : public RAbstractDirectoryModel
{
    Q_OBJECT
public:
    LocalFiles(QObject *parent = nullptr);

    void updateCurrentDirectory(QString newDirectoryToSwitchTo);
    void updateAddressBoxShortcutMenuList(QString jumpAddress = "");
    void setAddressBoxData(QString changedAddress = "");
    void setWildSearchKey(const QString &WildSearchKey);

    void navigateBackward();
    void navigateForward();
    void reloadCurrentDirectory();

    bool runDesktopService(QString filePath);
    bool runDesktopService(QString filePath, QString desktopFilePath);

public slots:
    void deleteFile(int index);
    bool createNewFolder(QString folderName);
    bool createNewFile(QString fileName, QString fileType);
    void performAction(QString filePath, QString action, QString optionalParam = "");
    void copyOrCutItems(int type, QString filePath = "");

private:
    int updateCurrentDirectoryInternal(QString directoryToSwitchTo);

    QFileSystemWatcher watcher;
};

#endif // LOCALFILES_H
