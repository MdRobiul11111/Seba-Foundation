import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:seba_app1/otp_widgets/wrapper.dart';

class OtpPage extends StatefulWidget {
  final String vid;
  const OtpPage({super.key, required this.vid});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var code = '';
  signIn() async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: widget.vid, smsCode: code);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((Value) {
        Get.offAll(Wrapper());
      });
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
              Pinput(
                length: 6,
                onChanged: (value) {
                  setState(() {
                    code = value;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Text("Verify & Proceed"))
            ],
          )
        ],
      ),
    );
  }
}
