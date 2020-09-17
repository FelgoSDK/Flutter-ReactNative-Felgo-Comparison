import Felgo 3.0
import QtQuick 2.0

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    NavigationStack {
        FlickablePage {
            id: main_page
            navigationBarHidden: true
            anchors.top: parent.top
            anchors.topMargin: sp(23)
            anchors.fill: parent

            property var selected_date: new Date()

            Column {
                anchors.fill: parent
                Row {
                    AppImage {
                        width:dp(75)
                        height: dp(75)
                        source: '../assets/daam.png'
                    }

                    AppText {
                        font.bold: true
                        font.pixelSize: sp(30)
                        text: qsTr("Dinner and a Movie")
                    }
                }

                AppText {
                    wrapMode: Text.WordWrap
                    width: parent.width
                    text: qsTr("Tap a movie below to see its details. Then pick a date to see showtimes.")
                }

                AppButton {
                    flat: true
                    fontCapitalization: Font.MixedCase
                    anchors.horizontalCenter: parent.horizontalCenter
                    textSize: sp(17)
                    verticalMargin: sp(3)
                    fontBold: false
                    text: qsTr("I want to watch on ") + main_page.selected_date.toLocaleDateString()
                    onClicked: nativeUtils.displayDatePicker(new Date(), new Date())

                    Connections {
                        target: nativeUtils
                        onDatePickerFinished: {
                            if (accepted)
                                main_page.selected_date = date
                        }
                    }
                }

//                ShowingTimes {
//                    visible: false
//                    id:times
//                    film: null
//                    date: main_page.selected_date
//                }

                Repeater {
                    model: []

                    Component.onCompleted: {
                        HttpRequest.get('http://10.0.0.13:5000/api/films')
                        .then(function(res) {
                            model = res.body
                        })
                    }

                    delegate: MouseArea {
                        onClicked: {
//                            times.film = modelData
//                            times.visible = true
                            main_page.navigationStack.push(details_page, {film: modelData, date: main_page.selected_date})
                        }
                        width: parent.width
                        height: dp(100)

                        Row {
                            anchors.fill: parent

                            // appimage not showing bc of mouse area
                            AppImage {
                                id: img
                                height: dp(70)
                                width: dp(70)
                                source: '../assets/felgo-logo.png' //'http://10.0.0.13:5000'+modelData.poster_path
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - img.width
                                AppText {
                                    width: parent.width
                                    text: modelData.title
                                    font.weight: Font.Bold
                                    fontSize: dp(9)
                                    wrapMode: Text.WordWrap
                                }

                                AppText {
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    text: modelData.tagline
                                }


                            }
                        }
                    }

                }
            }

        }

    }

    Details {
        id: details_page
    }
}
