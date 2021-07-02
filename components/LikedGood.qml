import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
  id: rec
  property alias img: image.source
  property alias text: label.text
  property int id: 0
  
  anchors.left: parent.left
  anchors.leftMargin: 5
  anchors.right: parent.right
  anchors.rightMargin: 5
  border.color: "black"
  border.width: 1
  
  Image {
    id: image
    anchors.left: parent.left
    anchors.leftMargin: 5
    fillMode: Image.PreserveAspectFit
  }
  
  Label {
    id: label
    anchors.left: image.right
    anchors.leftMargin: 5
    font.pointSize: 13
    font.bold: true
    
    Component.onCompleted: {
      image.height = height;
      rec.height = height + 6;
      rec.radius = rec.height / 2;
    }
  }
  
  ToolButton {
    id: addToBookmark
    icon.source: "../arts/16/bookmark-remove.svg"
    icon.color: "red"
    icon.width: 16
    icon.height: 16
    anchors.right: parent.right

    background: Rectangle {
      anchors.top: rec.top
      anchors.topMargin: 1
      height: rec.height
      width: rec.height
      radius: height / 2
      border.color: "red"
    }
  }
}
