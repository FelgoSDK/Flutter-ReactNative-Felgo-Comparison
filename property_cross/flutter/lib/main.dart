import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './detail_view.dart';
import './favorites_view.dart';
import './result_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Cross Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Property Cross'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String search;
  final myController = TextEditingController();

  List<String> recent_searches = new List<String>();

  bool _problem = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        for (var query in pref.getStringList('recent_searches'))
          recent_searches.add(query);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  void pushResultsForQuery() {
    // _save(myController.text);
    if (myController.text == "") {
      setState(() {
        _problem = true;
      });
      return;
    }
    recent_searches.add(myController.text);
    SharedPreferences.getInstance().then((pref) {
      pref.setStringList('recent_searches', recent_searches);
      print(pref.getStringList('recent_searches'));
    });
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ResultView(_pushDetailView, {'place_name': myController.text})));
  }

  void pushResultsForLocation() async {
    var location = new Location();
    if (!await location.hasPermission()) await location.requestPermission();
    var pos = await location.getLocation();
    var params = {
      'centre_point': pos.latitude.toString() + "," + pos.longitude.toString()
    };
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ResultView(_pushDetailView, params)));
  }

  void _pushFavorites() {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => FavouritesView(_pushDetailView)));
  }

  void _pushDetailView(Map<String, Object> element) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailView(element)));
  }

  @override
  Widget build(BuildContext context) {
    /*if (recent_searches.length > 3)
      recent_searches = recent_searches.sublist(1);*/
    var recent_search_tiles = new List<Widget>();
    recent_search_tiles.add(ListTile(
        title: Text(
      "Recent Searches",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
    )));
    for (var query in recent_searches)
      recent_search_tiles.add(ListTile(
        title: Text(query),
        onTap: () {
          myController.text = query;
          pushResultsForQuery();
        },
      ));

    var _bottom = _problem
        ? Text("There was a problem with your search")
        : Container(
            height: 200, child: ListView(children: recent_search_tiles));

    myController.addListener(() {
      setState(() {
        _problem = false;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.favorite), onPressed: _pushFavorites),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            child: Column(children: <Widget>[
              Text("Use the form below to search for houses to buy."
                  "You can search by place-name, postcode, "
                  "or click 'My location', "
                  "to search in your current location."),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Hint: You can quickly find and view results by searching 'London'.",
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Visibility(
                        visible: myController.text.length > 0,
                        child: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: myController.clear))),
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                      onPressed: pushResultsForQuery, child: Text('Go!')),
                  FlatButton(
                      onPressed: pushResultsForLocation,
                      child: Text(
                        'My Location'.toUpperCase(),
                      ))
                ],
              ),
              _bottom
            ]),
          ),

          /*Expanded(
            child: _buildList(),
          ),*/
        ],
      ),
    );
  }
}
