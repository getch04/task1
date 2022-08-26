// ignore_for_file: non_constant_identifier_names

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:task1/common/common_widgets.dart';
import 'package:task1/constants.dart';
import 'package:task1/controllers/app_controller.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 98, 18, 0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        SigninAndSignupTabs(context, title: 'Signin', index: 0),
                        SigninAndSignupTabs(context, title: 'Signup', index: 1),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                        ),
                        child: Text(
                          controller.activeTab.value == 0
                              ? 'Welcome Back!!'
                              : 'Welcome to App!!',
                          style: const TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        controller.activeTab.value == 0
                            ? 'Please login with your phone number'
                            : 'Please Signup with your phone number to get registered',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      phoneNumberInputField(
                          controller.phoneController, controller),
                      controller.isAuthenticating.value
                          ? const SizedBox(
                              height: 50,
                              width: 30,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : customButton(
                              onperess: () async {
                                // if (controller.activeTab.value == 0) {
                                if (controller.phoneController.text.isEmpty) {
                                  Logger().d(controller.phoneController.text);
                                  showSnackBarText(
                                      "Phone number is still empty!");
                                } else if (controller
                                        .phoneController.text.length <
                                    8) {
                                  showSnackBarText(
                                      'phone number should be 10 digit');
                                } else {
                                  Logger().d(controller.phoneController.text);
                                  if (kDebugMode) {
                                    print(await SmsAutoFill().getAppSignature);
                                  }
                                  controller.verifyPhone(
                                      controller.phoneController.text);
                                }
                                // } else if (controller.activeTab.value == 1) {

                                // }
                              },
                              title: 'Continue',
                            ),
                      orDivider(),
                      socialButtons(img: 'metamask', text: 'MetaMask'),
                      socialButtons(img: 'google', text: 'Google'),
                      socialButtons(
                          img: 'apple', text: 'Apple', bgcolor: Colors.black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: () {
                              controller.activeTab.value == 1
                                  ? controller.activeTab.value = 0
                                  : controller.activeTab.value = 1;
                            },
                            child: Text(
                              controller.activeTab.value == 0
                                  ? 'SignUp'
                                  : 'SignIn',
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded SigninAndSignupTabs(BuildContext context,
      {required String title, required int index}) {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 40),
        child: ElevatedButton(
          onPressed: () {
            controller.activeTab.value = index;
          },
          style: ElevatedButton.styleFrom(
            primary: controller.activeTab.value == index
                ? Color.fromARGB(255, 185, 250, 65)
                : Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            shape: const StadiumBorder(),
            // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
