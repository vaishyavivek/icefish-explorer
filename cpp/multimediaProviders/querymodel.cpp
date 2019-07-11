/* $Id: querymodel.cpp
 * IceFish Explorer is a free File Manager for Linux Desktops for managing
 * local files as well as files on cloud, Dropbox, Onedrive, Googledrive.
 * Additionally, it also serves as a multimedia explorer for your photos,
 * music, videos, documents and other files by providing built-in plugins
 * to open them.
 * © IceFish Community, 2019
 *
 * This file is part of IceFish Explorer.
 *
 * IceFish Explorer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * IceFish Explorer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with IceFish Explorer.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * The project is hosted here,
 * http://www.icefish.tech/index/explorer/0-5
*/

#include "querymodel.h"

QueryModel::QueryModel(QObject *parent)
    :QSqlQueryModel(parent){}


void QueryModel::setQuery(const QString &query, const QSqlDatabase &db){
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void QueryModel::setQuery(const QSqlQuery &query){
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

void QueryModel::generateRoleNames(){
    m_roleNames.clear();

    for(int i = 0; i < record().count(); i++)
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
}


QVariant QueryModel::data(const QModelIndex &index, int role) const{

    if(role < Qt::UserRole)
        return QSqlQueryModel::data(index, role);
    else{
        int col = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), col);
        return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
}
