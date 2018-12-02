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
