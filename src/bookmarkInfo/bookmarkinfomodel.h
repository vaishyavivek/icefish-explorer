/*This file is part of reverse-file-manager.

    reverse-file-manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    reverse-file-manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with reverse-file-manager. If not, see <http://www.gnu.org/licenses/>.
*/
#include <QObject>
#include <QDir>
#include <QFile>
#include <QTextStream>

#ifndef BOOKMARKKEEPER_H
#define BOOKMARKKEEPER_H

class BookmarkKeeper : public QObject{
    Q_OBJECT
public:
    BookmarkKeeper(QObject *parent = nullptr);

public slots:
    void add(QString filePath);
    void remove(QString filePath);

private:
    QString bookmarkFilePath;
};

#endif //BOOKMARKKEEPER_H


#ifndef BOOKMARKINFOMODEL_H
#define BOOKMARKINFOMODEL_H

class BookmarkInfoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString DisplayName READ DisplayName WRITE setDisplayName NOTIFY DisplayNameChanged)
    Q_PROPERTY(QString ActualPath READ ActualPath WRITE setActualPath NOTIFY ActualPathChanged)
    Q_PROPERTY(QString IconPath READ IconPath WRITE setIconPath NOTIFY IconPathChanged)

public:
    explicit BookmarkInfoModel(QObject *parent = nullptr)
        :QObject(parent){}

    QString DisplayName() const {return displayName;}
    void setDisplayName(const QString &DisplayName) { displayName = DisplayName;}

    QString ActualPath() const { return actualPath;}
    void setActualPath(const QString &ActualPath) {actualPath = ActualPath;}

    QString IconPath() const { return iconPath;}
    void setIconPath(const QString &IconPath){ iconPath = IconPath;}

signals:
    void DisplayNameChanged();
    void ActualPathChanged();
    void IconPathChanged();

private:
    QString displayName;
    QString actualPath;
    QString iconPath;
};

#endif // BOOKMARKINFOMODEL_H
