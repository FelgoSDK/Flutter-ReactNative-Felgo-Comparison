import Felgo 3.0
import "pages"
import "model"

App {
  id: app

  // use theme setting for padding, aligns content with navigation bar items
  readonly property real contentPadding: dp(Theme.navigationBar.defaultBarItemPadding)

  DataModel {
    id: dataModel
  }

  Page {
    NavigationStack {
      id: navStack
      leftColumnIndex: 1 //second page (listings list) is base for left column
      splitView: tablet

      SearchPage { }
    }
  }
}
