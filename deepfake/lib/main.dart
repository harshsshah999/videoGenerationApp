import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'selectionpage.dart';
import 'package:flutter/services.dart';
import 'audio_selection.dart';
import 'generate_request.dart';
import 'myrequests.dart';
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
     // '/selectionpage': (context) => (text:"s",),
     // '/audio_selection': (context)=> audio_Selection(),
      '/generate_request': (context)=>generateRequest(),
      '/my_request':(context)=>myRequests(),
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
        backgroundColor: Colors.white,
        title: Text("Motion Transfer", style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.all(10.0),
                textColor: Colors.white,
              //  splashColor: Colors.greenAccent,
                elevation: 8.0,
                child: Container(
                  width: 280,
                  height: 55,
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                        offset: const Offset(
                          0.0,
                          7.0,
                        ),
                        color: Colors.grey,
                        blurRadius: 20.0,
                      ),],
                    image: DecorationImage(
                        image: AssetImage('assets/uielements/Buttonregularsize.png'),
                        fit: BoxFit.fill),
                  ),
                  child: new Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Generate Request",textAlign: TextAlign.center,),
                  )),
                ),
                // ),
                onPressed: () {
                  Navigator.pushNamed( context, '/generate_request');
                },
              ),
              MaterialButton(
                padding: EdgeInsets.all(20.0),
                textColor: Colors.white,
                //  splashColor: Colors.greenAccent,
                elevation: 8.0,
                child: Container(
                  width: 280,
                  height: 55,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      offset: const Offset(
                        0.0,
                        7.0,
                      ),
                      color: Colors.grey,
                      blurRadius: 20.0,
                    ),],
                    image: DecorationImage(
                        image: AssetImage('assets/uielements/Buttonregularsize.png'),
                        fit: BoxFit.fill),
                  ),
                  child: new Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("My List",textAlign: TextAlign.center,),
                      )),
                ),
                // ),
                onPressed: () {
                  Navigator.pushNamed( context, '/my_request');
                },
              ),

            ],
          ),
        ),
      ),
    );
  }


}



