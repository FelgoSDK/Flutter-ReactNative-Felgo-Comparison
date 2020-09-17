import Felgo 3.0
import QtQuick 2.0
App {
  NavigationStack {
    Page {
      id: page
      title: "Page with animations"
      Column {
        anchors.centerIn: parent
        spacing: dp(10)
        AppButton {
          text: "Click me"
          onClicked: hiddenText.opacity = hiddenText.opacity > 0 ? 0 : 1
        }
        AppText {
          id: hiddenText
          text: "I slowly fade in"
          opacity: 0
          // Just this line, automatically animate changes
          Behavior on opacity { NumberAnimation { duration: 3000 } }
        }
      }
    }
  }
}
