import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id_scanner/models/card_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';

import '../utils/utils.dart';

class CardController extends GetxController {
  List<CardModel> cards = [];

  //Loading Indicator
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool newValue) {
    _isLoading = newValue;
    update();
  }

  //Camera Indicator
  bool _camera = true;
  bool get camera => _camera;
  set camera(bool newValue) {
    _camera = newValue;
    update();
  }

  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rx<String>? _frontImageName = ''.obs;
  String? get frontImageName => _frontImageName!.value;
  Rx<String>? _backImageName = ''.obs;
  String? get backImageName => _backImageName!.value;

  Rx<File>? _frontImageFile;
  File get frontImageFile => _frontImageFile!.value;
  Rx<File>? _backImageFile;
  File get backImageFile => _backImageFile!.value;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void resetAttributes() {
    nameController.clear();
    _frontImageFile = _backImageFile = null;
    _frontImageName = _backImageName = ''.obs;
  }

  Future<File?> cropImage(File imageFile) async {
    return await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      compressQuality: 99,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: androidUiSettingsLocked(),
      cropStyle: CropStyle.rectangle,
    );
  }

  AndroidUiSettings androidUiSettingsLocked() {
    return const AndroidUiSettings(
      toolbarTitle: 'Crop Image',
      toolbarColor: Colors.red,
      toolbarWidgetColor: Colors.white,
      hideBottomControls: false,
      lockAspectRatio: false,
    );
  }

  // picking card image
  Future chooseCardImage({bool isFront = true}) async {
    // final file = await Utils.pickMedia(isCamera: camera, cropImage: cropImage);
    final file = await Utils.pickMedia(isCamera: camera);
    if (file == null || file == File('') || file.path == '') return;

    if (isFront) {
      _frontImageFile = Rx(file);
      _frontImageName = Rx('${DateTime.now().millisecondsSinceEpoch}-${basename(file.path)}');
    } else {
      _backImageFile = Rx(file);
      _backImageName = Rx('${DateTime.now().millisecondsSinceEpoch}-${basename(file.path)}');
    }

    /// save image to gallery
    // if (camera) {
    //   await GallerySaver.saveImage(file.path, albumName: 'ID Scanner');
    // }
    update();
  }

  // Create New Card

  Future<void> createCard() async {
    var formData = formKey.currentState;
    if (formData!.validate() && _frontImageName!.isNotEmpty && _backImageName!.isNotEmpty) {
      isLoading = true;

      CardModel card = CardModel();
      card.title = nameController.text;
      card.frontImagePath = frontImageFile.path;
      card.backImagePath = backImageFile.path;
      cards.add(card);
      await Future.delayed(const Duration(seconds: 1));

      isLoading = false;
      Get.back();
      resetAttributes();
    }
  }
}
