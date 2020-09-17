import Felgo 3.0
import QtQuick 2.6
import QtGraphicalEffects 1.0

FlickablePage {
  id: page

  flickable.contentHeight: column.height

  property bool applyFilters: false

  AppImage {
    width: dp(300)
    height: dp(200)
    source: "https://picsum.photos/" + Math.floor(width)+ "/" + Math.floor(height)
    anchors.centerIn: image
    visible: false
    id: image
  }

  Column {
    id: column
    padding: dp(16)
    spacing: dp(16)
    anchors.centerIn: parent

    FastBlur {
      width: image.width
      height: image.height
      source: image

      radius: page.applyFilters ? 100 : 0

      Behavior on radius { NumberAnimation { duration: 2000 } }
    }

    Desaturate {
      width: image.width
      height: image.height
      source: image
      desaturation: page.applyFilters ? 1.0 : 0

      Behavior on desaturation { NumberAnimation { duration: 2000 } }
    }

    ShaderEffect {
      width: image.width;
      height: image.height

      // Qt will take care of transorming this into a uniform texture
      property variant src: image
      property color colorization: "#ff0000"
      property real animationBlend: page.applyFilters ? 1.0 : 0.0

      fragmentShader: "
            uniform sampler2D src;
            uniform lowp float animationBlend;
            uniform lowp vec4 colorization;
            uniform lowp float qt_Opacity;
            varying highp vec2 qt_TexCoord0;

            void main() {
              lowp vec4 tex = texture2D(src, qt_TexCoord0);
              gl_FragColor = vec4(tex * mix(vec4(1.0), colorization, animationBlend)) * qt_Opacity;
            }"

      Behavior on animationBlend { NumberAnimation { duration: 2000 } }

      SequentialAnimation on colorization {
        running: page.applyFilters

        ColorAnimation { from: "#ff6666"; to: "#66ff66"; duration: 2000 }
        ColorAnimation { from: "#66ff66"; to: "#6666ff"; duration: 2000 }
        ColorAnimation { from: "#6666ff"; to: "#ff6666"; duration: 2000 }

        loops: Animation.Infinite
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: page.applyFilters = !page.applyFilters
  }
}
