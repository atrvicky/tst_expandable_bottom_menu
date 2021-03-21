
import 'package:flutter/material.dart';
import 'package:tst_expandable_bottom_menu/nestedFab.dart';
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
        backgroundColor: Colors.black,
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
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.grey[400],
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
      // FloatingActionButton is a NestedFab which is a list of UnicornDialers
      floatingActionButton: NestedFab(
        parentButtonBackground: Colors.grey[700],
        orientation: UnicornOrientation.HORIZONTAL,
        backgroundColor: Colors.black38,
        parentButtonIcon: Icon(Icons.person),
        children: _getProfileMenu(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

List<UnicornDialer> _getProfileMenu() {
  List<UnicornDialer> children = [
    UnicornDialer(
      parentButtonBackground: Colors.red,
      backgroundColor: Colors.transparent,
      parentButton: Icon(Icons.add),
      parentHeroTag: "addParentTag",
      childButtons: [
        FloatingActionButton(
          backgroundColor: Colors.grey[700],
          mini: true,
          heroTag: "bankTag",
          child: Icon(Icons.account_balance),
          onPressed: () {
            print("bank");
          },
        ),
        FloatingActionButton(
          backgroundColor: Colors.grey[700],
          mini: true,
          heroTag: "lockTag",
          child: Icon(Icons.lock),
          onPressed: () {
            print("lock");
          },
        ),
      ],
    ),
    UnicornDialer(
      parentButtonBackground: Colors.grey[700],
      backgroundColor: Colors.transparent,
      parentButton: Icon(Icons.settings),
      parentHeroTag: "settingParentTag",
      childButtons: [
        FloatingActionButton(
          backgroundColor: Colors.grey[700],
          mini: true,
          heroTag: "phoneTag",
          child: Icon(Icons.phone),
          onPressed: () {
            print("phone");
          },
        ),
      ],
    )
  ];
  return children;
}
