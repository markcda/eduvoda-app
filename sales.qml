import QtQuick 2.12
import QtQuick.Controls 2.5
import "components"

Page {
  width: parent.width
  height: parent.height

  title: "Скидки"

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    GradientRect1 {
      id: gr1
      y: 10
      anchors.horizontalCenter: parent.horizontalCenter

      Label {
        id: gr1Lbl
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: 5
        color: "white"
        text: "Для физических лиц, купивших 2 бутылки воды по 19 литров, механическая помпа и залог на тару всего за 1050 рублей!"
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        font.pointSize: 14
      }
      height: gr1Lbl.height + 10

      start: Qt.point(x, y)
      end: Qt.point(x + width, y + height)
    }

    GradientRect2 {
      id: gr2
      y: gr1.y + gr1.height + 5
      anchors.horizontalCenter: parent.horizontalCenter

      Label {
        id: gr2Lbl
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: 5
        color: "white"
        text: "Для юридических лиц, заключивших договор на доставку воды на весь 2021 год, тара предоставляется без залога!"
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        font.pointSize: 14
      }
      height: gr2Lbl.height + 10

      start: Qt.point(x, y)
      end: Qt.point(x + width, y + height)
    }
    contentHeight: gr2.y + gr2.height + 10
  }
}
