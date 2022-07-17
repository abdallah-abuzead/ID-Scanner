import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:id_scanner/components/validation/validation_error.dart';
import 'package:id_scanner/controllers/card_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../app_data.dart';
import '../components/custom_widgets.dart';
import '../components/input_filed_decoration.dart';
import '../components/my_text.dart';
import '../components/rounded_button.dart';
import '../components/validation/validator.dart';

class AddCard extends StatelessWidget {
  const AddCard({Key? key}) : super(key: key);
  static const String id = '/add_card';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('إنشاء ملف البطاقة', style: TextStyle(color: AppData.primaryFontColor)),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppData.primaryFontColor, size: 25),
                onPressed: () => Get.back(),
              ),
              actions: [
                Container(
                  alignment: Alignment.center,
                  child: MyText(
                    text: controller.camera ? 'الكاميرا' : 'الإستوديو',
                    color: AppData.secondaryFontColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 40,
                  child: FittedBox(
                    child: CupertinoSwitch(
                      value: controller.camera,
                      onChanged: (val) => controller.camera = val,
                      activeColor: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading,
              child: ListView(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 5),
                children: [
                  Text(
                    'أدخل بيانات البطاقة ',
                    style:
                        TextStyle(color: AppData.secondaryFontColor, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        inputLabel('اسم صاحب البطاقة'),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: controller.nameController,
                          decoration: kAddCardInputFieldDecoration,
                          keyboardType: TextInputType.text,
                          validator: (name) => Validator.nameValidator(name),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 20),
                        inputLabel('وجه البطاقة'),
                        const SizedBox(height: 5),
                        DottedBorder(
                          strokeWidth: 2,
                          dashPattern: const [6, 6],
                          color: AppData.placeholderColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            height: 150,
                            alignment: Alignment.center,
                            child: controller.frontImageName!.isEmpty
                                ? Icon(Icons.image, color: AppData.placeholderColor, size: 80)
                                : Image.file(controller.frontImageFile,
                                    fit: BoxFit.cover, height: 150),
                          ),
                        ),
                        ValidationError(
                            errorMessage: 'أدخل وجه البطاقة',
                            visible: controller.frontImageName!.isEmpty),
                        const SizedBox(height: 20),
                        RoundedButton(
                          color: Colors.white,
                          child: MyText(
                            text: 'اختر صورة',
                            textStyle: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 2,
                            ),
                          ),
                          hasBorder: true,
                          onPressed: () async => await controller.chooseCardImage(),
                        ),
                        const SizedBox(height: 20),
                        inputLabel('ظهر البطاقة'),
                        const SizedBox(height: 5),
                        DottedBorder(
                          strokeWidth: 2,
                          dashPattern: const [6, 6],
                          color: AppData.placeholderColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            height: 150,
                            alignment: Alignment.center,
                            child: controller.backImageName!.isEmpty
                                ? Icon(Icons.image, color: AppData.placeholderColor, size: 80)
                                : Image.file(controller.backImageFile,
                                    fit: BoxFit.cover, height: 150),
                          ),
                        ),
                        ValidationError(
                            errorMessage: 'أدخل ظهر البطاقة',
                            visible: controller.backImageName!.isEmpty),
                        const SizedBox(height: 20),
                        RoundedButton(
                          color: Colors.white,
                          child: MyText(
                            text: 'اختر صورة',
                            textStyle: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 2,
                            ),
                          ),
                          hasBorder: true,
                          onPressed: () async => await controller.chooseCardImage(isFront: false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  RoundedButton(
                    color: AppData.mainColor,
                    child: const MyText(text: 'إنشاء', color: Colors.white, fontSize: 18),
                    onPressed: () => controller.createCard(),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
