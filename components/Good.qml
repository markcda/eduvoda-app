import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
  id: rect
  width: parent.width / 2 - 20
  height: width
  radius: 5
  border.width: 2
  border.color: "black"
  Layout.alignment: Qt.AlignCenter
  Layout.margins: 5

  property alias text: label.text
  property int category: 0

  Label {
    id: label
    width: parent.width
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 5
    horizontalAlignment: "AlignHCenter"
    elide: Text.ElideRight
    wrapMode: Text.WordWrap
  }

  MouseArea {
    anchors.fill: parent
    onPressed: rect.color = "grey"
    onReleased: rect.color = "white"
    onClicked: stackView.push("../good.qml")
  }
}
