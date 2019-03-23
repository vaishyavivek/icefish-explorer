#ifndef RDIRECTORYMODEL_H
#define RDIRECTORYMODEL_H

#include <QObject>
#include <QFileInfo>
#include <QThread>
#include <QDir>
#include <QTextStream>

#include "rabstractdirectorymodel.h"

class RDirectoryModel : public RAbstractDirectoryModel
{
    Q_OBJECT
    Q_PROPERTY(int Type READ Type WRITE setType NOTIFY TypeChanged)

public:
    explicit RDirectoryModel(QObject *parent = nullptr);

    Q_INVOKABLE void updateCurrentDirectory(QString newDirectoryToSwitchTo);
    Q_INVOKABLE void updateAddressBoxShortcutMenuList(QString jumpAddress = "");
    Q_INVOKABLE void setAddressBoxData(QString changedAddress = "");
    Q_INVOKABLE void navigateBackward();
    Q_INVOKABLE void navigateForward();
    Q_INVOKABLE void reloadCurrentDirectory();
    void setWildSearchKey(const QString &WildSearchKey);
    int Type() const{ return type;}
    void setType(const int Type){ type = Type;}

public slots:
    void deleteFile(int index);
    bool createNewFolder(QString folderName);
    bool createNewFile(QString fileName, QString fileType);
    void performAction(QString filePath, QString action, QString optionalParam = "");
    void copyOrCutItems(int type, QString filePath = "");

signals:
    void TypeChanged();

private:
    int type;

};

#endif // RDIRECTORYMODEL_H
