import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle {
  id: rect
  width: parent.width - 20
  height: 30
  radius: height / 2
  anchors.horizontalCenter: parent.horizontalCenter
  color: "transparent"
  border.width: 1
  border.color: "#e7e7e7"

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
    onPressed: rect.color = "#e7e7e7"
    onReleased: rect.color = "transparent"
    onClicked: stackView.push("../catalog.qml", {"category": category, "catText": catText})
  }
}
