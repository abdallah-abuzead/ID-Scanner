import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id_scanner/models/card_model.dart';
import 'package:id_scanner/screens/scan_image.dart';

class CardsList extends StatelessWidget {
  const CardsList({Key? key, required this.cards}) : super(key: key);
  final List<CardModel> cards;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: cards
          .map((card) => InkWell(
                onTap: () => Get.toNamed(ScanImage.id, arguments: card),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: FileImage(File(card.frontImagePath.toString())),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
