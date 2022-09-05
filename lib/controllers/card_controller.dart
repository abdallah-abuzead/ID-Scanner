import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:id_scanner/enums/event_enum.dart';
import 'package:id_scanner/models/card_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';

import '../components/show_snack_bar.dart';
import '../utils/db_helper.dart';
import '../utils/utils.dart';
import 'location_controller.dart';

class CardController extends GetxController {
  DBHelper dbHelper = DBHelper();

  // Loading Indicator
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool newValue) {
    _isLoading = newValue;
    update();
  }

  // Camera Indicator
  bool _camera = true;
  bool get camera => _camera;
  set camera(bool newValue) {
    _camera = newValue;
    update();
  }

  Event? event;
  final createFormKey = GlobalKey<FormState>();
  final editFormKey = GlobalKey<FormState>();
  Rx<String>? _frontImageName = ''.obs;
  String? get frontImageName => _frontImageName!.value;
  Rx<String>? _backImageName = ''.obs;
  String? get backImageName => _backImageName!.value;

  Rx<File>? _frontImageFile;
  File get frontImageFile => _frontImageFile!.value;
  Rx<File>? _backImageFile;
  File get backImageFile => _backImageFile!.value;
  LocationController location = LocationController();

  void resetAttributes() {
    event = null;
    _frontImageFile = _backImageFile = null;
    _frontImageName = _backImageName = ''.obs;
  }

  Future<List> getAllLocalCards() async {
    return await dbHelper.allCards();
  }

  Future<int> deleteLocalCard(CardModel card) async {
    _deleteFile(File(card.frontImagePath.toString()));
    _deleteFile(File(card.backImagePath.toString()));

    return await dbHelper.deleteCard(card.id.toString());
  }

  Future<void> _deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("File doesn't exist.");
    }
  }

  // Create New Card
  Future<void> createCard() async {
    var formData = createFormKey.currentState;
    if (formData!.validate() && _frontImageName!.isNotEmpty && _backImageName!.isNotEmpty) {
      formData.save();
      isLoading = true;
      String extStoragePath =
          await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DCIM + '/ID Scanner');
      var currentPosition = await location.getCurrentLocation();

      if (currentPosition != null) {
        CardModel card = CardModel();
        card.id = '123-${DateTime.now()}';
        card.event = event?.name;
        card.frontImagePath = '$extStoragePath/$frontImageName';
        card.backImagePath = '$extStoragePath/$backImageName';
        card.lat = currentPosition.latitude;
        card.long = currentPosition.longitude;
        card.userAddress = await location.getCurrentAddress();
        card.deviceSerialNumber = await getSerialNumber();
        await dbHelper.addCard(card);

        isLoading = false;

        Get.back();
        resetAttributes();
        print(card.toMap());
      } else {
        isLoading = false;
        showLocationAlertSnackBar('Open Location Service.');
      }
    }
  }

  // Create New Card
  Future<void> editCard(CardModel card) async {
    var formData = editFormKey.currentState;
    if (formData!.validate()) {
      formData.save();
      isLoading = true;
      String extStoragePath =
          await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DCIM + '/ID Scanner');
      var currentPosition = await location.getCurrentLocation();

      if (currentPosition != null) {
        if (event != null) card.event = event?.name;
        if (_frontImageName!.isNotEmpty) {
          _deleteFile(File(card.frontImagePath.toString()));
          card.frontImagePath = '$extStoragePath/$frontImageName';
        }
        if (_backImageName!.isNotEmpty) {
          _deleteFile(File(card.backImagePath.toString()));
          card.backImagePath = '$extStoragePath/$backImageName';
        }
        card.lat = currentPosition.latitude;
        card.long = currentPosition.longitude;
        card.userAddress = await location.getCurrentAddress();
        card.deviceSerialNumber = await getSerialNumber();
        await dbHelper.updateCard(card);

        isLoading = false;

        Get.back();
        resetAttributes();
      } else {
        isLoading = false;
        showLocationAlertSnackBar('Open Location Service.');
      }
    }
  }

  // picking card image
  Future chooseCardImage({bool isFront = true}) async {
    // final file = await Utils.pickMedia(isCamera: camera, cropImage: cropImage);
    final file = await Utils.pickMedia(isCamera: camera);
    if (file == null || file == File('') || file.path == '') return;

    // /storage/emulated/0/DCIM/ID Scanner/
    String fileExtension = extension(file.path);
    String dir = dirname(file.path);
    int now = DateTime.now().millisecondsSinceEpoch;
    String newName;

    if (isFront) {
      _frontImageName = Rx('front-$now$fileExtension');
      newName = join(dir, frontImageName);
      _frontImageFile = Rx(file);
    } else {
      _backImageName = Rx('back-$now$fileExtension');
      newName = join(dir, backImageName);
      _backImageFile = Rx(file);
    }

    File tempFile = await file.copy(newName);

    /// save image to gallery
    await GallerySaver.saveImage(tempFile.path, albumName: 'ID Scanner', toDcim: true);
    update();
  }

  Future<String?> getSerialNumber() async {
    try {
      // true if the permission is already granted
      bool isPermissionAllowed = await FlutterDeviceIdentifier.checkPermission();
      if (!isPermissionAllowed) {
        isPermissionAllowed = await FlutterDeviceIdentifier.requestPermission();
      }
      String? serial = await FlutterDeviceIdentifier.serialCode;
      return serial;
    } catch (e) {
      return null;
    }
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
}
