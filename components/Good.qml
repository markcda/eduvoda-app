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
  property alias img: image.source
  property int category: 0
  property int id: 0

  Image {
    id: image
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: parent.height - 50
    fillMode: Image.PreserveAspectFit
  }

  Label {
    id: label
    width: parent.width
    anchors.bottom: minibtn.top
    horizontalAlignment: "AlignHCenter"
    elide: Text.ElideRight
    wrapMode: Text.WordWrap
  }

  MouseArea {
    anchors.fill: parent
    onPressed: rect.color = "grey"
    onReleased: rect.color = "white"
    onClicked: stackView.push("../good.qml", {"id": id})
  }

  MiniBtnLayer {
    height: 35
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.bottom: parent.bottom
    id: minibtn
  }

  ToolButton {
    id: addToBasket
    icon.source: "../arts/16/amarok_cart_add.svg"
    icon.color: "white"
    icon.width: 18
    icon.height: 18
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.bottomMargin: 5
    anchors.rightMargin: 5

    background: Rectangle {
      anchors.centerIn: addToBasket
      width: addToBasket.width
      height: addToBasket.height
      radius: height / 2
      color: "red"
    }
  }

  ToolButton {
    id: addToBookmark
    icon.source: "../arts/16/bookmark-new.svg"
    icon.color: "red"
    icon.width: 16
    icon.height: 16
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 5
    anchors.rightMargin: 5

    background: Rectangle {
      anchors.centerIn: addToBookmark
      width: addToBookmark.width
      height: addToBookmark.height
      radius: height / 2
      border.color: "red"
    }
  }
}
