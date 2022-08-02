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
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: GridTile(
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
                ),
              ))
          .toList(),
    );
  }
}

// footer: Container(
//   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//   color: Colors.black.withOpacity(0.4),
//   child: Text(
//     '${card.name}',
//     style: const TextStyle(color: Colors.white),
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//     textAlign: TextAlign.center,
//   ),
// ),
