#ifndef NET_H
#define NET_H

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
public:
  explicit NetHandler(QObject *parent = nullptr) : QObject(parent) {}
  ~NetHandler() {}

  bool isInternetAvailable();
  void setInternetAvailable(bool available);

  Q_INVOKABLE QString uriFromUrl(QString url) {
    return engine.offlineStoragePath() + "/" + url.split("/").last();
  }

  Q_INVOKABLE bool downloadFile(QString url) {
    if (not isInternetAvailable())
      return false;
    QNetworkRequest req(url + "?hash=ffff");
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

  Q_INVOKABLE bool checkConnection() {
    bool retVal = false;
    QNetworkRequest req(QUrl(
        "http://127.0.0.1:5000")); /*(QUrl("http://networkcheck.kde.org"));*/
    QNetworkReply *reply = nam.get(req);
    QEventLoop loop;
    QTimer timeoutTimer;
    QObject::connect(&timeoutTimer, &QTimer::timeout, &loop, &QEventLoop::quit);
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    timeoutTimer.setSingleShot(true);
    timeoutTimer.start(3000);
    loop.exec();
    if (reply->bytesAvailable())
      retVal = true;
    delete reply;
    return retVal;
  }

signals:
  void internetAvailabilityChanged();

private:
  QNetworkAccessManager nam;
  QQmlApplicationEngine engine;
  bool m_internetAvailable;
};

#endif // NET_H
