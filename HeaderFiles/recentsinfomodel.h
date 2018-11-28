#ifndef RECENTSINFOMODEL_H
#define RECENTSINFOMODEL_H

#include <QObject>

class RecentsInfoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString DisplayName READ DisplayName WRITE setDisplayName NOTIFY DisplayNameChanged)
    Q_PROPERTY(QString ActualPath READ ActualPath WRITE setActualPath NOTIFY ActualPathChanged)
    Q_PROPERTY(QString TimeAccessed READ TimeAccessed WRITE setTimeAccessed NOTIFY TimeAccessedChanged)
    Q_PROPERTY(QString DateAccessed READ DateAccessed WRITE setDateAccessed NOTIFY DateAccessedChanged)
    Q_PROPERTY(QString IconPath READ IconPath WRITE setIconPath NOTIFY IconPathChanged)

public:
    explicit RecentsInfoModel(QObject *parent = nullptr);

    QString DisplayName() const {return displayName;}
    void setDisplayName(const QString &DisplayName) { displayName = DisplayName;}

    QString ActualPath() const { return actualPath;}
    void setActualPath(const QString &ActualPath) {actualPath = ActualPath;}

    QString TimeAccessed() const { return timeAccessed;}
    void setTimeAccessed(const QString &TimeAccessed) { timeAccessed = TimeAccessed;}

    QString DateAccessed() const { return dateAccessed;}
    void setDateAccessed(const QString &DateAccessed) { dateAccessed = DateAccessed;}

    QString IconPath() const { return iconPath;}
    void setIconPath(const QString &IconPath){ iconPath = IconPath;}

signals:
    void DisplayNameChanged();
    void ActualPathChanged();
    void TimeAccessedChanged();
    void DateAccessedChanged();
    void IconPathChanged();

private:
    QString displayName;
    QString actualPath;
    QString timeAccessed;
    QString dateAccessed;
    QString iconPath;
};

#endif // RECENTSINFOMODEL_H

#ifndef HISTORYKEEPER_H
#define HISTORYKEEPER_H

class HistoryKeeper: public QObject{
    Q_OBJECT
public:
    HistoryKeeper(QObject *parent = nullptr);

public slots:
    void WriteHistoryAsync(QString fileAccessed);

private:
    void refineMostlyVisitedSites();

    QString historyFilePath;
};

#endif //HISTORYKEEPER_H
