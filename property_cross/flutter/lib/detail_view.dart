import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailView extends StatefulWidget {
  Map<String, dynamic> data;

  DetailView(this.data);

  @override
  State<StatefulWidget> createState() => _DetailViewState(data);
}

class _DetailViewState extends State<DetailView> {
  Map<String, dynamic> data;

  _DetailViewState(this.data);

  List<String> favourites;
  bool isFavourite = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        favourites = prefs.getStringList('favourites');
        if (favourites == null) favourites = new List<String>();
        isFavourite = favourites.contains(json.encode(data));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Property Details"),
        actions: <Widget>[
          IconButton(
              icon: isFavourite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: _toggleFavorite)
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Text(data["price_formatted"].toString(),
                    style: TextStyle(fontSize: 24))),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(data["title"].toString(),
                    style: TextStyle(fontSize: 21))),
            Card(
                child: Image.network(data["img_url"].toString(),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover)),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${data["bedroom_number"]} bed, ${data["bathroom_number"]} bathrooms')),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(data["summary"].toString())),
          ])),
    );
  }

  void _toggleFavorite() {
    setState(() {
      isFavourite = !isFavourite;

      SharedPreferences.getInstance().then((prefs) {
        if (isFavourite)
          favourites.add(json.encode(data));
        else
          favourites.remove(json.encode(data));
        prefs.setStringList('favourites', favourites);
      });
    });
  }
}
