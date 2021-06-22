QT += quick

CONFIG += c++2a

SOURCES += \
        main.cpp

RESOURCES += qml.qrc \
  resources.qrc

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS +=
