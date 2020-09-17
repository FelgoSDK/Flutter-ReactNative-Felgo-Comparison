import QtQuick 2.0
import Felgo 3.0

Item {
  readonly property bool loading: HttpNetworkActivityIndicator.enabled

  Component.onCompleted: {
    HttpNetworkActivityIndicator.activationDelay = 0
  }

  //search for locations called "text"
  function search(text, callback) {
    _.sendRequest({
                    action: "search_listings",
                    page: 1,
                    place_name: text
                  }, callback)
  }

  function searchByLocation(latitude, longitude, callback) {
    _.sendRequest({
                    action: "search_listings",
                    page: 1,
                    centre_point: latitude + "," + longitude
                  }, callback)
  }

  //repeat last request for another page number
  function repeatForPage(page, callback) {
    var params = _.lastParamMap
    params.page = page
    _.sendRequest(params, callback)
  }

  Item {
    id: _ //private members

    property var lastParamMap: ({})

    //add GET parameters to serverUrl
    function buildUrl(paramMap) {
      var url = "https://felgo.com/mockapi-propertycross?country=uk"
      for(var param in paramMap) {
        url += "&" + param + "=" + paramMap[param]
      }
      return url
    }

    function sendRequest(paramMap, callback) {
      var url = buildUrl(paramMap)

      HttpRequest.get(url).then(function(res) {
        try {
          var obj = JSON.parse(res.text)
        } catch(ex) {
          console.error("Could not parse server response as JSON:", ex)
          return
        }
        callback(obj)
      }).catch(function(err) { })

      lastParamMap = paramMap
    }
  }
}

