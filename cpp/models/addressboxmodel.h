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
#ifndef ADDRESSBOXMODEL_H
#define ADDRESSBOXMODEL_H

#include <QObject>

class AddressBoxModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString DisplayName READ DisplayName WRITE setDisplayName NOTIFY DisplayNameChanged)
    Q_PROPERTY(QString Path READ Path WRITE setPath NOTIFY PathChanged)


public:
    AddressBoxModel(QObject *parent = nullptr)
        :QObject (parent){}

    QString DisplayName() const{ return displayName;}
    void setDisplayName(const QString &DisplayName){
        displayName = DisplayName;
    }

    QString Path() const{ return path;}
    void setPath(const QString &Path){
        path = Path;
    }

    virtual ~AddressBoxModel() {}

signals:
    void DisplayNameChanged();
    void PathChanged();

private:
    QString displayName, path;
};

#endif // ADDRESSBOXMODEL_H
