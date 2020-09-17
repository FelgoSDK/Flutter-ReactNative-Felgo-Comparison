import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation',
      home: MyHomePage(title: 'Page with Animations'),
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
  double opacityLevel = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              RaisedButton(
                child: Text(
                  'Click me',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () => setState(() {
                  opacityLevel = opacityLevel > 0 ? 0 : 1;
                }),
              ),
              AnimatedOpacity(
                  duration: Duration(seconds: 3),
                  opacity: opacityLevel,
                  child: Text('I slowly fade in')
              )
            ]
        ),
      ),
    );
  }
}
