import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15

Rectangle {
  id: good
  width: 158
  height: width
  radius: 10
  color: "transparent"
  border.width: 1
  border.color: "transparent"
  Layout.alignment: Qt.AlignCenter
  Layout.margins: 5

  property alias text: label.text
  property alias img: image.source
  property int category: 0
  property int id: 0
  property bool inBasket: false
  property bool inFavors: false
  
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
      let in_favors = tx.executeSql('SELECT * FROM liked WHERE id=?', good.id);
      if (in_favors.rows.length != 0) {
        if (in_favors.rows.item(0))
          if (in_favors.rows.item(0).id == good.id)
            good.inFavors = true;
      }
    })
  }

  Image {
    id: image
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: parent.height - 50
    fillMode: Image.PreserveAspectFit
  }

  Label {
    id: label
    width: parent.width
    anchors.bottom: minibtn.top
    horizontalAlignment: "AlignHCenter"
    elide: Text.ElideRight
    wrapMode: Text.WordWrap
  }

  MouseArea {
    anchors.fill: parent
    onPressed: good.color = "#e7e7e7"
    onReleased: good.color = "transparent"
    onClicked: stackView.push("../good.qml", {"id": id})
  }

  MiniBtnLayer {
    height: 35
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.bottom: parent.bottom
    id: minibtn
  }
  
  property alias num: minibtn.numOfGoods

  ToolButton {
    id: addToBasket
    icon.source: good.inBasket ? "../arts/16/amarok_cart_remove.svg" : "../arts/16/amarok_cart_add.svg"
    icon.color: "green"
    icon.width: 18
    icon.height: 18
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.bottomMargin: 5
    anchors.rightMargin: 5

    background: Rectangle {
      anchors.centerIn: addToBasket
      width: addToBasket.width
      height: addToBasket.height
      radius: height / 2
      color: "transparent"
      border.color: "green"
    }
    
    MouseArea {
      anchors.fill: parent
      onPressed: addToBasket.background.color = "#e7e7e7"
      onReleased: addToBasket.background.color = "transparent"
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

  ToolButton {
    id: addToBookmark
    icon.source: good.inFavors ? "../arts/16/bookmark-remove.svg" : "../arts/16/bookmark-new.svg"
    icon.color: "red"
    icon.width: 16
    icon.height: 16
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 5
    anchors.rightMargin: 5

    background: Rectangle {
      anchors.centerIn: addToBookmark
      width: addToBookmark.width
      height: addToBookmark.height
      radius: height / 2
      color: "transparent"
      border.color: "red"
    }
    
    MouseArea {
      anchors.fill: parent
      onPressed: addToBookmark.background.color = "#e7e7e7"
      onReleased: addToBookmark.background.color = "transparent"
      onClicked: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        db.transaction(function (tx) {
          if (!good.inFavors) {
            let make = tx.executeSql('INSERT INTO liked VALUES (?);', good.id);
            good.inFavors = true;
          } else {
            let del = tx.executeSql('DELETE FROM liked WHERE id=?', good.id);
            good.inFavors = false;
          }
        })
      }
    }
  }
}
