#ifndef NET_H
#define NET_H

#include <QCoreApplication>
#include <QEventLoop>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QTimer>
#include <iostream>

class NetHandler : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool internetAvailable READ isInternetAvailable WRITE
                 setInternetAvailable NOTIFY internetAvailabilityChanged)
  Q_PROPERTY(bool exit READ isExitStatusSended WRITE setExitStatusSended NOTIFY
                 exitStatusSetted)
public:
  NetHandler(QObject *parent = nullptr) : QObject(parent) {
    QObject::connect(this, &NetHandler::exitStatusSetted, this, [this]() {
      if (isExitStatusSended()) {
        QCoreApplication::exit(0);
        enclose = true;
      }
    });
  }
  ~NetHandler() {}

  Q_INVOKABLE bool isInternetAvailable() { return m_internetAvailable; }
  void setInternetAvailable(bool available) {
    m_internetAvailable = available;
    emit internetAvailabilityChanged(available);
  }
  bool isExitStatusSended() { return m_exitStatus; }
  void setExitStatusSended(bool exitStatus) {
    m_exitStatus = exitStatus;
    emit exitStatusSetted(exitStatus);
  }

  Q_INVOKABLE QString uriFromUrl(QString url) {
    return engine.offlineStoragePath() + "/" + url.split("/").last();
  }

  Q_INVOKABLE bool downloadFile(QString url) {
    if (not isInternetAvailable())
      return false;
    QNetworkRequest req(url_root + url + "?hash=ffff");
    QNetworkReply *reply = nam.get(req);
    QEventLoop loop;
    QTimer timeoutTimer;
    QObject::connect(&timeoutTimer, &QTimer::timeout, &loop, &QEventLoop::quit);
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    timeoutTimer.setSingleShot(true);
    timeoutTimer.start(3000);
    loop.exec();
    if (reply->error() != QNetworkReply::NoError) {
      delete reply;
      return false;
    }
    QFile file(uriFromUrl(url));
    if (file.open(QFile::WriteOnly)) {
      file.write(reply->readAll());
      file.close();
      delete reply;
      return true;
    } else {
      std::cout << file.errorString().toStdString() << std::endl;
    }
    delete reply;
    return false;
  }

  Q_INVOKABLE void checkConnection() {
    setInternetAvailable(true);
    QNetworkRequest req(QUrl(url_root + "check-net"));
    QEventLoop loop;
    while (true) {
      QNetworkReply *reply = nam.get(req);
      QTimer timeoutTimer;
      QObject::connect(&timeoutTimer, &QTimer::timeout, &loop,
                       &QEventLoop::quit);
      QObject::connect(reply, &QNetworkReply::finished, &loop,
                       &QEventLoop::quit);
      timeoutTimer.setSingleShot(true);
      timeoutTimer.start(3000);
      loop.exec();
      QObject::disconnect(&timeoutTimer, &QTimer::timeout, &loop,
                          &QEventLoop::quit);
      QObject::disconnect(reply, &QNetworkReply::finished, &loop,
                          &QEventLoop::quit);
      if (reply->bytesAvailable())
        setInternetAvailable(true);
      else
        setInternetAvailable(false);
      delete reply;
      if (enclose) exit(0);
      QTimer nextCheck;
      QObject::connect(&nextCheck, &QTimer::timeout, &loop, &QEventLoop::quit);
      nextCheck.setSingleShot(true);
      nextCheck.start(30000);
      loop.exec();
      QObject::disconnect(&nextCheck, &QTimer::timeout, &loop,
                          &QEventLoop::quit);
    }
  }

signals:
  bool internetAvailabilityChanged(bool available);
  bool exitStatusSetted(bool exitStatus);

private:
  QNetworkAccessManager nam;
  QQmlApplicationEngine engine;
  bool enclose = false;
  bool m_internetAvailable, m_exitStatus;
  const QString url_root = "http://127.0.0.1:5000/";
};

#endif
