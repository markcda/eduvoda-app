import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.15

ApplicationWindow {
  id: window
  width: 380
  height: 700
  visible: true
  title: "ЕдуВода"

  header: ToolBar {
    contentHeight: pushBackToolButton.implicitHeight

    ToolButton {
      id: pushBackToolButton
      text: stackView.depth > 1 ? "\u25C0" : "\u2630"
      font.pixelSize: Qt.application.font.pixelSize * 1.6
      onClicked: {
        if (stackView.depth > 1) {
          stackView.pop()
        } else {
          drawer.open()
        }
      }
    }

    Label {
      text: stackView.currentItem.title
      anchors.centerIn: parent
    }
  }

  Drawer {
    id: drawer
    width: window.width * 0.66
    height: window.height

    Column {
      anchors.fill: parent

      ItemDelegate {
        text: "О нас"
        width: parent.width
        onClicked: {
          stackView.push("aboutus.qml")
          drawer.close()
        }
      }
      ItemDelegate {
        text: "Акции"
        width: parent.width
        onClicked: {
          stackView.push("sales.qml")
          drawer.close()
        }
      }
      ItemDelegate {
        text: "Избранное"
        width: parent.width
        onClicked: {
          stackView.push("liked.qml")
          drawer.close()
        }
      }
    }
  }

  StackView {
    id: stackView
    initialItem: "startscreen.qml"
    anchors.fill: parent

    Component.onCompleted: {
      var db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
      db.transaction(function (tx) {
        // Проверка на запуск в первый раз
        var res = tx.executeSql('SELECT name FROM sqlite_master WHERE type="table" AND name="fs"');
        if (res.rows.length === 0) {
          stackView.push("register.qml");
          pushBackToolButton.visible = false;
        }
      })
    }
  }
}
