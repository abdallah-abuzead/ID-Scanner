import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id_scanner/screens/add_card.dart';
import 'package:id_scanner/screens/dynamic_form.dart';
import 'package:id_scanner/screens/home.dart';
import 'package:id_scanner/screens/id_report.dart';
import 'package:id_scanner/screens/login.dart';
import 'package:id_scanner/screens/scan_image.dart';
import 'package:id_scanner/screens/sign_up.dart';
import 'package:id_scanner/screens/welcome.dart';

import 'app_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      initialRoute: Welcome.id,
      getPages: [
        GetPage(name: Welcome.id, page: () => const Welcome()),
        GetPage(name: Login.id, page: () => const Login()),
        GetPage(name: SignUp.id, page: () => const SignUp()),
        GetPage(name: Home.id, page: () => const Home()),
        GetPage(name: ScanImage.id, page: () => const ScanImage()),
        GetPage(name: AddCard.id, page: () => const AddCard()),
        GetPage(name: DynamicFrom.id, page: () => const DynamicFrom()),
        GetPage(name: IDReport.id, page: () => const IDReport()),
      ],
    );
  }
}

// The standard ID-1 or CR80 ID card size in pixels is 1012 pixels wide by 638 high at 300 dpi.
