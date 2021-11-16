import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle {
  id: rect
  width: parent.width - 20
  height: 30
  radius: height / 2
  anchors.horizontalCenter: parent.horizontalCenter
  color: "green"

  property alias text: label.text
  property alias ma: ma

  Label {
    id: label
    anchors.centerIn: parent
    horizontalAlignment: "AlignHCenter"
    verticalAlignment: "AlignVCenter"
    color: "white"
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    onPressed: rect.color = "darkgreen"
    onReleased: rect.color = "green"
  }
}
