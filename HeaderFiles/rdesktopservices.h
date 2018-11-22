#ifndef RDESKTOPSERVICES_H
#define RDESKTOPSERVICES_H

#include <QObject>
#include <QMimeDatabase>

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
    QString getThemeIcon(QString filePath, int scale = 32);
    QString constructCachedPreview(QString filePath, int scale = 32);
    QString getSettingsValue(QString Name);
    void applySettingsValue(QString Name, QString Param);

private:
    QMimeDatabase mimeDb;
};

#endif // RDESKTOPSERVICES_H
