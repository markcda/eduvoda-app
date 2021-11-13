import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15
import "components"

Page {
  width: stackView.width
  height: stackView.height
  property int category: 0
  property alias catText: titleLbl.text

  title: "Товары"

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    Label {
      id: titleLbl
      width: parent.width
      leftPadding: 5
      font.bold: true
      font.pointSize: 18
      wrapMode: Text.WordWrap
    }

    GridLayout {
      id: lv
      y: titleLbl.height
      width: parent.width
      columns: (parent.width + 10) / 174

      Component.onCompleted: {
        if (category === 0) titleLbl.text = "Все товары";
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        db.transaction(function (tx) {
          let goods = tx.executeSql('SELECT * FROM goods');
          for (let i = 0; i < goods.rows.length; i++) {
            if (category !== 0) {
              if (goods.rows.item(i).category !== category) continue;
            }
            let com = Qt.createComponent("components/Good.qml");
            if (com.status === Component.Ready) {
              let obj = com.createObject(lv);
              obj.text = goods.rows.item(i).label;
              obj.img = "file://" + goods.rows.item(i).imageUri;
              obj.id = goods.rows.item(i).id;
              obj.fill();
            }
          }
        })
      }
    }
    contentHeight: lv.y + lv.height + 5
  }
}
