import Felgo 3.0

App {
  Navigation {
    NavigationItem {
      title: "Advanced Animations"
      icon: IconType.home

      NavigationStack {
        AdvancedAnimations {
          title: "Advanced Animations"
        }
      }
    }

    NavigationItem {
      title: "Rotating Cube"
      icon: IconType.cube

      NavigationStack {
        RotatingCube {
          title: "Rotating Cube"
        }
      }
    }
  }
}
