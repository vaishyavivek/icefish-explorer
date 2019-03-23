/*This file is part of IceFish Explorer.

    IceFish Explorer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    IceFish Explorer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with IceFish Explorer. If not, see <http://www.gnu.org/licenses/>.
*/
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
