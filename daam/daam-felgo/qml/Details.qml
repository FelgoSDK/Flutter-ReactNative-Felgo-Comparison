import Felgo 3.0
import QtQuick 2.12

Component {
    id: details_page

    FlickablePage {
        id: details_page_flickable
        property var film
        property var date
        navigationBarHidden: true

        Column {
            width: parent.width
            padding: sp(20)
            property real available_width: width - leftPadding - rightPadding

            AppImage {
                source: 'http://10.0.0.13:5000'+film.poster_path
                width: parent.available_width
                height: width
            }

            ShowingTimes {
                film: details_page_flickable.film
                date: main_page.selected_date
                width: parent.available_width
            }

            AppText {
                font.pixelSize: sp(30)
                width: parent.available_width
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                text: film.title
            }

            AppText {
                text: film.tagline
                font.pixelSize: sp(20)
                width: parent.available_width
            }

            AppText {
                width: parent.available_width
                horizontalAlignment: Text.AlignHCenter
                text: film.homepage
                font.pixelSize: sp(14)
            }

            AppText {
                text: film.overview
                width: parent.available_width
                font.pixelSize: sp(15)
                topPadding: sp(17)
                bottomPadding: sp(17)
            }

            AppText {
                width: parent.available_width
                text: qsTr("Release date")+": "+film.release_date
                font.pixelSize: sp(14)
            }

            AppText {
                text: qsTr("Running time")+": "+film.runtime + " " + qsTr("minutes")
                font.pixelSize: sp(14)
                width: parent.available_width
                horizontalAlignment: Text.AlignHCenter
            }
            Row {
                width: parent.available_width
                height: sp(20)
                spacing: sp(60)
                leftPadding: sp(50)

                Row {
                    height: parent.height
                    AppText {
                        text: qsTr("Rating") + ": " + film.vote_average + "/"
                        font.pixelSize: sp(20)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    AppText {
                        text: '10'
                        font.pixelSize: sp(10)
                        anchors.bottom: parent.bottom
                    }
                }


                AppText {
                    text: film.vote_count + ' ' + qsTr("votes")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            AppButton {
                onClicked: main_page.navigationStack.pop()
                text: qsTr("Done")
                backgroundColor: "lightgrey"
                textColor: "black"
                fontCapitalization: Font.MixedCase
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
