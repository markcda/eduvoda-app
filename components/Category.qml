import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle {
  id: rect
  width: parent.width - 20
  height: 45
  radius: height / 2
  anchors.horizontalCenter: parent.horizontalCenter
  border.width: 3
  border.color: "black"

  property alias catText: label.text
  property int category: 0

  Label {
    id: label
    anchors.centerIn: parent
    horizontalAlignment: "AlignHCenter"
    verticalAlignment: "AlignVCenter"
  }

  MouseArea {
    anchors.fill: parent
    onPressed: {
      rect.color = "grey"
    }
    onReleased: {
      stackView.push("../catalog.qml")
      rect.color = "white"
    }
  }
}
