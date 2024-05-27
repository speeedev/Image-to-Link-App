import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imgur/core/services/network_service.dart';

class HomePageViewModel extends ChangeNotifier {
  String? link;
  TextEditingController linkController = TextEditingController();
  final NetworkService _networkService = NetworkService();

  Future<bool> uploadImage(File file) async {
    var responseJson = await _networkService.uploadImage(file);

    if (responseJson != null) {
      link = responseJson["data"]["link"];
      linkController.text = link!;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
