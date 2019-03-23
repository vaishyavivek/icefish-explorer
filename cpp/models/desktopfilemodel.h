#ifndef DESKTOPFILEMODEL_H
#define DESKTOPFILEMODEL_H

#include <QObject>

class DesktopFileModel: public QObject{
    Q_OBJECT

    Q_PROPERTY(QString ServiceName READ ServiceName WRITE setServiceName NOTIFY ServiceNameChanged)

    Q_PROPERTY(QString DesktopFile READ DesktopFile WRITE setDesktopFile NOTIFY DesktopFileChanged)

    Q_PROPERTY(QString ExecPath READ ExecPath WRITE setExecPath NOTIFY ExecPathChanged)

    Q_PROPERTY(QString TryExecPath READ TryExecPath WRITE setTryExecPath NOTIFY TryExecPathChanged)

    Q_PROPERTY(QString ServiceIcon READ ServiceIcon WRITE setServiceIcon NOTIFY ServiceIconChanged)

    Q_PROPERTY(QString GenericName READ GenericName WRITE setGenericName NOTIFY GenericNameChanged)

public:
    explicit DesktopFileModel(QObject *parent = nullptr)
        :QObject(parent){}

    QString ServiceName() const { return serviceName;}
    void setServiceName(const QString ServiceName) {
        if (serviceName != ServiceName)
            serviceName = ServiceName;
    }

    QString DesktopFile() const{ return desktopFile;}
    void setDesktopFile(const QString DesktopFile){
        if(desktopFile != DesktopFile)
            desktopFile = DesktopFile;
    }

    QString ExecPath() const{ return execPath;}
    void setExecPath(const QString ExecPath) {
        if (execPath != ExecPath)
            execPath = ExecPath;}

    QString TryExecPath() const{ return tryExecPath;}
    void setTryExecPath(const QString TryExecPath) {
        if (tryExecPath != TryExecPath)
            tryExecPath = TryExecPath;}

    QString ServiceIcon() const{ return serviceIcon;}
    void setServiceIcon(const QString ServiceIcon){
        if (serviceIcon != ServiceIcon)
            serviceIcon = ServiceIcon;}

    QString GenericName() const{ return genericName;}
    void setGenericName(const QString GenericName) {
        if(GenericName != genericName)
            genericName = GenericName;
    }

signals:
    void ServiceNameChanged();
    void DesktopFileChanged();
    void ExecPathChanged();
    void TryExecPathChanged();
    void ServiceIconChanged();
    void GenericNameChanged();

private:
    QString serviceName;
    QString desktopFile;
    QString execPath;
    QString tryExecPath;
    QString serviceIcon;
    QString genericName;
};

#endif // DESKTOPFILEMODEL_H
