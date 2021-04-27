import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:ftpconnect/ftpConnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class audio_Selection extends StatefulWidget {
  final String reqid;

  // receive data from the FirstScreen as a parameter
  audio_Selection({Key key, @required this.reqid}) : super(key: key);
  @override
  _audioSelectionState createState() => _audioSelectionState(reqid);
}

class _audioSelectionState extends State<audio_Selection> {

  String  reqid;
  _audioSelectionState(this.reqid);
  File _csv,_zip,_txt;
  var csvPath,zipPath,txtPath;
  String timestamp,zipUploadPath,csvUploadPath,txtUploadPath;

  final ValueNotifier<String> _logNotifier = ValueNotifier('');


  Future _pickTXT() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);

    if(result != null) {
      File file = File(result.files.single.path);
      txtPath=file.path;
      String dir = (await getApplicationDocumentsDirectory()).path;
      timestamp=DateTime.now().millisecondsSinceEpoch.toString();
      String newPath = path.join(dir, 'txt_username'+timestamp+'.txt');
      File f = await File(file.path).copy(newPath);
      txtPath=f.path;

      txtUploadPath="https://cillyfox.com/genplatform/trainingaudio/txt_username"+timestamp+'.txt';


      _txt = File(file.path);

    } else {
      // User canceled the picker
    }

    print(txtPath);
    print("this was txt path");


  }


  Future _pickCSV() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if(result != null) {
      File file = File(result.files.single.path);
      csvPath=file.path;
      String dir = (await getApplicationDocumentsDirectory()).path;
      timestamp=DateTime.now().millisecondsSinceEpoch.toString();
      String newPath = path.join(dir, 'csv_username'+timestamp+'.csv');
      File f = await File(file.path).copy(newPath);
      csvPath=f.path;

      csvUploadPath="https://cillyfox.com/genplatform/trainingaudio/csv_username"+timestamp+'.csv';


      _csv = File(file.path);

    } else {
      // User canceled the picker
    }

    print(csvPath);
    print("this was csv path");


  }


  Future _pickZip() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['zip']);

    if(result != null) {
      File file = File(result.files.single.path);
      zipPath=file.path;
      String dir = (await getApplicationDocumentsDirectory()).path;
      timestamp=DateTime.now().millisecondsSinceEpoch.toString();
      String newPath = path.join(dir, 'zip_username'+timestamp+'.zip');
      File f = await File(file.path).copy(newPath);
      zipPath=f.path;

      zipUploadPath="https://cillyfox.com/genplatform/trainingaudio/zip_username"+timestamp+'.zip';


      _zip = File(file.path);

    } else {
      // User canceled the picker
    }

    print(zipPath);
    print("this was zip path");


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
        title: Text('Select Audio Files',style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body:
      SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              //Select Zip
              Container(
                padding: const EdgeInsets.only(bottom: 20,top: 20),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 30,right: 10),
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

                              child: Image.asset("assets/uielements/Folder icon.png",
                                height: 60.0,

                                fit: BoxFit.scaleDown,)

                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30,right: 10),
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
                                    child: Text("Select Zip",textAlign: TextAlign.center,),
                                  )),
                            ),
                            // ),
                            onPressed: () {
                              _pickZip();
                            },
                          ),
                        ),




                      ],
                    ),
                  ),
                ),
              ),
            //Select CSV
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 30,right: 10),
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

                            child: Image.asset("assets/uielements/Folder icon.png",
                              height: 60.0,

                              fit: BoxFit.scaleDown,)

                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30,right: 10),
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
                                    child: Text("Select CSV",textAlign: TextAlign.center,),
                                  )),
                            ),
                            // ),
                            onPressed: () {
                              _pickCSV();
                            },
                          ),
                        ),




                      ],
                    ),
                  ),
                ),
              ),
            //Select TXT
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 30,right: 10),
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

                            child: Image.asset("assets/uielements/Folder icon.png",
                              height: 60.0,

                              fit: BoxFit.scaleDown,)

                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30,right: 10),
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
                                    child: Text("Select TXT",textAlign: TextAlign.center,),
                                  )),
                            ),
                            // ),
                            onPressed: () {
                              _pickCSV();
                            },
                          ),
                        ),




                      ],
                    ),
                  ),
                ),
              ),

            /*  SizedBox(
                height: 200,
                child: Center(
                  child:_zip == null
                      ? Text('No zip selected.') : Text(zipUploadPath),
                ),
              ),
              SizedBox(
                height: 200,
                child: Center(
                  child: _csv == null
                      ? Text('No CSV selected.') : Text(csvUploadPath),
                ),
              ),
              SizedBox(
                height: 200,
                child: Center(
                  child: _txt == null
                      ? Text('No TXT selected.') : Text(txtUploadPath),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: (){
                      _pickZip();
                    }, child: Text('Select Zip'),
                  ),
                  RaisedButton(
                    onPressed: (){
                      _pickTXT();
                    },
                    child: Text('Select CSV'),),

                ],
              ),*/
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
                  if(zipPath!=null && csvPath!=null && txtPath!=null) {
                    pr.show();
                    /*  var result = await http.post('https://cillyfox.com/genplatform/inputapp.php',body: <String, String>{
                        "ziplink":imgUploadPath,
                        "csvlink":vidUploadPath,

                      });*/

                    var updatedb = await http.post('https://cillyfox.com/genplatform/updatevideodata.php',body: <String, String>{
                      "ziplink":zipUploadPath,
                      "csvlink":csvUploadPath,
                      "txtlink":txtUploadPath,
                      "reqbyapp":reqid,

                    });

                    // print(result.body);
                    print("RESULT^");
                    await _uploadStepByStep(zipPath,"trainingaudio");
                    await _uploadStepByStep(csvPath,"trainingscript");
                    await _uploadStepByStep(txtPath, "genscript");
                    pr.hide();
                  }
                },
              ),

              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  RaisedButton(
                    onPressed: (){
                      _pickTXT();
                    },
                    child: Text('Select TXT'),),
                  RaisedButton(onPressed: () async{
                    if(zipPath!=null && csvPath!=null && txtPath!=null) {
                      pr.show();
                      /*  var result = await http.post('https://cillyfox.com/genplatform/inputapp.php',body: <String, String>{
                        "ziplink":imgUploadPath,
                        "csvlink":vidUploadPath,

                      });*/

                      var updatedb = await http.post('https://cillyfox.com/genplatform/updatevideodata.php',body: <String, String>{
                        "ziplink":zipUploadPath,
                        "csvlink":csvUploadPath,
                        "txtlink":txtUploadPath,
                        "reqbyapp":reqid,

                      });

                      // print(result.body);
                      print("RESULT^");
                      await _uploadStepByStep(zipPath,"trainingaudio");
                      await _uploadStepByStep(csvPath,"trainingscript");
                      await _uploadStepByStep(txtPath, "genscript");
                      pr.hide();
                    }
                  },
                    child: Text('Upload'),),
                ],
              ),*/
              Text("Select & Upload files to generate link"),
            /*  Row(
                children: [
                  Container (
                    padding: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width*0.8,
                    child:
                    zipUploadPath!=null && csvUploadPath!=null && txtUploadPath!=null
                        ?new Column (
                      children: <Widget>[
                        new Text (" This data will be valid after uploading is completed:"),
                        new Text (" zip link: "+zipUploadPath),
                        new Text (" csv link"+csvUploadPath),
                        new Text("txt link"+txtUploadPath),

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
      print(zipPath);
      print('This was path---------');
      await _log('Uploading ...');
      await ftpConnect.uploadFile(fileToUpload);
      await _log('file uploaded sucessfully');
      await ftpConnect.disconnect();
      setState(() {
        zipUploadPath=zipUploadPath;
        csvUploadPath=csvUploadPath;
      });
    } catch (e) {
      await _log('Error: ${e.toString()}');
    }
  }

}
