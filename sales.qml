import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.15
import "components"

Page {
  id: page
  width: parent.width
  height: parent.height

  title: "Скидки"
  
  StackView.onActivating: bottomTabBar.setSelected(0);

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    Component.onCompleted: {
      let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
      db.transaction(function (tx) {
        let sales = tx.executeSql('SELECT * FROM sales');
        if (sales.rows.length === 0) {
          var noSales = Qt.createQmlObject('import QtQuick 2.0; import QtQuick.Controls 2.12; Label { anchors.centerIn: parent; text: "На данный момент скидок нет."; wrapMode: Text.WordWrap; font.pixelSize: Qt.application.font.pixelSize * 1.6; }', page);
          return;
        }
        for (let i = 0; i < sales.rows.length; i++) {
          let obj = Qt.createQmlObject(sales.rows[i].component, sv);
          if (i === 0) 
            obj.y = 10;
          else {
            let V = sv.children[sv.children.length - 2];
            obj.y = V.y + V.height + 5;
          }
        }
        let V = sv.children[sv.children.length - 1];
        sv.contentHeight = V.y + V.height + 10;
      })
    }
  }
}
