#ifndef MENUMODEL_H
#define MENUMODEL_H

#include <QObject>

class MenuModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString DisplayText READ DisplayText WRITE setDisplayText NOTIFY DisplayTextChanged)
    Q_PROPERTY(QString IconPath READ IconPath WRITE setIconPath NOTIFY IconPathChanged)
    Q_PROPERTY(bool HasSubmenu READ HasSubmenu WRITE setHasSubmenu NOTIFY HasSubmenuChanged)
    Q_PROPERTY(QString Action READ Action WRITE setAction NOTIFY ActionChanged)
    Q_PROPERTY(QList<QObject*> Submenu READ Submenu WRITE setSubmenu NOTIFY SubmenuChanged)
    Q_PROPERTY(int SubmenuCount READ SubmenuCount NOTIFY SubmenuCountChanged)

public:
    explicit MenuModel(QObject *parent = nullptr)
        :QObject(parent){
        hasSubmenu = false;
    }

    QString DisplayText() const{ return displayText;}
    void setDisplayText(const QString &DisplayText){displayText = DisplayText;}

    QString IconPath() const{ return iconPath;}
    void setIconPath(const QString &IconPath){ iconPath = IconPath;}

    bool HasSubmenu() const{ return hasSubmenu;}
    void setHasSubmenu(const bool HasSubmenu){ hasSubmenu = HasSubmenu;}

    QString Action() const{ return action;}
    void setAction(const QString &Action){ action = Action;}

    QList<QObject*> Submenu() const{ return submenu;}
    void setSubmenu(QList<QObject*> Submenu){ submenu.append(Submenu);}

    int SubmenuCount() const{ return submenu.length();}

signals:
    void DisplayTextChanged();
    void IconPathChanged();
    void HasSubmenuChanged();
    void ActionChanged();
    void SubmenuChanged();
    void SubmenuCountChanged();

private:
    QString displayText;
    QString iconPath;
    bool hasSubmenu;
    QString action;
    QList<QObject*> submenu;
};

#endif // MENUMODEL_H
