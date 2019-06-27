#include "photoquerymodel.h"

PhotoQueryModel::PhotoQueryModel(QObject *parent)
    :QSqlQueryModel(parent){}


void PhotoQueryModel::setQuery(const QString &query, const QSqlDatabase &db){
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void PhotoQueryModel::setQuery(const QSqlQuery &query){
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

void PhotoQueryModel::generateRoleNames(){
    m_roleNames.clear();

    for(int i = 0; i < record().count(); i++)
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
}


QVariant PhotoQueryModel::data(const QModelIndex &index, int role) const{

    if(role < Qt::UserRole)
        return QSqlQueryModel::data(index, role);
    else{
        int col = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), col);
        return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
}
