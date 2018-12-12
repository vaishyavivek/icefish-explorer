#ifndef RDESKTOPSERVICES_H
#define RDESKTOPSERVICES_H

#include <QObject>
#include <QMimeDatabase>
#include <QThread>

class RDesktopServices : public QObject
{
    Q_OBJECT
public:
    explicit RDesktopServices(QObject *parent = nullptr);

signals:
    void provideCachedIcon(QString iconPath);
    void provideCachedPreview(QString previewPath);
    void provideFileType(QString comment);

public slots:
    //obtain the icon from the default theme set by desktop environment
    QString getThemeIcon(QString filePath, int scale = 32);

    //create a cached image from the filePath of iconScale 'scale'
    //will not create new cache if previously already created
    QString constructCachedPreview(QString filePath, int scale = 32);

    //get and applythe settings value for the app in ~/.cache directory
    QString getSettingsValue(QString Name);
    void applySettingsValue(QString Name, QString Param);

    void startMimeCaching();
    QList<QObject*> getAssociatedServicesList(QString fileName);

    bool runDesktopService(QString filePath);
    bool runDesktopService(QString filePath, QString desktopFilePath);

private:
    QMimeDatabase mimeDb;
};

class DesktopFileDataExtractor: public QThread{
    Q_OBJECT
    void run() override;
};

#endif // RDESKTOPSERVICES_H
