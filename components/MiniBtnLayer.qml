import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
  property int goodId: 0
  property int numOfGoods: 1
  signal changed

  Rectangle {
    id: numOfGoodsEditor
    color: "transparent"
    border.color: "#e7e7e7"
    implicitHeight: 30
    radius: 15

    Row {
      id: row
      height: 30
      padding: 0

      ToolButton {
        id: sub
        anchors.verticalCenter: parent.verticalCenter
        text: "-"
        implicitWidth: 30
        implicitHeight: 30
        Layout.rightMargin: 0
        onClicked: {
          if (numOfGoods > 1)
            numOfGoods -= 1;
        }

        contentItem: Text {
          anchors.centerIn: sub
          text: sub.text
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: "red"
        }
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 1
        implicitHeight: numOfGoodsEditor.height
        color: numOfGoodsEditor.border.color
      }

      Label {
        anchors.verticalCenter: parent.verticalCenter
        text: numOfGoods + " шт"
        rightPadding: 5
        leftPadding: 5
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 1
        implicitHeight: numOfGoodsEditor.height
        color: numOfGoodsEditor.border.color
      }

      ToolButton {
        id: add
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 30
        implicitHeight: 30
        Layout.leftMargin: 0
        text: "+"
        onClicked: numOfGoods += 1;

        contentItem: Text {
          anchors.centerIn: add
          text: add.text
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: "green"
        }
      }
    }

    implicitWidth: row.width
  }
}
