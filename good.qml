import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.15

Page {
  id: goodPage
  width: parent.width
  height: parent.height

  property int id: 0

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    Image {
      id: img
      y: 10
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      fillMode: Image.PreserveAspectFit
    }

    Label {
      id: titleLbl
      y: img.y + img.height
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      font.bold: true
      font.pointSize: 18
      wrapMode: Text.WordWrap
    }

    Label {
      id: descLbl
      y: titleLbl.y + titleLbl.height
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      font.pointSize: 14
      wrapMode: Text.WordWrap
    }
    contentHeight: descLbl.y + descLbl.height + 10
  }

  Component.onCompleted: {
    var db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
    db.transaction(function (tx) {
      var goods = tx.executeSql('SELECT * FROM goods WHERE id=?', [id]);
      if (goods.rows.length === 0)
        goodPage.title = "Товара не существует";
      else {
        goodPage.title = goods.rows.item(0).label;
        img.source = goods.rows.item(0).img;
        titleLbl.text = goods.rows.item(0).label;
        descLbl.text = goods.rows.item(0).desc;
      }
    })
  }
}
