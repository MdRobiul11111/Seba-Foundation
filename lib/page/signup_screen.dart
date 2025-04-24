// signup_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pinput/pinput.dart';
import 'package:seba_app1/application/auth/sms/sms_provider.dart';
import 'package:seba_app1/page/user_regi.dart';

class SignupScreen extends StatefulHookConsumerWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscure1 = true;
  String validPin = "1234";

  final TextEditingController userController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
// Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to store user data and create authentication
  Future<void> registerUser() async {
    try {
      // Create authentication user
      String email = "${_numberController.text}@gmail.com";
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );

      // Store user data in Firestore
      await _firestore.collection('Users').doc(email).set({
        'username': userController.text,
        'phoneNumber': _numberController.text,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'password': _passwordController.text,
      });
      await _firestore
          .collection('Useername')
          .doc("${userController.text}@gmail.com")
          .set({
        'username': userController.text,
        'phoneNumber': _numberController.text,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'password': _passwordController.text,
      });
      // Close all dialogs
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Color(0xff008000),
        ),
      );

      // Navigate to UserRegi page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserRegi()),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    try {
      // Check in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      // Check in Authentication
      final email = '$phoneNumber@gmail.com';
      final authMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      return userDoc.docs.isNotEmpty || authMethods.isNotEmpty;
    } catch (e) {
      Logger().e('Error checking user existence: $e');
      return false;
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                color: Color(0xff008000),
              ),
              SizedBox(width: 20.w),
              Text("Checking data..."),
            ],
          ),
        );
      },
    );
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      // Check in Firestore if username exists
      final usernameDoc = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: username)
          .get();

      return usernameDoc.docs.isNotEmpty;
    } catch (e) {
      Logger().e('Error checking username existence: $e');
      return false;
    }
  }

  Future<void> validateAndProceed(BuildContext context) async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final phoneNumber = _numberController.text;

    // Show loading dialog
    showLoadingDialog(context);

    // Check if user exists
    final userExists = await checkUserExists(phoneNumber);

    // Dismiss loading dialog
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (userExists) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists with this phone number'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      String username = userController.text.trim();
      bool usernameExists = await checkUsernameExists(username);
      if (usernameExists) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Username already exists')),
          );
        }
        return;
      } else {
        // Check password length
        String password = _passwordController.text.trim();
        if (password.length < 6) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Password must be at least 6 characters long')),
            );
          }
          return;
        } else {
          final smsSent =
              await ref.read(smsStateProvider.notifier).sendOtp(phoneNumber);
          if (context.mounted) {
            if (smsSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Otp Sent to your Phone!'),
                  backgroundColor: Color(0xff008000),
                ),
              );
              _showOTP(context);
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("images/bgn1.png"),
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              width: double.infinity,
              height: 580.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: Offset(2, 3))
                ],
              ),
              child: Form(
                key: _formkey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff008000)),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: userController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          hintText: "User name",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff008000),
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        controller: _numberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff008000),
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length != 11) {
                            return 'Phone number must be 11 digits';
                          }
                          if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff008000),
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        controller: _repasswordController,
                        obscureText: _isObscure1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          hintText: "Retype Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff008000),
                              ),
                              borderRadius: BorderRadius.circular(15.r)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure1 = !_isObscure1;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please retype password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25.h),
                      TextButton(
                        onPressed: () => validateAndProceed(context),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Color(0xff008000)),
                            shape:
                                WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            )),
                            padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 50.w))),
                        child: Text("Sign Up",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.sp)),
                      ),
                      SizedBox(height: 15.h),
                      Text("Have an account?"),
                      SizedBox(height: 5.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(
                              color: Color(0xff008000),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff008000)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showOTP(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final state = ref.watch(smsStateProvider);
          return HookBuilder(builder: (context) {
            final pinController = useTextEditingController();
            final timeLeft = useState(120); // 2 minutes in seconds
            final showTimer = useState(true);
            final showLoading = useState(false);
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r)),
                    height: 490.h,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 13.0.h, left: 17.w, right: 17.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/otp_logo.png",
                            width: 80.w,
                            height: 80.w,
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            "OTP Verification",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff008000)),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Verification code sent to your number",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.black),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            _numberController.text,
                            style: TextStyle(
                                color: Color(0xffD32F2F), fontSize: 18.sp),
                          ),
                          SizedBox(height: 30.h),
                          Pinput(
                            length: 4,
                            controller: pinController,
                            validator: (value) {
                              return value == state.otp
                                  ? null
                                  : state.isExpired
                                      ? 'Otp Expired'
                                      : "Invalid OTP";
                            },
                            onCompleted: (pin) async {
                              final validation = await ref
                                  .read(smsStateProvider.notifier)
                                  .verifyOtp(pinController.text);
                              if (validation) {
                                showLoading.value = true;
                                await registerUser();
                                showLoading.value = false;
                              }
                            },
                            errorBuilder: (errorText, pin) {
                              return Text(
                                errorText ?? "",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.sp),
                              );
                            },
                          ),
                          SizedBox(height: 40.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Re-send code: ",
                                style: TextStyle(color: Color(0xffD32F2F)),
                              ),
                              if (showTimer.value)
                                TimerCountdown(
                                  enableDescriptions: false,
                                  endTime: state.createdAt
                                      .add(Duration(seconds: 120)),
                                  onEnd: () {
                                    showTimer.value = false;
                                  },
                                  spacerWidth: 1.w,
                                  onTick: (remainingTime) {
                                    timeLeft.value = remainingTime.inSeconds;
                                  },
                                  format: CountDownTimerFormat.minutesSeconds,
                                  timeTextStyle:
                                      TextStyle(color: Color(0xffD32F2F)),
                                ),
                              if (!showTimer.value)
                                InkWell(
                                  onTap: () async {
                                    final sent = await ref
                                        .read(smsStateProvider.notifier)
                                        .sendOtp(_numberController.text);
                                    if (sent) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Otp Sent!'),
                                          backgroundColor: Color(0xff008000),
                                        ),
                                      );
                                      showTimer.value = true;
                                    }
                                  },
                                  child: Text(
                                    'Resend',
                                    style: TextStyle(
                                      color: Color(0xff008000),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showLoading.value)
                    Center(
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        color: Colors.black54,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff008000),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          });
        });
    //     .then((_) {
    //   // Clean up timer when dialog is closed
    //   timer?.cancel();
    // });
  }
}
