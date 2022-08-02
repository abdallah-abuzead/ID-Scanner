import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:get/get.dart';
import 'package:id_scanner/enums/event_enum.dart';
import 'package:id_scanner/models/card_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';

import '../utils/utils.dart';
import 'location_controller.dart';

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

  final TextEditingController eventController = TextEditingController();
  Event? event;
  final formKey = GlobalKey<FormState>();
  Rx<String>? _frontImageName = ''.obs;
  String? get frontImageName => _frontImageName!.value;
  Rx<String>? _backImageName = ''.obs;
  String? get backImageName => _backImageName!.value;

  Rx<File>? _frontImageFile;
  File get frontImageFile => _frontImageFile!.value;
  Rx<File>? _backImageFile;
  File get backImageFile => _backImageFile!.value;
  LocationController location = LocationController();

  @override
  void dispose() {
    eventController.dispose();
    super.dispose();
  }

  void resetAttributes() {
    eventController.clear();
    _frontImageFile = _backImageFile = null;
    _frontImageName = _backImageName = ''.obs;
  }

  // Create New Card
  Future<void> createCard() async {
    var formData = formKey.currentState;
    if (formData!.validate() && _frontImageName!.isNotEmpty && _backImageName!.isNotEmpty) {
      formData.save();
      isLoading = true;
      var currentPosition = await location.getCurrentLocation();
      if (currentPosition != null) {
        CardModel card = CardModel();
        card.id = '123-569742136210';
        card.event = event?.name;
        card.frontImagePath = frontImageFile.path;
        card.backImagePath = backImageFile.path;
        card.lat = currentPosition.latitude;
        card.long = currentPosition.longitude;
        card.userAddress = await location.getCurrentAddress();
        card.deviceSerialNumber = await getSerialNumber();
        cards.add(card);
        await Future.delayed(const Duration(seconds: 1));

        isLoading = false;

        Get.back();
        resetAttributes();
        print(card.toMap());
      } else {
        isLoading = false;
        showSnackBarAlert('Open Location Service.');
      }
    }
  }

  Future<String?> getSerialNumber() async {
    // true if the permission is already granted
    // bool isPermissionAllowed = await FlutterDeviceIdentifier.checkPermission();
    // print('isPermissionAllowed:  $isPermissionAllowed');
    //
    // if (!isPermissionAllowed) {
    //   isPermissionAllowed = await FlutterDeviceIdentifier.requestPermission();
    //   if (!isPermissionAllowed) {
    //     print('return null;');
    //   }
    // }
    // print('isPermissionAllowed:  $isPermissionAllowed');
    String? serial = await FlutterDeviceIdentifier.serialCode;
    return serial;
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
    //   await GallerySaver.saveImage(file.path, albumName: 'ID Scanner');
    update();
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

  SnackbarController showSnackBarAlert(String errorMessage) {
    return Get.snackbar(
      'Alert',
      errorMessage,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.shade400,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      icon: const Icon(Icons.gps_fixed, color: Colors.blue, size: 35),
      shouldIconPulse: false,
      padding: const EdgeInsets.all(20),
    );
  }
}
