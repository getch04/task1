import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:task1/constants.dart';
import 'package:task1/controllers/app_controller.dart';
import 'package:task1/screens/otp_screen.dart';

Row orDivider() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      Expanded(
        child: Divider(height: 30, color: Colors.black),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'OR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      Expanded(
        child: Divider(height: 30, color: Colors.black),
      )
    ],
  );
}

Widget customButton(
    {VoidCallback? onperess, required String title, Color? bgrColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onperess,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(bgrColor ?? primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    ),
  );
}

Stack phoneNumberInputField(
    TextEditingController phoneController, AppController controller) {
  return Stack(
    children: [
      Positioned(
          left: 90,
          top: 10,
          child: Container(
            width: 2,
            height: 30,
            color: Colors.grey.shade400,
          )),
      IntlPhoneField(
        initialCountryCode: 'ET',
        flagsButtonMargin: const EdgeInsets.only(right: 10),
        showDropdownIcon: false,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
        controller: phoneController,
        initialValue: controller.countryDial.value,

        onCountryChanged: (country) {
          controller.countryDial.value = '+${country.dialCode}';
        },
        onChanged: (value) {
          controller.otpPin.value = value.toString();
        },

        disableLengthCheck: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          contentPadding: const EdgeInsets.all(5),
          hintText: 'Phone Number',
        ),

        flagsButtonPadding: const EdgeInsets.only(left: 10),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ],
  );
}

Padding socialButtons({
  Color? bgcolor,
  required String img,
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        icon: Image(
          image: AssetImage('assets/images/$img.png'),
          width: 25,
          height: 25,
        ),
        onPressed: () {},
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(
              bgcolor ?? const Color.fromARGB(255, 240, 245, 240)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              side: BorderSide(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
          ),
        ),
        label: RichText(
          // Controls visual overflow
          overflow: TextOverflow.clip,

          // Controls how the text should be aligned horizontally
          textAlign: TextAlign.end,

          // Control the text direction
          textDirection: TextDirection.rtl,

          // Whether the text should break at soft line breaks
          softWrap: true,

          // Maximum number of lines for the text to span
          maxLines: 1,

          // The number of font pixels for each logical pixel
          textScaleFactor: 1,
          text: TextSpan(
            text: 'Connect To ',
            style:
                TextStyle(color: bgcolor != null ? Colors.white : Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: text,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    ),
  );
}

//this is common custom snack bar 
void showSnackBarText(String text) {
  Get.snackbar('Message from dev-team', text,
      backgroundColor: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      titleText: const Text(
        'Message',
        style: TextStyle(color: Colors.white),
      ),
      messageText: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ));
}
