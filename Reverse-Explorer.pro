QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
    SourceFiles/rdirectorymodel.cpp \
    SourceFiles/rfilesystemmodel.cpp \
    SourceFiles/diskinfomodel.cpp \
    SourceFiles/filefoldermodel.cpp \
    SourceFiles/rdesktopservices.cpp \
    SourceFiles/bookmarkinfomodel.cpp \
    SourceFiles/notificationmodel.cpp \
    SourceFiles/propertiesinfomodel.cpp \
    SourceFiles/actionmenuprovider.cpp

RESOURCES += qml.qrc \
    iconlibrary.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    HeaderFiles/rdirectorymodel.h \
    HeaderFiles/rfilesystemmodel.h \
    HeaderFiles/diskinfomodel.h \
    HeaderFiles/filefoldermodel.h \
    HeaderFiles/rdesktopservices.h \
    HeaderFiles/bookmarkinfomodel.h \
    HeaderFiles/menumodel.h \
    HeaderFiles/notificationmodel.h \
    HeaderFiles/navigationhistorymodel.h \
    HeaderFiles/desktopfilemodel.h \
    HeaderFiles/propertiesinfomodel.h \
    HeaderFiles/mimeiconprovider.h \
    HeaderFiles/actionmenuprovider.h \
    HeaderFiles/pixmappreviewprovider.h

DISTFILES +=
