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
#include "rabstractdirectorymodel.h"

RAbstractDirectoryModel::RAbstractDirectoryModel(QObject *parent)
    : QObject(parent){
    pointerToCurrentDirectoryInNavigationHistoryInfoList = -1;
    properties = new PropertiesInfoModel();
    isHome = false;
    lastOperationType = 0;
}


int RAbstractDirectoryModel::ActiveIndexInCurrentModel() const{
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
    return nhm->ActiveIndex();
}

void RAbstractDirectoryModel::setActiveIndexInCurrentModel(const int ActiveIndexInCurrentModel){
    NavigationHistoryModel *nhm = qobject_cast<NavigationHistoryModel*>(navigationHistoryInfoList.at(pointerToCurrentDirectoryInNavigationHistoryInfoList));
    nhm->setActiveIndex(ActiveIndexInCurrentModel);
}


void RAbstractDirectoryModel::setIsBookmarked(const bool IsBookmarked){
    isBookmarked = IsBookmarked;
    settings.setValue(addressBoxData + "/isBookmarked", IsBookmarked);
    emit WriteBookmarkThreaded(addressBoxData, isBookmarked);
    emit IsBookmarkedChanged();
}

void RAbstractDirectoryModel::getIsBookmarked(QDir *localDirectory){
    isBookmarked = settings.value(localDirectory->path() + "/isBookmarked").toBool();
    emit IsBookmarkedChanged();
}



void RAbstractDirectoryModel::setIsHiddenItemsShown(const bool IsHiddenItemsShown){
    isHiddenItemsShown = IsHiddenItemsShown;
    settings.setValue(addressBoxData + "/isHiddenItemsShown", IsHiddenItemsShown);
    emit IsHiddenItemsShownChanged();
    emit requestToReloadFromQml();
}

void RAbstractDirectoryModel::getIsHiddenItemsShown(QDir *localDirectory){

    int globalHidden = settings.value("global/isHiddenItemsShown").toInt();

    isHiddenItemsShown = settings.value(localDirectory->path() + "/isHiddenItemsShown").toBool();

    isHiddenItemsShown = (globalHidden == 1 || (globalHidden == 0 && isHiddenItemsShown));

    if(isHiddenItemsShown)
        localDirectory->setFilter(localDirectory->filter() | QDir::Hidden);

    emit IsHiddenItemsShownChanged();
}



void RAbstractDirectoryModel::setIsPreviewAvailable(const bool IsPreviewAvailable){
    if(settings.value("global/isPreviewAvailable").toInt() == 0){
        isPreviewAvailable = IsPreviewAvailable;
        settings.setValue(addressBoxData + "/isPreviewAvailable", IsPreviewAvailable);
        emit IsPreviewAvailableChanged();
    }
}

void RAbstractDirectoryModel::getIsPreviewAvailable(QDir *localDirectory){
    int globalPreview = settings.value("global/isPreviewAvailable").toInt();

    isPreviewAvailable = settings.value(localDirectory->path() + "/isPreviewAvailable").toBool();

    isPreviewAvailable = (globalPreview == 1 || (globalPreview == 0 && isPreviewAvailable));

    emit IsPreviewAvailableChanged();
}



void RAbstractDirectoryModel::setCurrentView(const int &CurrentView){
    if(settings.value("global/currentView").toInt() == 0){
        currentView = CurrentView;
        settings.setValue(addressBoxData + "/currentView", CurrentView);
        emit CurrentViewChanged();
    }
}

void RAbstractDirectoryModel::getCurrentView(QDir *localDirectory){
    int globalView = settings.value("global/currentView").toInt();
    currentView = settings.value(localDirectory->path() + "/currentView").toInt();
    currentView = (globalView == 0) ? currentView : globalView;
    emit CurrentViewChanged();
}



void RAbstractDirectoryModel::setSortingRole(const int &SortingRole){
    sortingRole = SortingRole;
    settings.setValue(addressBoxData + "/sortingRole", SortingRole);
}

void RAbstractDirectoryModel::getSortingRole(QDir *localDirectory){
    sortingRole = settings.value(localDirectory->path() + "/sortingRole").toInt();

    switch (sortingRole) {
    case 1:
        localDirectory->setSorting(QDir::Type);
        break;
    case 2:
        localDirectory->setSorting(QDir::Size);
        break;
    case 3:
        localDirectory->setSorting(QDir::Time);
        break;
    default:
        localDirectory->setSorting(QDir::Name);
    }
    emit SortingRoleChanged();
}



void RAbstractDirectoryModel::setSortingOrder(const int &SortingOrder){
    sortingOrder = SortingOrder;
    settings.setValue(addressBoxData + "/sortingOrder", SortingOrder);
}

void RAbstractDirectoryModel::getSortingOrder(QDir *localDirectory){
    sortingOrder = settings.value(localDirectory->path() + "/sortingOrder").toInt();

    if(sortingOrder == 1)
        localDirectory->setSorting(localDirectory->sorting() | QDir::Reversed);
    emit SortingOrderChanged();
}



void RAbstractDirectoryModel::setSortingPreference(const int &SortingPreference){
    sortingPreference = SortingPreference;
    settings.setValue(addressBoxData + "/sortingPreference", SortingPreference);
}

