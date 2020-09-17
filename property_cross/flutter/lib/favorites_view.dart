import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_view.dart';

class FavouritesView extends StatefulWidget {
  final Function _pushDetailView;

  FavouritesView(this._pushDetailView);

/*

    ListView _buildListView() {
      return ListView.builder(
          itemCount: _favorites.length,
          itemBuilder: (context, index) {
            return Text(_favorites[index]);
          });
    }
*/

  @override
  State<StatefulWidget> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  List<String> favourites = new List<String>();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        favourites = prefs.getStringList('favourites');
        if (favourites == null) favourites = List<String>();
      });
    });
    super.initState();
  }

  void _pushDetailView(Map<String, dynamic> element) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailView(element)));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listings = new List<Widget>();
    for (var fav_string in favourites) {
      var element = json.decode(fav_string);
      listings.add(Column(children: <Widget>[
        ListTile(
            leading: Image.network(element["thumb_url"]),
            title: Text(element["price_formatted"].toString()),
            subtitle: Text(element["title"].toString()),
            onTap: () {
              _pushDetailView(element);
            }),
        Divider(),
      ]));
    }

    print("rendering 2");

    return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: listings.length == 0
            ? Center(
                child: Text(
                    "You have not added any properties to your favourites"))
            : ListView(children: listings));
  }
}
