import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.LocalStorage 2.12

Page {
  title: "Избранное"

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    ColumnLayout {
      id: col
      width: parent.width
      y: 5
      Layout.margins: 5

      Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
        db.transaction(function (tx) {
          var liked = tx.executeSql('SELECT * FROM liked');
          for (var i = 0; i < liked.rows.length; i++) {
            var good = tx.executeSql('SELECT * FROM goods WHERE id=?', liked.rows.item(i).id);
            if (good.rows.length !== 1) continue;
            var com = Qt.createComponent("components/LikedGood.qml");
            if (com.status === Component.Ready) {
              var obj = com.createObject(col);
              obj.text = good.rows.item(0).label;
              obj.img = "file://" + good.rows.item(0).imageUri;
              obj.id = good.rows.item(0).id;
            }
          }
        })
      }
    }
  }
}
