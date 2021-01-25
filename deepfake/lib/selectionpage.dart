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
  @override
  _selectionPageState createState() => _selectionPageState();
}

class _selectionPageState extends State<selectionPage> {

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

      imgUploadPath="https://cillyfox.com/testflutter/targetimage/image_username"+timestamp+'.jpg';


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

        vidUploadPath="https://cillyfox.com/testflutter/sourcevideo/video_username"+timestamp+'.mp4';


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
        backgroundColor: Colors.black,
        title: Text('Select Photo & Video'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 200,
            child: Center(
              child:_image == null
                  ? Text('No image selected.') : Image.file(_image),
            ),
            ),
            SizedBox(
              height: 200,
              child: Center(
                child: _video == null
                    ? Text('No Video selected.') : _videoPlayerController.value.initialized ? AspectRatio(
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
              },),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                onPressed: (){
                  getImage();
                }, child: Text('Select Image'),
                ),
                RaisedButton(
                onPressed: (){
                  _pickVideo();
                },
                child: Text('Select Video'),),
                RaisedButton(onPressed: () async{
                  if(imgPath!=null && vidPath!=null) {
                    pr.show();
                    var result = await http.post('https://cillyfox.com/testflutter/inputapp.php',body: <String, String>{
                      "imglink":imgUploadPath,
                      "vidlink":vidUploadPath,
                    });
                    print(result.body);
                    print("RESULT^");
                    await _uploadStepByStep(imgPath);
                    await _uploadStepByStep(vidPath);
                    pr.hide();
                  }
                },
                  child: Text('Upload'),),
              ],
            ),

          Row(
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
          ),
          ],


      ),
        /* child: _image == null
            ? Text('No image selected.')
            : Image.file(_image).*/

        ),

    );
  }

  Future<void> _log(String log) async {
    _logNotifier.value = log;
    await Future.delayed(Duration(seconds: 1));
  }
  Future<void> _uploadStepByStep(var filePath) async {
    FTPConnect ftpConnect =
    FTPConnect("ftp.cillyfox.com", user: 'harsh@cillyfox.com', pass: '#Hesoyam');

    try {
      await _log('Connecting to FTP ...');
      await ftpConnect.connect();
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
