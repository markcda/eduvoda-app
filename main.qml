import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.15
import com.cc.nethandler 1.0

ApplicationWindow {
  id: window
  width: 380
  height: 700
  visible: true
  title: "ЕдуВода"

  NetHandler {
    id: nh
  }
  
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
      let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
      let firstStart = false;
      db.transaction(function (tx) {
        // Проверка на запуск в первый раз
        let res = tx.executeSql('SELECT name FROM sqlite_master WHERE type="table" AND name="fs"');
        if (res.rows.length === 0) {
          stackView.push("register.qml");
          pushBackToolButton.visible = false;
          firstStart = true;
        }
      });
      if (firstStart === true) {
        let xmlrequest = new XMLHttpRequest();
        xmlrequest.onreadystatechange = function() {
          if (!(xmlrequest.readyState == 4 && xmlrequest.status == 200)) return;
          let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
          db.transaction(function (tx) {
            let json = JSON.parse(xmlrequest.responseText);
            tx.executeSql('CREATE TABLE goods (id INTEGER NOT NULL UNIQUE, label TEXT NOT NULL, desc TEXT, cost INTEGER NOT NULL, cathegory INTEGER NOT NULL, imageUri TEXT, PRIMARY KEY("id" AUTOINCREMENT))');
            for (let i in json.goods) {
              let hasImage = nh.downloadFile(json.goods[i].img);
              let uri = "";
              if (hasImage === true)
                uri = nh.uriFromUrl(json.goods[i].img);
              tx.executeSql('INSERT INTO goods VALUES(?, ?, ?, ?, ?, ?)', [json.goods[i].id, json.goods[i].goodName, json.goods[i].desc, json.goods[i].cost, json.goods[i].cathegory, uri]);
            }
            tx.executeSql('CREATE TABLE fs (key TEXT, val TEXT)');
          })
        }
        xmlrequest.open("GET", "http://127.0.0.1:5000/get-products?hash=ffff", false);
        xmlrequest.send();
      }
    }
  }
}
