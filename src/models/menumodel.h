#ifndef MENUMODEL_H
#define MENUMODEL_H

#include <QObject>

class MenuModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ServiceName READ ServiceName WRITE setServiceName NOTIFY ServiceNameChanged)
    Q_PROPERTY(QString ServiceIcon READ ServiceIcon WRITE setServiceIcon NOTIFY ServiceIconChanged)
    Q_PROPERTY(bool HasSubmenu READ HasSubmenu WRITE setHasSubmenu NOTIFY HasSubmenuChanged)
    Q_PROPERTY(QString Action READ Action WRITE setAction NOTIFY ActionChanged)
    Q_PROPERTY(QList<QObject*> Submenu READ Submenu WRITE setSubmenu NOTIFY SubmenuChanged)
    Q_PROPERTY(int SubmenuCount READ SubmenuCount NOTIFY SubmenuCountChanged)

public:
    explicit MenuModel(QObject *parent = nullptr)
        :QObject(parent){
        hasSubmenu = false;
    }

    QString ServiceName() const{ return serviceName;}
    void setServiceName(const QString &ServiceName){ serviceName = ServiceName;}

    QString ServiceIcon() const{ return serviceIcon;}
    void setServiceIcon(const QString &ServiceIcon){ serviceIcon = ServiceIcon;}

    bool HasSubmenu() const{ return hasSubmenu;}
    void setHasSubmenu(const bool HasSubmenu){ hasSubmenu = HasSubmenu;}

    QString Action() const{ return action;}
    void setAction(const QString &Action){ action = Action;}

    QList<QObject*> Submenu() const{ return submenu;}
    void setSubmenu(QList<QObject*> Submenu){ submenu.append(Submenu);}

    int SubmenuCount() const{ return submenu.length();}

signals:
    void ServiceNameChanged();
    void ServiceIconChanged();
    void HasSubmenuChanged();
    void ActionChanged();
    void SubmenuChanged();
    void SubmenuCountChanged();

private:
    QString serviceName;
    QString serviceIcon;
    bool hasSubmenu;
    QString action;
    QList<QObject*> submenu;
};

#endif // MENUMODEL_H
