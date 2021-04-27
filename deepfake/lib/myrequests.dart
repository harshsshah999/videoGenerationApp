import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'requestdetails.dart';

class myRequests extends StatefulWidget {
  @override
  _myRequestsState createState() => _myRequestsState();
}

class _myRequestsState extends State<myRequests> {


  Future<List<MyReqData>> _getRequests() async {
    var data= await http.get("https://cillyfox.com/genplatform/fetchmyrequests.php");
    var jsonData=json.decode(data.body);
    List<MyReqData> allrequests=[];
  //  String vidlink,audiolink="";

     for(var u in jsonData["requests"]){
       //print("hyera");
       //print(u["reqid"].toString());
       //print(int.parse(u["reqid"]).runtimeType);
       MyReqData mrq=MyReqData(int.parse(u["reqid"]), u["Video"], u["Audio"]);
       allrequests.add(mrq);

     }
    return allrequests;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text('Your Requests',style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getRequests(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.data==null){
              return Container(
                child: Center(
                    child: Text("Loading...")
                )
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context,int rid){
                  return Container(

                        padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/uielements/Buttonregularsize.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),

                        child: ListTile(
                          onTap: () async{
                            //Navigator.pushNamed( context, '/audio_selection');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => requestDetails(videolink:snapshot.data[rid].videoLink,audiolink:snapshot.data[rid].audioLink,rid:snapshot.data[rid].userID.toString() ,),
                                ));
                          },
                          title:Text("Request ID: "+snapshot.data[rid].userID.toString() ,style: TextStyle(color: Colors.white)),
                        ),
                      );

                },
            );
        
          },
        ),
      ),
    );
  } 
}

class MyReqData{
  final int userID;
  final String videoLink;
  final String audioLink;
  MyReqData(this.userID,this.videoLink,this.audioLink);
}
