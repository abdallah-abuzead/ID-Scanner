import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:id_scanner/components/rounded_elevated_button.dart';
import 'package:id_scanner/controllers/card_controller.dart';
import 'package:id_scanner/controllers/internet_connection_controller.dart';
import 'package:id_scanner/models/card_model.dart';

import '../app_data.dart';
import '../components/my_text.dart';
import '../models/card_data.dart';
import '../screens/scan_image.dart';

class CardsList extends StatelessWidget {
  const CardsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InternetConnectionController>(
      builder: (internetController) {
        return GetBuilder<CardController>(builder: (cardController) {
          return FutureBuilder<List>(
            future: cardController.getAllLocalCards(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Loading...'),
                      SizedBox(width: 15),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              } else if (snapshot.data!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: 'لا توجد بطاقات',
                      color: AppData.secondaryFontColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 80),
                    const Icon(Icons.arrow_downward, size: 60)
                  ],
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: snapshot.data?.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, int i) {
                  CardModel card = CardModel.fromMap(snapshot.data![i]);
                  return Container(
                    // onTap: () => Get.toNamed(ScanImage.id, arguments: card),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: GridTile(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.shade400, width: 2),
                                  image: DecorationImage(
                                    image: FileImage(File(card.frontImagePath.toString())),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Expanded(
                              child: RoundedElevatedButton(
                                  text: 'إرسال',
                                  onPressed: () async {
                                    await internetController.checkConnection();
                                    if (internetController.online) {
                                      // Map<String, dynamic> responseData = (await uploadImage2(card)) as Map<String, dynamic>;
                                      // CardData cardData = CardData.fromMap(responseData);
                                      CardData cardData = CardData();
                                      Get.toNamed(ScanImage.id, arguments: cardData);
                                    }
                                  }),
                            ),
                            const SizedBox(height: 3),
                          ],
                        ),
                        footer: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 125),
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                          color: Colors.black.withOpacity(0.5),
                          child: Text(
                            '${card.id}',
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
      },
    );
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
