import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15

Rectangle {
  id: good
  width: parent.width - 10
  x: 5
  height: 50
  radius: height / 2
  border.width: 2
  border.color: "black"
  Layout.alignment: Qt.AlignCenter
  Layout.margins: 5

  property alias text: label.text
  property alias img: image.source
  property int category: 0
  property int id: 0
  property bool inBasket: false
  
  function fill() {
    let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
    db.transaction(function (tx) {
      let in_basket = tx.executeSql('SELECT * FROM basket WHERE id=?', good.id);
      if (in_basket.rows.length != 0) {
        if (in_basket.rows.item(0))
          if (in_basket.rows.item(0).id == good.id) {
            good.inBasket = true;
            good.num = in_basket.rows.item(0).num;
          }
      }
    })
  }

  MouseArea {
    anchors.fill: parent
    onPressed: good.color = "grey"
    onReleased: good.color = "white"
    onClicked: stackView.push("../good.qml", {"id": id})
  }
  
  Image {
    id: image
    anchors.left: good.left
    anchors.leftMargin: 10
    anchors.top: parent.top
    anchors.topMargin: 5
    height: 40
    fillMode: Image.PreserveAspectFit
  }

  ToolButton {
    id: addToBasket
    icon.source: good.inBasket ? "../arts/16/amarok_cart_remove.svg" : "../arts/16/amarok_cart_add.svg"
    icon.color: "green"
    icon.width: 18
    icon.height: 18
    anchors.right: good.right
    anchors.verticalCenter: good.verticalCenter
    anchors.rightMargin: 10

    background: Rectangle {
      anchors.centerIn: addToBasket
      width: addToBasket.width
      height: addToBasket.height
      radius: height / 2
      color: "white"
      border.color: "green"
    }
    
    MouseArea {
      anchors.fill: parent
      onPressed: addToBasket.background.color = "grey"
      onReleased: addToBasket.background.color = "white"
      onClicked: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        db.transaction(function (tx) {
          if (!good.inBasket) {
            let make = tx.executeSql('INSERT INTO basket VALUES (?, ?);', [good.id, minibtn.numOfGoods]);
            good.inBasket = true;
          } else {
            let del = tx.executeSql('DELETE FROM basket WHERE id=?', good.id);
            good.inBasket = false;
          }
        })
      }
    }
  }
  
  MiniBtnLayer {
    height: 40
    anchors.right: addToBasket.left
    anchors.rightMargin: 110
    anchors.top: parent.top
    anchors.topMargin: 10
    id: minibtn
  }
  
  property alias num: minibtn.numOfGoods
  
  Label {
    id: label
    width: parent.width
    anchors.left: image.right
    anchors.leftMargin: 5
    anchors.right: minibtn.left
    anchors.rightMargin: 5
    anchors.verticalCenter: parent.verticalCenter
    elide: Text.ElideRight
  }
}
