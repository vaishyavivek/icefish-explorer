#ifndef QUERYMODEL_H
#define QUERYMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>

class QueryModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit QueryModel(QObject *parent = nullptr);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);

    QVariant data(const QModelIndex &index, int role) const;

    QHash<int, QByteArray> roleNames() const {	return m_roleNames;	}

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
};

#endif // PHOTOQUERYMODEL_H
