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

SOURCES += src/main.cpp \
    src/rdirectorymodel.cpp \
    src/rfilesystemmodel.cpp \
    src/rdesktopservices.cpp \
    src/bookmarkInfo/bookmarkinfomodel.cpp \
    src/diskInfo/diskinfomodel.cpp \
    src/fileFolder/filefoldermodel.cpp \
    src/actionMenu/actionmenuprovider.cpp \
    src/recentsInfo/recentsinfomodel.cpp \
    src/notification/notificationmodel.cpp \
    src/propertiesInfo/propertiesinfomodel.cpp \
    src/fileOperator/rfileoperator.cpp \
    src/fileOperator/copyoperation.cpp \
    src/models/trashinfomodel.cpp

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
    src/rfilesystemmodel.h \
    src/rdirectorymodel.h \
    src/rdesktopservices.h \
    src/models/addressboxmodel.h \
    src/models/desktopfilemodel.h \
    src/models/menumodel.h \
    src/models/navigationhistorymodel.h \
    src/notification/notificationmodel.h \
    src/models/trashinfomodel.h \
    src/bookmarkInfo/bookmarkinfomodel.h \
    src/recentsInfo/recentsinfomodel.h \
    src/diskInfo/diskinfomodel.h \
    src/fileFolder/filefoldermodel.h \
    src/actionMenu/actionmenuprovider.h \
    src/qmlHelpers/mimeiconprovider.h \
    src/qmlHelpers/pixmappreviewprovider.h \
    src/propertiesInfo/propertiesinfomodel.h \
    src/fileOperator/rfileoperator.h \
    src/fileOperator/operationindicator.h \
    src/fileOperator/copyoperation.h \
    src/qmlHelpers/mimeinfoprovider.h

DISTFILES +=
