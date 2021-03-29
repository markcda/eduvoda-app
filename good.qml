import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
  width: parent.width
  height: parent.height

  title: qsTr("Страница 1")

  Label {
    text: qsTr("You are on Page 1.")
    anchors.centerIn: parent
  }
}
