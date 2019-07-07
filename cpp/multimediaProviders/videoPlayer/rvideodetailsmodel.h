#ifndef RVIDEODETAILSMODEL_H
#define RVIDEODETAILSMODEL_H

#include <QObject>
//#include <QMediaPlayer>
//#include <QMediaMetaData>
//#include <id3/tag.h>
#include <QDebug>

class RVideoDetailsModel: public QObject{
    Q_OBJECT
    Q_PROPERTY(QString Title READ Title NOTIFY TitleChanged)

public:
    explicit RVideoDetailsModel(QString filePath, QObject *parent = nullptr)
        :QObject(parent){
        //player = new ID3_Tag(filePath.toLocal8Bit().data());
        //player.Link(filePath.toLocal8Bit().data());
    }

    QString Title() const{
        /*ID3_Tag::Iterator* iter = player->CreateIterator();
        ID3_Frame *frame = nullptr;
        while((frame = iter->GetNext()) != nullptr){
            qDebug() << frame;
        }

        qDebug() << player->GetFileName() << player->Size();
        qDebug() << player->Find(ID3FID_TITLE);*/
        return "null";//player.metaData(QMediaMetaData::Title).toString();
    }

signals:
    void TitleChanged();


private:
    //ID3_Tag *player;
};


#endif // RVIDEODETAILSMODEL_H


class PathSetter: public QObject{
    Q_OBJECT

public:
    explicit PathSetter(QObject *parent = nullptr)
        :QObject(parent){}

public slots:
    QObject* getVideoDetails(QString filePath){
        auto rvdm = new RVideoDetailsModel(filePath);
        return rvdm;
    }
};

