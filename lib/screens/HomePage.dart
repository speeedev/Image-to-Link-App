import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:alert/alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
var link;
final _secureStorage = new FlutterSecureStorage();
TextEditingController _linkController = TextEditingController(text: link);
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 40, 40),
      appBar: AppBar(
        title: const Text('Image Upload'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 24, 24, 24),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          const Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text("Click button with upload image.", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,)
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 16, 16, 16),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  File file = File(result!.files.single.path as String);
                  if (result != null) {
                    uploadImage(context, "name", file);
                    setState(() {
                      _linkController.text = link.toString();
                    });
                    inspect(_linkController.text);
                  } else {
                    print('No file selected');
                  }
                },
                child: const Text('Select Image', style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text("Link:", style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextFormField(
              controller: _linkController,
              decoration: const InputDecoration(
                hintText: "Resim seçin...",
                hintStyle: TextStyle(color: Color.fromARGB(255, 115, 115, 115), fontSize: 18),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: TextButton(
              child: Text("Kopyala", style: TextStyle(color: Colors.blue, fontSize: 20),),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _linkController.text));
                Alert(message: "Link kopyalandı.", shortDuration: true).show();
              },
            ),
          ),
        ],
      ),
    );
  }
  uploadImage(context, String title, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse("https://api.imgur.com/3/image"));
    request.fields["title"] = "Dummy";
    request.headers["Authorization"] = "CLIENT-ID 4d6f5c1baafa058";
    var picture = await http.MultipartFile.fromPath("image", file.path);
    request.files.add(picture);
    var response = await request.send().catchError((e) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Error"),
        content: Text("Error"),
        actions: <Widget>[
          TextButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
      showDialog(context: context, builder: (BuildContext context) => alertDialog);
    });
    var responseData = await response.stream.toBytes();
    var responseDataString = String.fromCharCodes(responseData);
    Map<String, dynamic> responseJson = json.decode(responseDataString);
    setState(() {
      link = responseJson["data"]["link"];
      _linkController.text = link.toString();
    });
    return responseJson["data"]["link"];
  }
}