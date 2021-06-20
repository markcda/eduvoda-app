import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "components"

Page {
  id: page
  width: parent.width
  height: parent.height
  topPadding: 5

  title: qsTr("Главная")

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff



    Label {
      id: helloLbl
      y: 10
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      text: "<h1>Привет!</h1><h2>Выбери категорию товаров:</h2>"
      textFormat: Text.RichText
      wrapMode: Text.WordWrap
    }

    Category {
      id: c1
      y: helloLbl.y + helloLbl.height + 10
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
    contentHeight: c5.y + c5.height + 10
  }
}