void RAbstractDirectoryModel::getSortingPreference(QDir *localDirectory){
    sortingPreference = settings.value(localDirectory->path() + "/sortingPreference").toInt();

    if(sortingPreference == 1)
        localDirectory->setSorting(localDirectory->sorting() | QDir::DirsLast);
    else
        localDirectory->setSorting(localDirectory->sorting() | QDir::DirsFirst);
    emit SortingPreferenceChanged();
}



void RAbstractDirectoryModel::setIconScale(const int IconScale){
    iconScale = IconScale;
    settings.setValue(addressBoxData + "/iconScale", IconScale);
    emit IconScaleChanged();
}

void RAbstractDirectoryModel::getIconScale(QDir *localDirectory){
    iconScale = settings.value("global/iconScale").toInt();

    if(iconScale == 32){
        QVariant var = settings.value(localDirectory->path() + "/iconScale");
        iconScale = (var.isNull() ? 32 : var.toInt());
    }
    emit IconScaleChanged();
}

void RAbstractDirectoryModel::enableClipboardPasting(){
    const QMimeData *mime = QApplication::clipboard()->mimeData();
    if(mime->hasUrls())
        clipboardContentCount = mime->urls().length();
    else
        clipboardContentCount = 0;
    emit ClipboardContentCountChanged();
}

QList<QObject*> RAbstractDirectoryModel::getAssociatedServicesList(QString fileName){
    QList<QObject*> associatedServiceList;

    QMimeDatabase mimeDb;
    QMimeType mime = mimeDb.mimeTypeForFile(fileName);
    QString iconName = mime.iconName();

    if(iconName == "application-x-sharedlib")
        return associatedServiceList;

    iconName.replace('-', '/');

    QFile mimeInfoFile("/usr/share/applications/mimeinfo.cache");
    if(mimeInfoFile.open(QIODevice::ReadOnly | QIODevice::Text)){
        QString wholeFile(mimeInfoFile.readAll());
        int first = wholeFile.indexOf(iconName) + iconName.length() + 1;
        int last = wholeFile.indexOf('\n', first);
        QString allApps = wholeFile.mid(first, last - first);
        foreach(QString app, allApps.split(';', QString::SkipEmptyParts)){
            DesktopFileModel *newService = new DesktopFileModel();
            newService->setDesktopFile(app);

            //open *.desktop file for this app
            QFile modelFile("/usr/share/applications/" + app);

            if(modelFile.open(QIODevice::ReadOnly)){
                app = modelFile.readAll();

                /* sample vlc.desktop file
                 * [Desktop Entry]
                    Version=1.0
                    Name=VLC media player
                    GenericName=Media player
                    Exec=/usr/bin/vlc --started-from-file %U
                    Icon=vlc
                    *
                    *
                    *
                 */

                int nextIndex = app.indexOf("Name=") + 5;
                QString temp = app.mid(nextIndex, app.indexOf('\n', nextIndex) - nextIndex);
                newService->setServiceName(temp);

                nextIndex = app.indexOf("Exec=") + 5;
                temp = app.mid(nextIndex, app.indexOf('\n', nextIndex) - nextIndex);
                newService->setExecPath(temp);

                nextIndex = app.indexOf("Icon=") + 5;
                app = app.mid(nextIndex, app.indexOf('\n', nextIndex) - nextIndex);
                newService->setServiceIcon("image://xdg/" + app);

                modelFile.close();
            }
            if(!newService->ServiceName().isEmpty())
                associatedServiceList.append(newService);
        }
    }
    mimeInfoFile.close();

    DesktopFileModel *defaultService = new DesktopFileModel();
    defaultService->setDesktopFile("rdesktopservices.desktop");
    defaultService->setServiceName("Select another app...");
    defaultService->setServiceIcon("/local/assets/not-found.svg");
    associatedServiceList.append(defaultService);

    return associatedServiceList;
}

QList<QObject*> RAbstractDirectoryModel::getActionMenuFor(QString filePath){

    QList<QObject*> menu;

    MenuModel *open = new MenuModel();
    open->setServiceName("Open with");
    open->setHasSubmenu(true);
    open->setAction("open-with");
    open->setSubmenu(getAssociatedServicesList(filePath));

    if(!open->Submenu().isEmpty())
        menu.append(open);

    QFileInfo dir(filePath);
    if(dir.isDir()){
        MenuModel *newTab = new MenuModel();
        newTab->setServiceName("Open in New tab");
        newTab->setAction("newtab");
        menu.append(newTab);
    }


    MenuModel *cut = new MenuModel();
    cut->setServiceName("Cut");
    cut->setAction("cut");
    menu.append(cut);

    MenuModel *copy = new MenuModel();
    copy->setServiceName("Copy");
    copy->setAction("copy");
    menu.append(copy);

    MenuModel *share = new MenuModel();
    share->setServiceName("Share with");
    share->setAction("share");
    menu.append(share);

    MenuModel *properties = new MenuModel();
    properties->setServiceName("Properties");
    properties->setAction("properties");
    menu.append(properties);

    return menu;
}
