import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';


class requestDetails extends StatefulWidget {
  final String videolink,audiolink,rid;

  // receive data from the FirstScreen as a parameter
  requestDetails({Key key, this.videolink, this.audiolink,@required this.rid}) : super(key: key);
  @override
  _requestDetailsState createState() => _requestDetailsState(videolink,audiolink,rid);
}

class _requestDetailsState extends State<requestDetails> {

  final String videolink,audiolink,rid;
  VideoPlayerController _videoPlayerController;
  _requestDetailsState(this.videolink,this.audiolink,this.rid);
  @override
  void initState() {
    // TODO: implement initState
    initializeDownloader();
   // FlutterDownloader.registerCallback(downloadCallBack);
    super.initState();
    print(videolink);
    _videoPlayerController = VideoPlayerController.network(videolink)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.pause();
    });
  }

  downloadCallBack(id, status, progress){

  }

  void downloadAudioFile() async{

    final status= await Permission.storage.request();
    if(status.isGranted){
      final baseStorage= await getExternalStorageDirectory();

      final id=await FlutterDownloader.enqueue(

          url: audiolink,
          headers: {"auth": "test_for_sql_encoding"},
          savedDir: baseStorage.path,
          //fileName: '',
          showNotification: true,
          openFileFromNotification: true);

    }else{
      print("no permit");
    }
  }
  void downloadVideoFile() async{
    final status= await Permission.storage.request();
    if(status.isGranted){
      final baseStorage= await getExternalStorageDirectory();
      final id=await FlutterDownloader.enqueue(

          url: videolink,
          headers: {"auth": "test_for_sql_encoding"},
          savedDir: baseStorage.path,
          //fileName: '',
          showNotification: true,
          openFileFromNotification: true);

    }else{
      print("no permit");
    }
  }
  void initializeDownloader() async{
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();
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
        title: Text("Request "+rid,style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
       // mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 50,top:15),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(left: 10,right: 10, bottom:10,top:15),
                width: 330,

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
                      image: AssetImage('assets/uielements/longwhite.png'),
                      fit: BoxFit.fill),
                ),
                child: new Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Center(
                      child: videolink == ""
                          ?  ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset("assets/uielements/girlface.png",
                            height: 130.0,
                            width: 130.0,
                            fit: BoxFit.fitWidth,)
                      )  : _videoPlayerController.value.initialized ? AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child:
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: VideoPlayer(_videoPlayerController)

                        ),


                      )
                          : Container(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: FloatingActionButton(
                              child: Icon(Icons.play_arrow),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.value.isPlaying
                                      ? _videoPlayerController.pause()
                                      : _videoPlayerController.play();
                                  _videoPlayerController.setLooping(true);
                                });
                              },),
                          ),
                        ),


                      ],
                    ),





                  ],
                ),
              ),
            ),
          ),
          /* SizedBox(
          height: 300,
          child: Center(
            child: videolink == ""
                ? Text('No Video Available.') : _videoPlayerController.value.initialized ? AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            )
                : Container(),
          ),
        ),
          FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () {
              setState(() {
                _videoPlayerController.value.isPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
                _videoPlayerController.setLooping(true);
              });
            },),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              audiolink == null
                  ? Container() : Container(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: MaterialButton(
                  padding: EdgeInsets.all(10.0),
                  textColor: Colors.white,
                  //  splashColor: Colors.greenAccent,
                  elevation: 8.0,
                  child: Container(
                    width: 130,
                    height: 35,
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
                          image: AssetImage('assets/uielements/Button on card.png'),
                          fit: BoxFit.fill),
                    ),
                    child: new Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Download Audio",textAlign: TextAlign.center,),
                        )),
                  ),
                  // ),
                  onPressed: () {
                    downloadAudioFile();
                  },
                ),
              ),

              videolink == null
                  ? Container() : Container(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: MaterialButton(
                  padding: EdgeInsets.all(10.0),
                  textColor: Colors.white,
                  //  splashColor: Colors.greenAccent,
                  elevation: 8.0,
                  child: Container(
                    width: 130,
                    height: 35,
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
                          image: AssetImage('assets/uielements/Button on card.png'),
                          fit: BoxFit.fill),
                    ),
                    child: new Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Download Video",textAlign: TextAlign.center,),
                        )),
                  ),
                  // ),
                  onPressed: () {
                    downloadVideoFile();
                  },
                ),
              ),
            ],
          ),
    /*      RaisedButton(
            child: Text("Download Audio"),
            onPressed: () {

              setState(() {

              });
            },)*/
      ],
    ),
      ),
    );
  }
}
