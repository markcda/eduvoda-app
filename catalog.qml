import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15
import "components"

Page {
  width: stackView.width
  height: stackView.height
  property int category: 0

  title: qsTr("Товары")

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    GridLayout {
      id: lv
      width: parent.width
      height: parent.height
      columns: 2

      Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
        db.transaction(function (tx) {
          var goods = tx.executeSql('SELECT * FROM goods');
          for (var i = 0; i < goods.rows.length; i++) {
            if (category != 0) {
              if (goods.rows.item(i).category !== category) continue;
            }
            var com = Qt.createComponent("components/Good.qml");
            if (com.status === Component.Ready) {
              var obj = com.createObject(lv);
              obj.text = goods.rows.item(i).label;
            }
          }
        })
      }
    }
  }
}
