import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
  width: parent.width
  height: parent.height

  title: qsTr("Профиль")
  
  StackView.onActivating: bottomTabBar.setSelected(4);
  
  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff
  }
}
