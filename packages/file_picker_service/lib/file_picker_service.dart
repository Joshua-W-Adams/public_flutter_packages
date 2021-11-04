library file_picker_service;

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  ImagePicker _imagePicker = ImagePicker();

  /// Returns a [File] object pointing to the image that was picked.
  Future<File?> pickImage({
    required ImageSource source,
    int imageQuality = 100,
    double? maxHeight,
    double? maxWidth,
  }) async {
    PickedFile? pickedFile = await _imagePicker.getImage(
      source: source,
      imageQuality: imageQuality,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  /// Returns a [File] object pointing to the video that was picked.
  Future<File?> pickVideo({
    required ImageSource source,
    Duration maxDuration = const Duration(
      seconds: 30,
    ),
  }) async {
    PickedFile? pickedFile = await _imagePicker.getVideo(
      source: source,
      maxDuration: maxDuration,
    );
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }
}
