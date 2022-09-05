import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id_scanner/controllers/card_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/card_data.dart';
import 'id_report.dart';

class ScanImage extends StatefulWidget {
  const ScanImage({Key? key}) : super(key: key);
  static const String id = '/scan_image';

  @override
  State<ScanImage> createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  CardData cardData = Get.arguments;
  int fieldId = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<CardController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('مسح البطاقة'),
              backgroundColor: Colors.black,
              actions: [IconButton(onPressed: () => Get.toNamed(IDReport.id), icon: const Icon(Icons.note, size: 25))],
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 150,
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: _getImage(cardData.croppedIdImage.toString())),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(child: _getImage(cardData.croppedPersonalImage.toString())),
                              // Expanded(child: Container(color: Colors.grey, margin: const EdgeInsets.all(2))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      // national_id
                      _identityField(fName: 'الرقم القومى ', fValue: cardData.nationalId),
                      // expiration_date
                      // _identityField(fName: 'تاريخ الإنتهاء ', fValue: cardData.expirationDate),
                      // name
                      _identityField(fName: 'الإسم ', fValue: cardData.name),
                      // address
                      _identityField(fName: 'العنوان ', fValue: cardData.address),
                      // job
                      // _identityField(fName: 'الوظيفة ', fValue: cardData.job),
                      // gender
                      _identityField(fName: 'النوع ', fValue: cardData.gender),
                      // religion
                      // _identityField(fName: 'الديانة ', fValue: cardData.religion),
                      // marital_status
                      // _identityField(fName: 'الحالة الإجتماعية ', fValue: cardData.maritalStatus),
                      // release_date
                      // _identityField(fName: 'تاريخ الإصدار', fValue: cardData.releaseDate),
                      // birthdate
                      _identityField(fName: 'تاريخ الميلاد ', fValue: cardData.birthdate),
                      // birth_place
                      _identityField(fName: 'محل الميلاد ', fValue: cardData.birthPlace),
                      // info
                      // _identityField(fName: 'بيانات أخرى ', fValue: cardData.info),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _identityField({required String fName, required String? fValue}) {
    fieldId++;
    bool isOdd = (fieldId % 2) == 1;
    return Container(
      color: isOdd ? Colors.black : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: Text('$fName:', style: TextStyle(color: isOdd ? Colors.white : Colors.black, fontSize: 18)),
        title: Text(fValue.toString(), style: TextStyle(color: isOdd ? Colors.white : Colors.blue)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _getImage(String encodedImage) {
    Uint8List decodedImage = base64Decode(encodedImage);
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: MemoryImage(decodedImage),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
