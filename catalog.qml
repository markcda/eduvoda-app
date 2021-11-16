import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15
import "components"

Page {
  id: page
  width: stackView.width
  height: stackView.height
  property int category: 0
  property alias catText: titleLbl.text

  title: "Товары"
  
  StackView.onActivating: bottomTabBar.setSelected(1);

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
          let goods;
          if (category !== 0) {
            goods = tx.executeSql('SELECT * FROM goods WHERE category=?', category);
          } else {
            goods = tx.executeSql('SELECT * FROM goods');
          }
          if (goods.rows.length === 0) {
            let noGoodsInCat = Qt.createQmlObject('import QtQuick 2.0; import QtQuick.Controls 2.12; Label { anchors.centerIn: parent; text: "В данной категории нет товаров."; font.pixelSize: Qt.application.font.pixelSize * 1.6; }', page);
          }
          else {
            for (let i = 0; i < goods.rows.length; i++) {
              let com = Qt.createComponent("components/Good.qml");
              if (com.status === Component.Ready) {
                let obj = com.createObject(lv);
                obj.text = goods.rows.item(i).label;
                obj.img = "file://" + goods.rows.item(i).imageUri;
                obj.id = goods.rows.item(i).id;
                obj.fill();                  
              }
            }
          }
        })
      }
    }
    contentHeight: lv.y + lv.height + 5
  }
}
