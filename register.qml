import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15
import "components"

Page {
  anchors.fill: parent

  title: "Вход в приложение"

  ScrollView {
    id: sv
    width: parent.width
    height: parent.height
    contentWidth: -1

    ScrollBar.horizontal.policy: Qt.ScrollBarAlwaysOff

    Label {
      id: aboutRegistration
      y: 10
      width: parent.width
      leftPadding: 5
      rightPadding: 5
      textFormat: Text.RichText
      wrapMode: Text.WordWrap
      text: "Для того, чтобы использовать приложение, необходимо ввести свои контактные данные, чтобы мы могли с вами связаться, когда вы что-нибудь закажете."
    }

    TextField {
      id: nameField
      width: parent.width
      leftPadding: 5
      rightPadding: 5
      y: aboutRegistration.y + aboutRegistration.height + 10
      placeholderText: "Ваше имя"
    }

    TextField {
      id: emailField
      width: parent.width
      leftPadding: 5
      rightPadding: 5
      y: nameField.y + nameField.height + 10
      placeholderText: "Ваш email"
      inputMethodHints: Qt.ImhEmailCharactersOnly
      validator: RegularExpressionValidator {
        regularExpression: /^[A-Za-z0-9.\_]+@[A-Za-z0-9.\_]+/
      }
    }

    TextField {
      id: phoneField
      width: parent.width
      leftPadding: 5
      rightPadding: 5
      y: emailField.y + emailField.height + 10
      placeholderText: "Ваш номер телефона"
      validator: RegularExpressionValidator {
        regularExpression: /\+[0-9]+/
      }
    }

    TextField {
      id: passField
      width: parent.width
      leftPadding: 5
      rightPadding: 5
      y: phoneField.y + phoneField.height + 10
      placeholderText: "Пароль"
      echoMode: TextInput.Password
    }

    GreenBtn {
      id: registerBtn
      y: passField.y + passField.height + 10
      anchors.bottomMargin: 10
      text: "Зарегистрироваться"
      ma.onClicked: {
        while (stackView.depth > 1)
          stackView.pop();
        pushBackToolButton.visible = true;
      }
    }

    Label {
      id: regError
      visible: false
      color: "#FF0000"
      leftPadding: 5
      rightPadding: 5
      textFormat: Text.RichText
      wrapMode: Text.WordWrap
      width: parent.width
      horizontalAlignment: Text.AlignHCenter
      y: registerBtn.y + registerBtn.height + 5
    }

    contentHeight: regError.y + regError.height + 10
  }
}
