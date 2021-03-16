import 'package:flutter/material.dart';
import 'package:tst_expandable_bottom_menu/unicorndial_2.dart';
// import 'package:unicorndial/unicorndial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      // FloatingActionButton is a UnicornDialer
      floatingActionButton: UnicornDialer(
        parentButtonBackground: Colors.grey[700],
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.person),
        childButtons: _getProfileMenu(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

List<UnicornButton> _getProfileMenu() {
  List<UnicornButton> children = [
    UnicornButton(
      currentButton: FloatingActionButton(
        backgroundColor: Colors.grey[500],
        mini: true,
        child: Icon(Icons.account_balance),
        onPressed: () {},
      ),
    ),
    UnicornButton(
      currentButton: FloatingActionButton(
        backgroundColor: Colors.grey[500],
        mini: true,
        child: Icon(Icons.settings),
        onPressed: () {},
      ),
    ),
    // TODO: Make the UnicornButton take a UnicornDailer, so that we can expand the menu twice.
    // TODO: See images/Start.png and images/Result.png to see what the end result should look like
    //
    // UnicornButton(
    //   currentButton: UnicornDialer(
    //     parentButtonBackground: Colors.grey[700],
    //     orientation: UnicornOrientation.VERTICAL,
    //     parentButton: Icon(Icons.person),
    //     childButtons: _getProfileMenu(),
    //   ),
    // ),
  ];

  return children;
}
