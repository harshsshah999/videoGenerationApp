import 'dart:math';
import 'package:flutter/material.dart';
import 'selectionpage.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => MyApp(),
      '/selectionpage': (context) => selectionPage(),
    },
  ));
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Motion Transfer"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  Navigator.pushNamed( context, '/selectionpage');
                },
                child: const Text('Select Files', style: TextStyle(fontSize: 20)),),
            ],
          ),
        ),
      ),
    );
  }


}



