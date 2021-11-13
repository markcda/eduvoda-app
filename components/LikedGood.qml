import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15

Rectangle {
  id: good
  width: 158
  height: width
  radius: 5
  border.width: 2
  border.color: "black"
  Layout.alignment: Qt.AlignCenter
  Layout.margins: 5

  property alias text: label.text
  property alias img: image.source
  property int category: 0
  property int id: 0
  property bool inFavors: false
  
  function fill() {
    let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
    db.transaction(function (tx) {
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
    anchors.centerIn: parent
    anchors.horizontalCenter: parent.horizontalCenter
    height: parent.height - 50
    fillMode: Image.PreserveAspectFit
  }

  Label {
    id: label
    width: parent.width
    anchors.bottom: good.bottom
    anchors.bottomMargin: 4
    horizontalAlignment: "AlignHCenter"
    elide: Text.ElideRight
    wrapMode: Text.WordWrap
  }

  MouseArea {
    anchors.fill: parent
    onPressed: good.color = "grey"
    onReleased: good.color = "white"
    onClicked: stackView.push("../good.qml", {"id": id})
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
      border.color: "red"
    }
    
    MouseArea {
      anchors.fill: parent
      onPressed: addToBookmark.background.color = "grey"
      onReleased: addToBookmark.background.color = "white"
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
