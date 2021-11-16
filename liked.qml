import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.LocalStorage 2.12

Page {
  title: "Избранное"
  id: page

  StackView.onActivating: bottomTabBar.setSelected(3);
  
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
        var db = LocalStorage.openDatabaseSync("db", "1.0", "AppDB", 1000000);
        db.transaction(function (tx) {
          var liked = tx.executeSql('SELECT * FROM liked');
          if (liked.rows.length === 0) {
            var noLiked = Qt.createQmlObject('import QtQuick 2.0; import QtQuick.Controls 2.12; Label { anchors.centerIn: parent; text: "Избранных товаров нет."; font.pixelSize: Qt.application.font.pixelSize * 1.6; }', page);
          } else {
            for (var i = 0; i < liked.rows.length; i++) {
              var good = tx.executeSql('SELECT * FROM goods WHERE id=?', liked.rows.item(i).id);
              if (good.rows.length !== 1) continue;
              var com = Qt.createComponent("components/LikedGood.qml");
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
    contentHeight: cl.y + cl.height + 5
  }
}
