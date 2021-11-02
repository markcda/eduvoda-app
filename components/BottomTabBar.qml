import QtQuick 2.0
import QtQuick.Layouts 1.15

Rectangle {
  id: rl
  color: "white"

  BottomTabBarButton {
    id: catalogBTBBtn
    anchors.verticalCenter: parent.verticalCenter
    width: 60
    x: (parent.width - 4 * width - 3 * 30) / 2
    text: "Каталог"
    img: "../arts/16/view-multiple-objects.svg"
    path: "../catalog.qml"
  }
  
  BottomTabBarButton {
    id: historyBtn
    anchors.verticalCenter: parent.verticalCenter
    width: 60
    x: (parent.width - 4 * width - 3 * 30) / 2 + width + 30
    text: "Мои заказы"
    img: "../arts/16/amarok_cart_view.svg"
    path: "../basket.qml"
  }
  
  BottomTabBarButton {
    id: favoritesBtn
    anchors.verticalCenter: parent.verticalCenter
    width: 60
    x: (parent.width - 4 * width - 3 * 30) / 2 + 2 * (width + 30)
    text: "Избранное"
    img: "../arts/16/bookmarks.svg"
    path: "../liked.qml"
  }
  
  BottomTabBarButton {
    id: profileBtn
    anchors.verticalCenter: parent.verticalCenter
    width: 60
    x: (parent.width - 4 * profileBtn.width - 3 * 30) / 2 + 3 * (width + 30)
    text: "Профиль"
    img: "../arts/16/username-copy.svg"
    path: "../profile.qml"
  }
}
