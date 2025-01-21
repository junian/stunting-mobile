import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  //image picker
  File? _imageFile;
  Future<void> pickImage() async {
    final picker = await ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }
}
