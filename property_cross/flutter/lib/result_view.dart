import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './detail_view.dart';

class ResultView extends StatefulWidget {
  final Function pushDetailView;
  final Map<String, String> _params;

  ResultView(this.pushDetailView, this._params);

  @override
  State<StatefulWidget> createState() {
    return _ResultViewState(_params);
  }
}

class _ResultViewState extends State<ResultView> {
  List<Map<String, dynamic>> _items = List<Map<String, dynamic>>();

  Map<String, dynamic> data;

  final Map<String, dynamic> _params;

  _ResultViewState(this._params);

  int _match_count = 0;

  int page = 0;

  bool loadingPage = false;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    loadNextPage();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels <=
              200 &&
          _items.length < data["response"]["total_results"]) loadNextPage();
    });

    super.initState();
  }

  void loadNextPage() {
    if (loadingPage) return;
    loadingPage = true;
    Map<String, String> params = {
      'country': 'uk',
      'pretty': '1',
      'encoding': 'json',
      'listing_type': 'buy',
      'action': 'search_listings',
      'page': (page++).toString(),
    };

    params.addAll(_params);

    var uri = Uri.http('felgo.com', '/mockapi-propertycross', params);

    http.get(uri).then((res) {
      data = json.decode(res.body);
      setState(() {
        _match_count = data["response"]["total_results"];
        for (var item in data["response"]["listings"]) {
          _items.add(item);
        }
        loadingPage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${_items.length} of ${_match_count.toString()} matches'),
          actions: <Widget>[
            Visibility(
                visible: loadingPage,
                child: new Center(
                  child: new CircularProgressIndicator(
                      backgroundColor: Colors.white),
                ))
          ],
        ),
        body: _buildList());
  }

  Widget _buildList() {
    var listings = new List<Widget>();
    for (var item in _items) listings.add(_buildRow(item));
    if (loadingPage) listings.add(Center(child: CircularProgressIndicator()));
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: listings,
      controller: _scrollController,
    );
  }

  Widget _buildRow(Map<String, dynamic> element) {
    return Column(children: <Widget>[
      ListTile(
          leading: Image.network(element["thumb_url"].toString()),
          title: Text(element["price_formatted"].toString()),
          subtitle: Text(element["title"].toString()),
          onTap: () {
            _pushDetailView(element);
          }),
      /*  onTap: () {
            setState(() {
              if (alreadySaved) {
                widget._favorites.remove(element);
              } else {
                widget._favorites.add(element);
              }
            });

          }),*/
      Divider(),
    ]);
  }

  void _pushDetailView(Map<String, dynamic> element) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailView(element)));
  }
}
