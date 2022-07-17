import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id_scanner/app_data.dart';
import 'package:id_scanner/controllers/card_controller.dart';
import 'package:id_scanner/screens/add_card.dart';
import 'package:id_scanner/screens/dynamic_form.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/my_text.dart';
import '../widgets/cards_list.dart';

class Home extends StatefulWidget {
  static const String id = '/home';
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<File> imageFiles = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('البطاقات الغير مرسلة'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.format_align_center,
                  size: 25,
                ),
                onPressed: () => Get.toNamed(DynamicFrom.id),
              )
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading,
            child: controller.cards.isEmpty
                ? Column(
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
                  )
                : CardsList(cards: controller.cards),
          ),
          floatingActionButton: SizedBox(
            width: 60,
            height: 60,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () => Get.toNamed(AddCard.id),
                child: const Icon(Icons.add, size: 35, color: Colors.red),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
