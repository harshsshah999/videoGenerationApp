import 'dart:developer';
import 'dart:math';
import 'selectionpage.dart';
import 'package:flutter/services.dart';
import 'audio_selection.dart';
import 'generate_request.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class generateRequest extends StatefulWidget {
  @override
  _generateRequestState createState() => _generateRequestState();
}




class _generateRequestState extends State<generateRequest> {
  final ValueNotifier<String> _logNotifier = ValueNotifier('');
  var userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: Colors.black
          ),
          backgroundColor: Colors.white,
          title: Text('Generate Request',style: TextStyle(color: Colors.black),),
          centerTitle: true,
         // elevation: 0,
        ),
        body: Container(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Center(
                      child:  userId==null
                          ?

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
                          child: Text("Generate",textAlign: TextAlign.center,),
                        )),
                  ),
                  // ),
                      onPressed: () async{
                        var updatedb = await http.post('https://cillyfox.com/genplatform/gen_req_app.php',body: <String, String>{
                          "userId":'9',

                        });
                        setState(() {
                          userId=updatedb.body.toString();
                        });
                      },
                ):Text(userId.toString()),
                    ),
                    Center(
                      child:   MaterialButton(
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
                                child: Text("Upload Video",textAlign: TextAlign.center,),
                              )),
                        ),
                        // ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => selectionPage(reqid: userId,),
                              ));
                        },
                      ),
                    ),
                    Center(
                        child:   MaterialButton(
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
                                  child: Text("Upload Audio",textAlign: TextAlign.center,),
                                )),
                          ),
                          // ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => audio_Selection(reqid: userId,),
                                ));
                          },
                        ),
                    ),

                  ],
                )),
              ),

    );
  }
  Future<void> _log(String log) async {
    _logNotifier.value = log;
    await Future.delayed(Duration(seconds: 1));
  }
  Future _generateReq() async{
    debugPrint("---------*------------------");

    var updatedb = await http.post('http://cillyfox.com/genplatform/gen_req_app.php',body: <String, String>{
      "userId":'12',

    });
    await _log("---------------------------");
    await _log(updatedb.toString());
  }

}
