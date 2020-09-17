import Felgo 3.0
import QtQuick 2.12


Column {
    property var film
    property var date

    width: parent.width

    AppText {
        width: parent.width
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: sp(20)
        text: qsTr("Showing times for ") + date.toLocaleDateString() + qsTr(" for ") + film.title
    }

    Row {
        spacing: parent.width*0.15
        width: parent.width
        topPadding: sp(20)
        bottomPadding: sp(20)

        Repeater {
            model: []
            Component.onCompleted: {
                HttpRequest.get('http://10.0.0.13:5000/api/showings')
                .then(function(res) {

                    function sameDay(d1, d2) {
                        return d1.getFullYear() === d2.getFullYear() &&
                                d1.getMonth() === d2.getMonth() &&
                                d1.getDate() === d2.getDate();
                    }

                    model = res.body.filter(function(showing) {
                        return showing.film_id === film.id && sameDay(new Date(showing.showing_time), date)
                    })
                });
            }

            delegate: AppText {
                text: formatDate(new Date(modelData.showing_time))
                fontSize: sp(6)

                function formatDate(date) {
                    var hours = (date.getHours()%12).toString();
                    var mins = ('0' + date.getMinutes().toString()).slice(-2);
                    var suffix = (date.getHours()>12) ? 'PM' : 'AM'
                    return hours + ":" + mins + " " + suffix;
                }

            }

        }

    }

}
