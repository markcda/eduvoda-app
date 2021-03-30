import QtQuick 2.12
import QtQuick.Controls 2.5
import "components"

Page {
  id: page
  width: parent.width
  height: parent.height
  topPadding: 5

  title: qsTr("Главная")

  Column {
    width: parent.width
    anchors.verticalCenter: parent.verticalCenter
    spacing: 5

    Category {
      catText: "Питьевая вода (5 л)"
      category: 1
    }

    Category {
      catText: "Питьевая вода (19 л)"
      category: 2
    }

    Category {
      catText: "Кулеры"
      category: 3
    }

    Category {
      catText: "Помпы"
      category: 4
    }

    Category {
      catText: "Сопутствующие товары"
      category: 5
    }
  }
}
