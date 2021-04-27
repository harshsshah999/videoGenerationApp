import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class selectionPage extends StatefulWidget {
  final String reqid;

  // receive data from the FirstScreen as a parameter
  selectionPage({Key key, @required this.reqid}) : super(key: key);
  @override
  _selectionPageState createState() => _selectionPageState(reqid);
}

class _selectionPageState extends State<selectionPage> {

  String  reqid;
  _selectionPageState(this.reqid);
  File _image,_video;
  var imgPath,vidPath;
  String timestamp,vidUploadPath,imgUploadPath;
  VideoPlayerController _videoPlayerController;

  final picker = ImagePicker();
  final ValueNotifier<String> _logNotifier = ValueNotifier('');



  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imgPath=pickedFile.path;
    print(imgPath);
    print("This was old image path");
    timestamp=DateTime.now().millisecondsSinceEpoch.toString();
    String dir = (await getApplicationDocumentsDirectory()).path;
    String newPath = path.join(dir, 'image_username'+timestamp+'.jpg');
    File f = await File(pickedFile.path).copy(newPath);
    imgPath=f.path;
    imgUploadPath="https://cillyfox.com/genplatform/targetimage/image_username"+timestamp+'.jpg';

    print(imgPath);
    print('This was new image path');
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _pickVideo() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp4']);

    if(result != null) {
      File file = File(result.files.single.path);
      vidPath=file.path;
      String dir = (await getApplicationDocumentsDirectory()).path;
      timestamp=DateTime.now().millisecondsSinceEpoch.toString();
      String newPath = path.join(dir, 'video_username'+timestamp+'.mp4');
      File f = await File(file.path).copy(newPath);
      vidPath=f.path;

        vidUploadPath="https://cillyfox.com/genplatform/sourcevideo/video_username"+timestamp+'.mp4';


      _video = File(file.path);
      _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
        setState(() { });
        _videoPlayerController.pause();
      });
    } else {
      // User canceled the picker
    }

    print(vidPath);
    print("this was video path");
    /*PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
    pathh=pickedFile.path;
    print(pathh);
    print("this was video path");
    _video = File(pickedFile.path);
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
    });*/
    /* FilePickerResult result = await FilePicker.platform.pickFiles(allowedExtensions: ['mp4']);

    if(result != null) {
      File file = File(result.files.single.path);
      pathh=file.path;
      print("----------this was video path");
    } else {
      // User canceled the picker
    }*/

  }

  @override
  Widget build(BuildContext context) {

    final ProgressDialog pr = ProgressDialog(context,isDismissible: false);
    pr.style(
        message: 'Uploading files...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text('Select Photo & Video',style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
           //upload image section
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    width: 330,
                    height: 140,
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
                          image: AssetImage('assets/uielements/Card view for image upload.png'),
                          fit: BoxFit.fill),
                    ),
                    child: new Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        Center(
                          child:_image == null
                              ? ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset("assets/uielements/girlface.png",
                                height: 130.0,
                                width: 130.0,
                                fit: BoxFit.fill,)
                          ) : ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(_image,
                                height: 130.0,
                                width: 130.0,
                                fit: BoxFit.fill,)
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20,right: 10),
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
                                    child: Text("Select Image",textAlign: TextAlign.center,),
                                  )),
                            ),
                            // ),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        ),




                      ],
                    ),
                  ),
                ),
              ),
           //upload video section
              Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    width: 330,
                    height: 140,
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
                          image: AssetImage('assets/uielements/Card view for image upload.png'),
                          fit: BoxFit.fill),
                    ),
                    child: new Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        Center(
                          child:_video == null
                              ? ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset("assets/uielements/menface.png",
                                height: 130.0,
                                width: 130.0,
                                fit: BoxFit.fitWidth,)
                          )  : _videoPlayerController.value.initialized ? AspectRatio(
                            aspectRatio: 1/1,//_videoPlayerController.value.aspectRatio,
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
                            Container(
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
                                        child: Text("Select Video",textAlign: TextAlign.center,),
                                      )),
                                ),
                                // ),
                                onPressed: () {
                                  _pickVideo();
                                },
                              ),
                            ),
                            SizedBox(
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


                          ],
                        ),





                      ],
                    ),
                  ),
                ),
              ),

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
                        child: Text("Upload",textAlign: TextAlign.center,),
                      )),
                ),
                // ),
                onPressed: () async{
                  if(imgPath!=null && vidPath!=null) {
                    pr.show();
                    var result = await http.post('https://cillyfox.com/genplatform/inputapp.php',body: <String, String>{
                      "imglink":imgUploadPath,
                      "vidlink":vidUploadPath,

                    });

                    var updatedb = await http.post('https://cillyfox.com/genplatform/updatevideodata.php',body: <String, String>{
                      "imglink":imgUploadPath,
                      "vidlink":vidUploadPath,
                      "reqbyapp":reqid,

                    });

                    print(result.body);
                    print("RESULT^");
                    await _uploadStepByStep(imgPath,"targetimage");
                    await _uploadStepByStep(vidPath,"sourcevideo");
                    pr.hide();
                  }
                },
              ),

              Text("Select & Upload files to generate link")
    /*      Row(
              children: [
            Container (
            padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width*0.8,
          child:
          imgUploadPath!=null && vidUploadPath!=null
            ?new Column (
            children: <Widget>[
              new Text (" This data will be valid after uploading is completed:"),
              new Text (" Imagelink: "+imgUploadPath),
              new Text (" VideoLink "+vidUploadPath),
            ],
          ):Text("Select & Upload files to generate link"),
        ),
              ],
            ),*/
            ],


        ),
          /* child: _image == null
              ? Text('No image selected.')
              : Image.file(_image).*/

          ),
      ),

    );
  }

  Future<void> _log(String log) async {
    _logNotifier.value = log;
    await Future.delayed(Duration(seconds: 1));
  }



  Future<void> _uploadStepByStep(var filePath, var folder) async {
    FTPConnect ftpConnect =
    FTPConnect("ftp.cillyfox.com", user: 'harsh@cillyfox.com', pass: '#Hesoyam');

    try {
      await _log('Connecting to FTP ...');
      await ftpConnect.connect();
      ftpConnect.changeDirectory(folder);

      //File fileToUpload = await _fileMock(
      //  fileName: 'uploadStepByStep.txt', content: 'uploaded Step By Step');
      File fileToUpload = File(filePath);
      print(imgPath);
      print('This was path---------');
      await _log('Uploading ...');
      await ftpConnect.uploadFile(fileToUpload);
      await _log('file uploaded sucessfully');
      await ftpConnect.disconnect();
      setState(() {
        imgUploadPath=imgUploadPath;
        vidUploadPath=vidUploadPath;
      });
    } catch (e) {
      await _log('Error: ${e.toString()}');
    }
  }

}
