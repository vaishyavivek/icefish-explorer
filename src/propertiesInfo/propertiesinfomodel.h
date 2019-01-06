#ifndef PROPERTIESINFOMODEL_H
#define PROPERTIESINFOMODEL_H

#include <QObject>
#include <QFileInfo>
#include <QDir>
#include <QMimeDatabase>
#include <QMimeType>
#include <QDateTime>
#include <QThread>

class SizeCalculator: public QThread{
    Q_OBJECT
public:

    SizeCalculator(QString &FilePath){
        filePath = FilePath;
        totalSize = 0;
        subFolders = -1;
        subFiles = 0;
    }

    void run() override{
        QFileInfo file(filePath);
        calculate(file);
        if(subFolders > 0)
            emit provideChangedSize(formattedFileSize() + "\n" +
                                    QString::number(subFolders) + " SubFolders & " +
                                    QString::number(subFiles) + " Files");
        else
            emit provideChangedSize(formattedFileSize());
    }

signals:
    void provideChangedSize(QString size);

private:
    void calculate(QFileInfo);
    QString formattedFileSize();

    QString filePath;
    qint64 totalSize;
    int subFolders, subFiles;
};

class PropertiesInfoModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString Name READ Name WRITE setName NOTIFY NameChanged)
    Q_PROPERTY(QString Path READ Path NOTIFY PathChanged)
    Q_PROPERTY(QString Type READ Type NOTIFY TypeChanged)
    Q_PROPERTY(QString IconPath READ IconPath NOTIFY IconPathChanged)
    Q_PROPERTY(QString Size READ Size NOTIFY SizeChanged)
    Q_PROPERTY(QString Created READ Created NOTIFY CreatedChanged)
    Q_PROPERTY(QString Modified READ Modified NOTIFY ModifiedChanged)
    Q_PROPERTY(bool IsHidden READ IsHidden WRITE setIsHidden NOTIFY IsHiddenChanged)

    Q_PROPERTY(QString Owner READ Owner NOTIFY OwnerChanged)
    Q_PROPERTY(QString Group READ Group NOTIFY GroupChanged)

    Q_PROPERTY(bool ReadOwner READ ReadOwner WRITE setReadOwner NOTIFY ReadOwnerChanged)
    Q_PROPERTY(bool WriteOwner READ WriteOwner WRITE setWriteOwner NOTIFY WriteOwnerChanged)
    Q_PROPERTY(bool ExecOwner READ ExecOwner WRITE setExecOwner NOTIFY ExecOwnerChanged)

    Q_PROPERTY(bool ReadUser READ ReadUser WRITE setReadUser NOTIFY ReadUserChanged)
    Q_PROPERTY(bool WriteUser READ WriteUser WRITE setWriteUser NOTIFY WriteUserChanged)
    Q_PROPERTY(bool ExecUser READ ExecUser WRITE setExecUser NOTIFY ExecUserChanged)

    Q_PROPERTY(bool ReadGroup READ ReadGroup WRITE setReadGroup NOTIFY ReadGroupChanged)
    Q_PROPERTY(bool WriteGroup READ WriteGroup WRITE setWriteGroup NOTIFY WriteUserChanged)
    Q_PROPERTY(bool ExecGroup READ ExecGroup WRITE setExecGroup NOTIFY ExecGroupChanged)

    Q_PROPERTY(bool ReadOther READ ReadOther WRITE setReadOther NOTIFY ReadOtherChanged)
    Q_PROPERTY(bool WriteOther READ WriteOther WRITE setWriteOther NOTIFY WriteOtherChanged)
    Q_PROPERTY(bool ExecOther READ ExecOther WRITE setExecOther NOTIFY ExecOtherChanged)


public:
    explicit PropertiesInfoModel(QObject *parent = nullptr);

    void setProperties(QString &FilePath){
        file.setFile(FilePath);
        size = "Calculating...";
        SizeCalculator *thread = new SizeCalculator(FilePath);
        connect(thread, &SizeCalculator::finished, thread, &QObject::deleteLater);
        connect(thread, &SizeCalculator::provideChangedSize, this, &PropertiesInfoModel::sizeUpdated);
        thread->start();
    }

    QString Name() const;
    void setName(const QString &Name);

    QString Path() const;

    QString Type() const;

    QString IconPath() const;

    QString Size() const;

    QString Created() const;

    QString Modified() const;

    bool IsHidden() const;
    void setIsHidden(const bool IsHidden);

    QString Owner() const;
    QString Group() const;

    bool ReadOwner() const;
    void setReadOwner(const bool ReadOwner);

    bool WriteOwner() const;
    void setWriteOwner(const bool WriteOwner);

    bool ExecOwner() const;
    void setExecOwner(const bool ExecOwner);


    bool ReadUser() const;
    void setReadUser(const bool ReadUser);

    bool WriteUser() const;
    void setWriteUser(const bool WriteUser);

    bool ExecUser() const;
    void setExecUser(const bool ExecUser);


    bool ReadGroup() const;
    void setReadGroup(const bool ReadGroup);

    bool WriteGroup() const;
    void setWriteGroup(const bool WriteGroup);

    bool ExecGroup() const;
    void setExecGroup(const bool ExecGroup);


    bool ReadOther() const;
    void setReadOther(const bool ReadOther);

    bool WriteOther() const;
    void setWriteOther(const bool WriteOther);

    bool ExecOther() const;
    void setExecOther(const bool ExecOther);

signals:
    void NameChanged();
    void PathChanged();
    void TypeChanged();
    void IconPathChanged();
    void TypeDescChanged();
    void SizeChanged();
    void CreatedChanged();
    void ModifiedChanged();
    void IsHiddenChanged();
    void OwnerChanged();
    void GroupChanged();
    void ReadOwnerChanged();
    void WriteOwnerChanged();
    void ExecOwnerChanged();
    void ReadUserChanged();
    void WriteUserChanged();
    void ExecUserChanged();
    void ReadGroupChanged();
    void WriteGroupChanged();
    void ExecGroupChanged();
    void ReadOtherChanged();
    void WriteOtherChanged();
    void ExecOtherChanged();

public slots:
    void sizeUpdated(QString newSize){
        size = newSize;
        emit SizeChanged();
    }

private:
    QFileInfo file;
    QMimeDatabase mimeDb;
    QMimeType mime;

    QString size;
};

#endif // PROPERTIESINFOMODEL_H
