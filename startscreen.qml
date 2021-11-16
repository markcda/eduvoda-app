import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15
import "components"

Page {
  id: page
  width: parent.width
  height: parent.height

  title: qsTr("ЕдуВода")
  
  StackView.onActivating: bottomTabBar.setSelected(0);

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    Label {
      id: catLbl
      y: 5
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      text: "<h1>Категории товаров</h1>"
      textFormat: Text.RichText
      wrapMode: Text.WordWrap
    }

    Category {
      id: c0
      y: catLbl.y + catLbl.height + 5
      catText: "Все товары"
      category: 0
    }
    
    Category {
      id: c1
      y: c0.y + c0.height + 5
      catText: "Питьевая вода (5 л)"
      category: 1
    }

    Category {
      id: c2
      y: c1.y + c1.height + 5
      catText: "Питьевая вода (19 л)"
      category: 2
    }

    Category {
      id: c3
      y: c2.y + c2.height + 5
      catText: "Кулеры"
      category: 3
    }

    Category {
      id: c4
      y: c3.y + c3.height + 5
      catText: "Помпы"
      category: 4
    }

    Category {
      id: c5
      y: c4.y + c4.height + 5
      catText: "Сопутствующие товары"
      category: 5
    }
    
    Column {
      id: cl
      y: c5.y + c5.height
      width: parent.width
      spacing: 5
      
      Component.onCompleted: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        db.transaction(function (tx) {
          let sales = tx.executeSql('SELECT * FROM sales');
          if (sales.rows.length !== 0) {
            let slbl = Qt.createQmlObject("import QtQuick 2.12; import QtQuick.Controls 2.5; Label { id: salesLbl; width: parent.width - 20; anchors.horizontalCenter: parent.horizontalCenter; text: \"<h1>Акции</h1>\"; textFormat: Text.RichText; wrapMode: Text.WordWrap }", cl);
            for (let i = 0; i < sales.rows.length; i++) {
              if (i !== 5) {
                let obj = Qt.createQmlObject(sales.rows[i].component, cl);
              } else {
                let com = Qt.createComponent("components/GreenBtn.qml");
                if (com.status === Component.Ready) {
                  let obj = com.createObject(cl);
                  obj.text = "Посмотреть ещё";
                }
                break;
              }
            }
          }
        })
      }
    }
    
    Column {
      id: cl2
      y: cl.y + cl.height
      width: parent.width
      spacing: 5
      
      Component.onCompleted: {
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        db.transaction(function (tx) {
          let liked = tx.executeSql('SELECT * FROM liked');
          if (liked.rows.length !== 0) {
            let slbl = Qt.createQmlObject("import QtQuick 2.12; import QtQuick.Controls 2.5; Label { id: salesLbl; width: parent.width - 20; anchors.horizontalCenter: parent.horizontalCenter; text: \"<h1>Избранные</h1>\"; textFormat: Text.RichText; wrapMode: Text.WordWrap }", cl2);
            for (let i = 0; i < liked.rows.length; i++) {
              if (i !== 5) {
                let _good = tx.executeSql('SELECT * FROM goods WHERE id=?', liked.rows[i].id);
                if (_good.rows.length === 0) { continue; }
                let com = Qt.createComponent("components/LikedGood.qml");
                if (com.status === Component.Ready) {
                  let obj = com.createObject(cl2);
                  obj.text = _good.rows.item(0).label;
                  obj.img = "file://" + _good.rows.item(0).imageUri;
                  obj.id = _good.rows.item(0).id;
                  obj.fill();
                }
              } else {
                let com = Qt.createComponent("components/GreenBtn.qml");
                if (com.status === Component.Ready) {
                  let obj = com.createObject(cl2);
                  obj.text = "Посмотреть ещё";
                }
                break;
              }
            }
          }
        })
      }
    }
    contentHeight: cl2.y + cl2.height + 5    
  }
}
