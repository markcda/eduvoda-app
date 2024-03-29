import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.15
import "components"

Page {
  title: "Вход в приложение"
  
  StackView.onActivating: bottomTabBar.setSelected(0);

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
      placeholderText: "Ваш номер телефона (+7XXXXXXXXXX)"
      validator: RegularExpressionValidator {
        regularExpression: /\+[0-9]+/
      }
    }

    GreenBtn {
      id: registerBtn
      y: phoneField.y + phoneField.height + 10
      anchors.bottomMargin: 10
      text: "Зарегистрироваться"
      ma.onClicked: {
        regError.text = "";
        if (nameField.text === "") {
          regError.text = "Вы не ввели своё имя";
          return;
        }
        if (!(nh.isInternetAvailable())) {
          regError.text = "Интернет недоступен. Повторите попытку позже.";
          return;
        }
        let db = LocalStorage.openDatabaseSync("db", "1.0", "EduVodaLDB", 1000000);
        db.transaction(function (tx) {
          tx.executeSql('CREATE TABLE fs (key TEXT, val TEXT)');
          tx.executeSql('INSERT INTO fs VALUES (?, ?)', ["name", nameField.text]);
          tx.executeSql('INSERT INTO fs VALUES (?, ?)', ["email", emailField.text]);
          tx.executeSql('INSERT INTO fs VALUES (?, ?)', ["phone", phoneField.text]);
        });
        while (stackView.depth > 1)
          stackView.replace("startscreen.qml", StackView.PopTransition);
        pushBackToolButton.visible = true;
      }
    }

    Label {
      id: regError
      visible: regError.text === "" ? false : true
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
