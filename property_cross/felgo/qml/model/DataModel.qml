import QtQuick 2.0
import QtPositioning 5.3
import Qt.labs.settings 1.0

Item {

  //called when a page of listings has been received from the server
  signal listingsReceived

  //called when the location of the device has been received
  signal locationReceived

  //location type, a coordinate type with latitude, longitude and isValid property
  readonly property var location: positionSource.position.coordinate

  //true when there is data being loaded in the background
  //or when the location is being retrieved
  readonly property bool loading: client.loading || positionSource.active

  //total number of found listings, listings property only contains the first page
  readonly property alias numTotalListings: _.numTotalListings

  //list model for listings list page
  readonly property var listings: _.createListingsModel(_.listings)

  //list model for listings list page
  readonly property var favoriteListings: _.createListingsModel(_.favoriteListingsValues, true)

  //list model for search page recent searches list
  readonly property var recentSearches: _.createRecentSearchesModel()

  readonly property bool isError: _.locationSource === _.locationSourceError

  readonly property bool positioningSupported: positionSource.supportedPositioningMethods !== PositionSource.NoPositioningMethods

  function useLocation() {
    if(positionSource.position.coordinate.isValid) {
      //already have a location
      _.searchByLocation()
    } else {
      _.locationSearchPending = true
      positionSource.update()
    }
  }

  function searchListings(searchText, addToRecents) {
    _.lastSearchText = addToRecents ? searchText : ""
    _.listings = []
    client.search(searchText, _.responseCallback)
  }

  function showRecentSearches() {
    _.locationSource = _.locationSourceRecent
  }

  function loadNextPage() {
    client.repeatForPage(_.currentPage + 1, _.responseCallback)
  }

  function toggleFavorite(listingData) {
    var listingDataStr = JSON.stringify(listingData)
    var index =  _.favoriteListingsValues.indexOf(listingDataStr)

    if(index < 0) {
      _.favoriteListingsValues.push(listingDataStr) // add entry to favorites
    } else {
      _.favoriteListingsValues.splice(index, 1)  // remove entry in favorites
    }

    _.favoriteListingsValuesChanged()
  }

  function isFavorite(listingData) {
    return _.favoriteListingsValues.indexOf(JSON.stringify(listingData)) >= 0
  }

  Settings {
    property string recentSearches: JSON.stringify(_.recentSearches)
    property string favoriteListingsValues: JSON.stringify(_.favoriteListingsValues)

    Component.onCompleted: {
      _.recentSearches = recentSearches && JSON.parse(recentSearches) || {}
      _.favoriteListingsValues = favoriteListingsValues && JSON.parse(favoriteListingsValues) || []
    }
  }

  Client {
    id: client
  }

  PositionSource {
    id: positionSource
    active: false

    onActiveChanged: {
      var coord = position.coordinate

      if(!active) {
        if(coord.isValid && _.locationSearchPending) {
          _.searchByLocation()
          _.locationSearchPending = false
        }
      }
    }
  }

  QtObject {
    id: _ //private members

    property int locationSource: locationSourceRecent

    property var favoriteListingsValues: []

    property var recentSearches: ({})

    property var listings: []
    property int numTotalListings

    property int currentPage: 1

    property string lastSearchText: ""

    readonly property int locationSourceRecent: 1
    readonly property int locationSourceError: 2

    readonly property var successCodes: ["100", "101", "110", "200", "202"]

    property bool locationSearchPending: false

    function searchByLocation() {
      locationReceived()
      var coord = positionSource.position.coordinate
      listings = []
      client.searchByLocation(coord.latitude, coord.longitude, _.responseCallback)
    }

    function responseCallback(obj) {
      var code = obj.response.application_response_code
      if(successCodes.indexOf(code) >= 0) {
        //found a location -> display listings
        currentPage = parseInt(obj.response.page)
        listings = listings.concat(obj.response.listings)
        numTotalListings = obj.response.total_results || 0
        addRecentSearch(qsTr("%1 (%2 listings)").arg(lastSearchText).arg(numTotalListings))
        listingsReceived()
      } else {
        //found nothing -> display error
        locationSource = locationSourceError
      }
    }

    function createRecentSearchesModel() {
      return Object.keys(recentSearches).map(function(text) {
        return {
          heading: "Recent Searches",
          text: recentSearches[text].displayText,
          searchText: text
        }
      })
    }

    function createListingsModel(source, parseValues) {
      return source.map(function(data) {
        if(parseValues)
          data = JSON.parse(data)

        return {
          text: data.price_formatted,
          detailText: data.title,
          image: data.thumb_url,
          model: data
        }
      })
    }

    function addRecentSearch(displayText) {
      if(lastSearchText) {
        recentSearches[lastSearchText] = {
          displayText: displayText
        }
        _.recentSearchesChanged()
      }
    }
  }
}

