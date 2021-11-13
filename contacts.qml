import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
  width: parent.width
  height: parent.height

  title: qsTr("Страница 2")
  
  StackView.onActivating: bottomTabBar.setSelected(0);

  Label {
    text: qsTr("You are on Page 2.")
    anchors.centerIn: parent
  }
}
