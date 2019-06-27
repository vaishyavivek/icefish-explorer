#ifndef PHOTOQUERYMODEL_H
#define PHOTOQUERYMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>

class PhotoQueryModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit PhotoQueryModel(QObject *parent = nullptr);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);

    QVariant data(const QModelIndex &index, int role) const;

    QHash<int, QByteArray> roleNames() const {	return m_roleNames;	}

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
};

#endif // PHOTOQUERYMODEL_H
