import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:task1/common/common_widgets.dart';
import 'package:task1/constants.dart';
import 'package:task1/controllers/app_controller.dart';
import 'package:task1/controllers/otp_controller.dart';
import 'package:task1/screens/resend_otp_screen.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    _listenSmsCode;
  }

  _listenSmsCode() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(30.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 20.w,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Wellcome Back!!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'A five digit code has been sent to ${appController.countryDial.value + appController.phoneController.text}',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              PinFieldAutoFill(
                textInputAction: TextInputAction.done,
                controller: appController.otpEditingController,
                codeLength: 6,
                currentCode: appController.messageOtpCode.value,
                onCodeSubmitted: (code) {
                  Logger().d(code);
                },
                onCodeChanged: (code) {
                  Logger().d(code);
                  appController.countdownController.pause();
                  if (code!.length < 6) {
                    appController.isDoneBtnActive.value = false;
                    Logger().d(code);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),

              !appController.isDoneBtnActive.value
                  ? customButton(title: 'Resend OTP', bgrColor: Colors.grey)
                  : customButton(
                      onperess: () => {
                            if (appController.otpPin.value.length > 5)
                              {appController.verifyOTP()}
                            else
                              {showSnackBarText("Enter OTP correctly!")}
                          },
                      title: 'Done'),
              const Text(
                'didn\'t you recieve any code?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => ResendOtpScreen());
                },
                child: const Text(
                  'Re-Send Code',
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
              )
              // Countdown(
              //   controller: controller.countdownController,
              //   seconds: 15,
              //   interval: const Duration(milliseconds: 1000),
              //   build: (context, currentRemainingTime) {
              //     if (currentRemainingTime == 0.0) {
              //       return GestureDetector(
              //         onTap: () {
              //           // write logic here to resend OTP
              //         },
              //         child: Container(
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.only(
              //               left: 14, right: 14, top: 14, bottom: 14),
              //           decoration: BoxDecoration(
              //               borderRadius: const BorderRadius.all(
              //                 Radius.circular(10),
              //               ),
              //               border: Border.all(color: Colors.blue, width: 1),
              //               color: Colors.blue),
              //           width: context.width,
              //           child: const Text(
              //             "Resend OTP",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white),
              //           ),
              //         ),
              //       );
              //     } else {
              //       return Container(
              //         alignment: Alignment.center,
              //         padding: const EdgeInsets.only(
              //             left: 14, right: 14, top: 14, bottom: 14),
              //         decoration: BoxDecoration(
              //           borderRadius: const BorderRadius.all(
              //             Radius.circular(10),
              //           ),
              //           border: Border.all(color: Colors.blue, width: 1),
              //         ),
              //         width: context.width,
              //         child: Text(
              //             "Wait |${currentRemainingTime.toString().length == 4 ? " ${currentRemainingTime.toString().substring(0, 2)}" : " ${currentRemainingTime.toString().substring(0, 1)}"}",
              //             style: const TextStyle(fontSize: 16)),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
