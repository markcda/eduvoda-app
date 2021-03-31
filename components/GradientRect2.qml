import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
  width: parent.width - 20
  anchors.horizontalCenter: parent.horizontalCenter
  property alias start: lg.start
  property alias end: lg.end
  radius: 10

  LinearGradient {
    id: lg
    anchors.fill: parent
    source: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: Qt.rgba(35 / 256, 130 / 256, 255 / 256, 1) }
      GradientStop { position: 1.0; color: Qt.rgba(52 / 256, 255 / 256, 211 / 256, 1) }
    }
  }
}
