import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seba_app1/otp_widgets/Otp.dart';

class phoneHome extends StatefulWidget {
  const phoneHome({super.key});

  @override
  State<phoneHome> createState() => _phoneHomeState();
}

class _phoneHomeState extends State<phoneHome> {
  TextEditingController phonenumber = TextEditingController();

  sendcode() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+88' + phonenumber.text,
          verificationCompleted: (PhoneAuthCredential creadential) {},
          verificationFailed: (FirebaseException e) {
            Get.snackbar('Error Occured', e.code);
          },
          codeSent: (String vid, int? token) {
            Get.to(
              OtpPage(
                vid: vid,
              ),
            );
          },
          codeAutoRetrievalTimeout: (vid) {});
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error Occured', e.code);
    } catch (e) {
      Get.snackbar('Error Occured', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              TextField(
                controller: phonenumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefix: Text("+88 "), labelText: 'Enter Phone Number'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    sendcode();
                  },
                  child: Text("Recive OTP"))
            ],
          )
        ],
      ),
    );
  }
}
