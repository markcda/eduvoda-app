import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.15
import com.cc.nethandler 1.0
import "components"

ApplicationWindow {
  id: window
  width: 380
  height: 700
  visible: true
  title: "ЕдуВода"

  NetHandler {
    id: nh
    Component.onCompleted: nh.checkConnection()
  }
  
  onClosing: { 
    nh.exit = true;
  }
  
  header: ToolBar {
    contentHeight: pushBackToolButton.implicitHeight

    ToolButton {
      id: pushBackToolButton
      text: stackView.depth > 1 ? "←" : "☰"
      font.pixelSize: Qt.application.font.pixelSize * 1.6
      onClicked: {
        if (stackView.depth > 2) {
          stackView.pop()
        } else if (stackView.depth == 2) {
          stackView.pop();
          stackView.replace("startscreen.qml", StackView.PopTransition);
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
  
  footer: BottomTabBar {
    id: bottomTabBar
    height: 40
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
      ItemDelegate {
        text: "Корзина"
        width: parent.width
        onClicked: {
          stackView.push("basket.qml")
          drawer.close()
        }
      }
      ItemDelegate {
        text: "Профиль"
        width: parent.width
        onClicked: {
          stackView.push("profile.qml")
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
        if (res.rows.length == 0) {
          stackView.push("register.qml");
          pushBackToolButton.visible = false;
          firstStart = true;
        }
      });
      if (firstStart === true) {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        let goods = new XMLHttpRequest();
        goods.onreadystatechange = function() {
          if (!(goods.readyState == 4 && goods.status == 200)) return;
          db.transaction(function (tx) {
            let json = JSON.parse(goods.responseText);
            tx.executeSql('CREATE TABLE goods (id INTEGER NOT NULL UNIQUE, label TEXT NOT NULL, desc TEXT, cost INTEGER NOT NULL, category INTEGER NOT NULL, imageUri TEXT, isAvailable BOOL, PRIMARY KEY("id" AUTOINCREMENT))');
            for (let i in json.goods) {
              let hasImage = nh.downloadFile(json.goods[i].img);
              let uri = "";
              if (hasImage === true)
                uri = nh.uriFromUrl(json.goods[i].img);
              tx.executeSql('INSERT INTO goods VALUES(?, ?, ?, ?, ?, ?, ?)', [json.goods[i].id, json.goods[i].goodName, json.goods[i].desc, json.goods[i].cost, json.goods[i].cathegory, uri, json.goods[i].isAvailable]);
            }
            tx.executeSql('CREATE TABLE liked (id INTEGER NOT NULL UNIQUE)');
            tx.executeSql('CREATE TABLE homePaths (n INTEGER NOT NULL UNIQUE, path TEXT NOT NULL, PRIMARY KEY("n" AUTOINCREMENT))');
            tx.executeSql('CREATE TABLE basket (id INTEGER NOT NULL UNIQUE, num INTEGER NOT NULL)');
          })
        }
        goods.open("GET", "http://127.0.0.1:5000/get-products?hash=ffff");
        goods.send();
        let sales = new XMLHttpRequest();
        sales.onreadystatechange = function() {
          if (!(sales.readyState == 4 && sales.status == 200)) return;
          db.transaction(function (tx) {
            let json = JSON.parse(sales.responseText);
            tx.executeSql('CREATE TABLE sales (id INTEGER NOT NULL UNIQUE, component TEXT, PRIMARY KEY("id" AUTOINCREMENT))');
            for (let i in json.sales) {
              tx.executeSql('INSERT INTO sales VALUES(?, ?)', [json.sales[i].id, json.sales[i].component]);
            }
          })
        }
        sales.open("GET", "http://127.0.0.1:5000/get-sales?hash=hhhh");
        sales.send();
      }
    }
  }
}
