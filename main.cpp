#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <iostream>

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  QString appDataPath = engine.offlineStoragePath();
  QSettings st(QSettings::IniFormat, QSettings::UserScope, "CCLC", "EduVoda");
  if (st.value("notfirsttime") != "Yes") {
    QDir().mkpath(appDataPath);
    QFile::copy(":/db.db", appDataPath + QDir::separator() + "db.db");
    st.setValue("notfirsttime", "Yes");
    st.sync();
  }
  const QUrl url(QStringLiteral("qrc:/main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
          QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);
  engine.load(url);
  return app.exec();
}
