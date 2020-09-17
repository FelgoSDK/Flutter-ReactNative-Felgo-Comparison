import Felgo 3.0
import QtQuick 2.9

// Qt3D imports
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick.Scene2D 2.9
import QtQuick.Scene3D 2.0

import QtGraphicalEffects 1.0

Page {
  Scene3D {
    id: scene3d
    anchors.fill: parent
    focus: true
    aspects: ["input", "logic"]
    cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

    Entity {
      Camera {
        id: camera3D
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 45
        nearPlane : 0.1
        farPlane : 1000.0
        position: Qt.vector3d( 0.0, 0.0, 40.0 )
        upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
      }

      components: [
        RenderSettings {
          activeFrameGraph: ForwardRenderer {
            camera: camera3D
            clearColor: "transparent"
          }
        },
        InputSettings { }
      ]

      TextureMaterial {
        id: material
        texture: offscreenTexture
      }

      CuboidMesh {
        id: cubeMesh
        xExtent: 8
        yExtent: 8
        zExtent: 8
      }

      Transform {
        id: cubeTransform

        NumberAnimation on rotationX { from: 0; to: 360; duration: 40000; loops: Animation.Infinite }
        NumberAnimation on rotationY { from: 0; to: 360; duration: 35000; loops: Animation.Infinite }
      }

      // This is the 3D cube we are displaying
      Entity {
        id: cube
        components: [ cubeMesh, material, cubeTransform ]
      }

      // We renderer the Felgo component to an offscreen texture. Not drawn but usable from other components.
      Scene2D {
        id: qmlTexture
        output: RenderTargetOutput {
          attachmentPoint: RenderTargetOutput.Color0
          texture: Texture2D {
            id: offscreenTexture
            width: 512
            height: 512
            format: Texture.RGBA8_UNorm
            generateMipMaps: true
            magnificationFilter: Texture.Linear
            minificationFilter: Texture.LinearMipMapLinear
            wrapMode {
              x: WrapMode.ClampToEdge
              y: WrapMode.ClampToEdge
            }
          }
        }

        entities: [ cube ]
        mouseEnabled: false

        // The content consists of an image with the blurring effect.
        AppImage {
          width: 512
          height: 512
          source: "https://picsum.photos/512/512"
          anchors.centerIn: image
          visible: false
          id: image
        }

        FastBlur {
          width: image.width
          height: image.height
          source: image
          radius: 0

          // Animation on the blurring effect
          SequentialAnimation on radius {
            NumberAnimation { from: 0; to: 100; duration: 3000 }
            NumberAnimation { from: 100; to: 0; duration: 3000 }
            loops: Animation.Infinite
          }
        }
      }
    }
  }
}
