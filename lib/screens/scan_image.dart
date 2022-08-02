import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:id_scanner/controllers/card_controller.dart';
import 'package:id_scanner/models/card_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'id_report.dart';

class ScanImage extends StatefulWidget {
  const ScanImage({Key? key}) : super(key: key);
  static const String id = '/scan_image';

  @override
  _ScanImageState createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  CardModel card = Get.arguments;
  // CardModel card = CardModel();
  Map cardData = {};
  bool error = false;
  @override
  initState() {
    super.initState();
  }

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
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(IDReport.id),
                  icon: const Icon(Icons.note, size: 25),
                )
              ],
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(card.frontImagePath.toString())),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // child: Image.file(File(card.frontImagePath.toString())),
                    // child: Image.asset('images/hatem.jpeg'),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: ElevatedButton(
                      child: const Text('إرسال', style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        error = false;
                        cardData = {};
                        controller.isLoading = true;
                        // cardData = await uploadImage();
                        cardData = await uploadImage2(card);
                        controller.isLoading = false;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  cardData.isEmpty
                      ? error
                          ? const Center(
                              child: Text(
                                'Error!. Try Again',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Container()
                      : Column(
                          children: [
                            identityField(
                              fName: 'الرقم القومى ',
                              fValue: cardData['nationalId'],
                              bgColor: Colors.black,
                            ),
                            identityField(fName: 'الإسم ', fValue: cardData['name']),
                            identityField(
                                fName: 'العنوان ',
                                fValue: cardData['address'],
                                bgColor: Colors.black),
                            identityField(fName: 'الوظيفة ', fValue: ''),
                            identityField(fName: 'النوع ', fValue: '', bgColor: Colors.black),
                            identityField(fName: 'الديانة ', fValue: ''),
                            identityField(
                                fName: 'الحالة الإجتماعية ', fValue: '', bgColor: Colors.black),
                            identityField(fName: 'تاريخ الإنتهاء ', fValue: ''),
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

  Widget identityField({
    required String fName,
    required String fValue,
    Color bgColor = Colors.white,
  }) {
    return Container(
      color: bgColor,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: Text(
          '$fName:',
          style: TextStyle(
            color: bgColor != Colors.white ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        title: Text(
          fValue,
          style: TextStyle(color: bgColor != Colors.white ? Colors.white : Colors.blue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  // Future scan(CardModel card) async {
  //   String frontImageName = card.frontImagePath!.split('/').last;
  //   String backImageName = card.backImagePath!.split('/').last;
  //   String base64Front = base64Encode(File(card.frontImagePath.toString()).readAsBytesSync());
  //   String base64Back = base64Encode(File(card.backImagePath.toString()).readAsBytesSync());
  //   Uri url = Uri.parse('http://192.168.1.112:8000/reader/api');
  //   var data = {'base64_front': base64Front,'base64_back': base64Back };
  //   http.Response response = await http.post(url, body: data);
  //   var responseBody = jsonDecode(response.body);
  // }

  // https://41.218.156.152/reader/api

  Future<Map> uploadImage() async {
    // Uri url = Uri.parse('http://192.168.1.130:8000/reader/api'); // my local device ip
    Uri url = Uri.parse('https://41.218.156.152/reader/api'); // published ip
    // Uri url = Uri.parse('http://10.18.121.93/reader/api'); // machine ip
    var request = http.MultipartRequest('POST', url);
    // request.fields['title'] = 'Upload Image';
    // request.headers['Authorization'] = '';
    var picture = http.MultipartFile.fromBytes(
      'image_url',
      (await rootBundle.load('images/omar.jpeg')).buffer.asUint8List(),
      filename: 'test.jpeg',
    );
    request.files.add(picture);

    try {
      var response = await request.send();
      print(response.statusCode);
      var responseDataAsBytes = await response.stream.toBytes();
      var responseData = json.decode(utf8.decode(responseDataAsBytes));
      print(responseData);
      return responseData;
      // var result = String.fromCharCodes(responseDataAsBytes);
    } catch (e) {
      print(e);
      error = true;
    }
    return {};
  }

  Future<Map> uploadImage2(CardModel card) async {
    String frontImageName = card.frontImagePath!.split('/').last;
    String backImageName = card.backImagePath!.split('/').last;
    Uri url = Uri.parse('https://41.218.156.152/reader/api');
    // Uri url = Uri.parse('http://192.168.1.130:8000/reader/api');

    var request = http.MultipartRequest('POST', url);
    //============================================================
    var picture1 = http.MultipartFile(
      'image_url',
      File(card.frontImagePath.toString()).readAsBytes().asStream(),
      File(card.frontImagePath.toString()).lengthSync(),
      filename: frontImageName,
    );
    //============================================================
    // var picture2 = http.MultipartFile.fromBytes(
    //   'image_url2',
    //   (await rootBundle.load(File(card.backImagePath.toString()).toString())).buffer.asUint8List(),
    //   filename: backImageName,
    // );
    //============================================================
    request.files.add(picture1);
    // request.files.add(picture2);
    //============================================================
    try {
      var response = await request.send();
      var responseDataAsBytes = await response.stream.toBytes();
      var responseData = json.decode(utf8.decode(responseDataAsBytes));
      print(responseData);
      return responseData;
    } catch (e) {
      print(e);
    }
    return {};
  }
}
