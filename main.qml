import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
  id: window
  width: 380
  height: 700
  visible: true
  title: qsTr("ЕдуВода")

  header: ToolBar {
    contentHeight: toolButton.implicitHeight

    ToolButton {
      id: toolButton
      text: stackView.depth > 1 ? "\u25C0" : "\u2630"
      font.pixelSize: Qt.application.font.pixelSize * 1.6
      onClicked: {
        if (stackView.depth > 1) {
          stackView.pop()
        } else {
          drawer.open()
        }
      }
    }

    Label {
      text: stackView.currentItem.title
      anchors.centerIn: parent
    }
  }

  Drawer {
    id: drawer
    width: window.width * 0.66
    height: window.height

    Column {
      anchors.fill: parent

      ItemDelegate {
        text: qsTr("О нас")
        width: parent.width
        onClicked: {
          stackView.push("aboutus.qml")
          drawer.close()
        }
      }
      ItemDelegate {
        text: qsTr("Акции")
        width: parent.width
        onClicked: {
          stackView.push("sales.qml")
          drawer.close()
        }
      }
    }
  }

  StackView {
    id: stackView
    initialItem: "startscreen.qml"
    anchors.fill: parent
  }
}
