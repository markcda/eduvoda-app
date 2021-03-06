import QtQuick 2.12
import QtQuick.Controls 2.5
import "components"

Page {
  width: parent.width
  height: parent.height

  title: "О нас"
  
  StackView.onActivating: bottomTabBar.setSelected(0);

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    Label {
      id: aboutLbl
      width: parent.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      text: "<h2>О нашей компании</h2>Доставку воды в 19 литровых бутылях и оборудования
осуществляют опытные водители-экспедиторы непосредственно к Вам домой или в офис.
Оформить заказ можно непосредственно через сайт или позвонив по телефону, указанному на сайте.<br>
Доставка воды на дом станет верным решением вопроса обеспечения Вас и вашей семьи качественной
и чистой питьевой водой в любое время суток. Заказав воду на дом в нашем магазине,
Вы можете быть уверены, что в кратчайшие сроки Вы будете обеспечены очищенной питьевой водой,
обогащенной полезными элементами, которая позволит сохранить здоровье Вам и вашим близким.<br>
Приоритет нашей компании — забота о клиентах. Мы предлагаем Вам только сертифицированную питьевую
воду высшего качества:<br>— О’три<br>— Губернская<br>— Лея<br>А также у нас Вы можете приобрести
дополнительное оборудование: кулеры и помпы.<h2>Сертификаты качества</h2>Протокол исследования
ФГБУ НИИ включает органолептические показатели, солевой состав и степень органического загрязнения.
По итогам исследования вода высшей категории О'три рекомендована для питьевых целей и приготовления
пищи детям от нуля до трёх лет и детском питании при искусственном вскармливании."
      wrapMode: Text.WordWrap
      textFormat: Text.RichText
      font.pointSize: 14
    }

    GreenBtn {
      id: goHome
      y: aboutLbl.y + aboutLbl.height + 5
      anchors.bottomMargin: 10
      text: "Купить"
      ma.onClicked: {
        while (stackView.depth > 1)
          stackView.pop()
      }
    }
  contentHeight: goHome.y + goHome.height + 10
  }
}
