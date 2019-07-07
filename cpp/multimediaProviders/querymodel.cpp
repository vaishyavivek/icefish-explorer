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
