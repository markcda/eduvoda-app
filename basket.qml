import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.LocalStorage 2.12
import "components"

Page {
  title: "Корзина и заказы"
  id: page

  StackView.onActivating: bottomTabBar.setSelected(2);
  
  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff
    
    Column {
      id: cl
      y: 5
      width: parent.width
      spacing: 5

      Component.onCompleted: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
        db.transaction(function (tx) {
          var basket = tx.executeSql('SELECT * FROM basket');
          if (basket.rows.length === 0) {
            var noLiked = Qt.createQmlObject('import QtQuick 2.0; import QtQuick.Controls 2.12; Label { anchors.centerIn: parent; text: "Товаров в корзине нет."; font.pixelSize: Qt.application.font.pixelSize * 1.6; }', page);
          } else {
            for (var i = 0; i < basket.rows.length; i++) {
              var good = tx.executeSql('SELECT * FROM goods WHERE id=?', basket.rows.item(i).id);
              if (good.rows.length !== 1) continue;
              var com = Qt.createComponent("components/GoodInBasket.qml");
              if (com.status === Component.Ready) {
                var obj = com.createObject(cl);
                obj.text = good.rows.item(0).label;
                obj.img = "file://" + good.rows.item(0).imageUri;
                obj.id = good.rows.item(0).id;
                obj.fill();
              }
            }
          }
        })
      }
    }
    
    GreenBtn {
      id: buy
      y: cl.y + cl.height + 5
      anchors.bottomMargin: 10
      text: "Оплатить"
      enabled: true
      
      Component.onCompleted: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
        db.transaction(function (tx) {
          var basket = tx.executeSql('SELECT * FROM basket');
          if (basket.rows.length === 0) {
            buy.visible = false;
          }
        })
      }
      
      ma.onClicked: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
        db.transaction(function (tx) {
          let eduvoda_app_url_root = "http://127.0.0.1:5000/";
          buy.enabled = false;
          let r = tx.executeSql('SELECT val FROM fs WHERE key = ?', "email");
          let user_email = r.rows.item(0).val;
          let order = [];
          r = tx.executeSql('SELECT * FROM basket');
          for (var i = 0; i < r.rows.length; i++) {
            let good = {};
            good["id"] = r.rows.item(i).id;
            good["num"] = r.rows.item(i).num;
            order.push(good);
          }
          let data = JSON.stringify(order);
          let http = new XMLHttpRequest()
          let url = eduvoda_app_url_root + "register-order";
          let params = "email=" + user_email + "&data=" + JSON.stringify(order);
          http.open("POST", url, false);
          http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
          http.setRequestHeader("Content-length", params.length);
          http.setRequestHeader("Connection", "close");
          http.send(params);
          buy.enabled = true;
          if (http.readyState == 4) {
            if (http.status == 200) {
              let body = http.response;
              if (body === "false") {
                buy.color = "red";
                buy.text = "Оплата не прошла.";
                return;
              } else {
                buy.text = "Оплачено";
                Qt.openUrlExternally(body);
                tx.executeSql("DELETE FROM basket;");
                stackView.pop();
                stackView.push("basket.qml", StackView.Immediate);
              }
            }
          }
        })
      }
    }
    
    contentHeight: buy.y + buy.height + 5
  }
}
