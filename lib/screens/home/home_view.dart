import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:imgur/core/utils/alert.dart';
import 'package:imgur/screens/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageViewModel(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        appBar: AppBar(
          title: const Text('Image Upload'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 24, 24, 24),
          elevation: 0,
        ),
        body: Consumer<HomePageViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      "Click button with upload image.",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 16, 16, 16),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          File file = File(result.files.single.path as String);
                          bool success = await viewModel.uploadImage(file);
                          if (!success) {
                            Alert.showErrorDialog(
                                context, "Image could not be loaded..");
                          }
                        } else {
                          print('No file selected');
                        }
                      },
                      child: const Text(
                        'Select Image',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text("Link:",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    controller: viewModel.linkController,
                    decoration: const InputDecoration(
                      hintText: "Select Image...",
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 115, 115, 115),
                          fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: TextButton(
                    child: const Text(
                      "Kopyala",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: viewModel.linkController.text));
                      Alert.showSuccessDialog(context, "Link copied.");
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
