import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle {
  id: rect
  height: parent.height
  
  property bool selected: false
  property alias text: label.text
  property alias img: image.source
  property string path: ""

  Image {
    id: image
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: parent.height / 1.6
    fillMode: Image.PreserveAspectFit
    smooth: true
  }

  ColorOverlay {
    id: co
    anchors.fill: image
    source: image
    color: rect.selected ? "#aa1d4e" : "black";
  }
  
  Label {
    id: label
    width: parent.width
    anchors.top: image.bottom
    horizontalAlignment: "AlignHCenter"
    font.pointSize: 8
    color: rect.selected ? "#aa1d4e" : "black";
  }

  MouseArea {
    anchors.fill: parent
    onPressed: {
      if (rect.selected) return;
      label.color = "grey";
      co.color = "grey";
    }
    onReleased: {
      label.color = rect.selected ? "#aa1d4e" : "black";
      co.color = rect.selected ? "#aa1d4e" : "black";
    }
    onClicked: if (!rect.selected) stackView.push(rect.path)
  }
  
  function reload() {
    label.color = rect.selected ? "#aa1d4e" : "black";
    co.color = rect.selected ? "#aa1d4e" : "black";
  }
}
