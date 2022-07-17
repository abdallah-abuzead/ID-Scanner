import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id_scanner/screens/login.dart';

import '../app_data.dart';
import '../components/custom_widgets.dart';
import '../components/my_text.dart';
import '../components/rounded_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);
  static const String id = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset('images/id_scanner.png'),
                // child: Image.asset('images/empty_id.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    logoText(),
                    const SizedBox(height: 35),
                    smallText(
                      'Scan egyptian identity cards for egyptian people \n to read and extract the text',
                      fontSize: 13,
                    ),
                    const SizedBox(height: 70),
                    RoundedButton(
                      color: AppData.mainColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Let\'s Start', style: TextStyle(color: Colors.white, fontSize: 16)),
                          SizedBox(width: 50),
                          Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 22),
                        ],
                      ),
                      onPressed: () => Get.toNamed(Login.id),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Column(
            children: [
              MyText(
                text: '© 2022  مركز نظم المعلومات المتكامل',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppData.mainColor,
              ),
              const SizedBox(height: 30),
            ],
          ),
          // Divider(color: AppData.primaryFontColor, thickness: 4, indent: 130, endIndent: 130),
        ],
      ),
    );
  }
}
