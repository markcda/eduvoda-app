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
  color: "transparent"
  border.width: 1
  border.color: "#e7e7e7"
  Layout.alignment: Qt.AlignCenter
  Layout.margins: 5

  property alias text: label.text
  property alias img: image.source
  property int id: 0
  property bool inLiked: false
  
  function fill() {
    let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
    db.transaction(function (tx) {
      let _liked = tx.executeSql('SELECT * FROM liked WHERE id=?', good.id);
      if (_liked.rows.length != 0) {
        if (_liked.rows.item(0))
          if (_liked.rows.item(0).id == good.id) {
            good.inLiked = true;
          }
      }
    })
  }

  MouseArea {
    anchors.fill: parent
    onPressed: good.color = "#e7e7e7"
    onReleased: good.color = "transparent"
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
    id: addToBookmark
    icon.source: good.inLiked ? "../arts/16/bookmark-remove.svg" : "../arts/16/bookmark-new.svg"
    icon.color: "red"
    icon.width: 16
    icon.height: 16
    anchors.right: good.right
    anchors.verticalCenter: good.verticalCenter
    anchors.rightMargin: 10

    background: Rectangle {
      anchors.centerIn: addToBookmark
      width: addToBookmark.width
      height: addToBookmark.height
      radius: height / 2
      color: "transparent"
      border.color: "red"
    }
  
    MouseArea {
      anchors.fill: addToBookmark
      onPressed: addToBookmark.background.color = "#e7e7e7"
      onReleased: addToBookmark.background.color = "transparent"
      onClicked: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        db.transaction(function (tx) {
          if (!good.inLiked) {
            let make = tx.executeSql('INSERT INTO liked VALUES (?);', good.id);
            good.inLiked = true;
          } else {
            let del = tx.executeSql('DELETE FROM liked WHERE id=?', good.id);
            good.inLiked = false;
          }
        })
      }
    }
  }
  
  Label {
    id: label
    width: parent.width
    anchors.left: image.right
    anchors.leftMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5
    anchors.verticalCenter: parent.verticalCenter
    elide: Text.ElideRight
  }
}
