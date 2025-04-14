// signup_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pinput/pinput.dart';
import 'package:seba_app1/page/user_regi.dart';

class SignupScreen extends ConsumerStatefulWidget {
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
          if (context.mounted) {
            _showOTP(context);
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
    final pinController = TextEditingController();
    String validPin = '';
    int timeLeft = 120; // 2 minutes in seconds
    Timer? timer;

    // Generate random 4-digit PIN
    Random random = Random();
    validPin = List.generate(4, (_) => random.nextInt(10)).join();
    // Auto-fill the PIN
    pinController.text = validPin;

    // Timer function
    void startTimer() {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timeLeft > 0) {
          timeLeft--;
          // Force rebuild to update timer text
          (context as Element).markNeedsBuild();
        } else {
          timer.cancel();
        }
      });
    }

    // Format time as mm:ss
    String formatTime(int seconds) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    void showLoadingDialog() {
      Future.delayed(Duration(seconds: 2), () {
        registerUser();
      });
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
                Text("OTP is right and\n Registration under processing"),
              ],
            ),
          );
        },
      );
    }

    // Start timer when dialog shows
    startTimer();
    Future.delayed(Duration(seconds: 3), () {
      showLoadingDialog();
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
              height: 490.h,
              child: Padding(
                padding: EdgeInsets.only(top: 13.0.h, left: 17.w, right: 17.w),
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
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _numberController.text,
                          style: TextStyle(
                              color: Color(0xffD32F2F), fontSize: 18.sp),
                        ),
                        SizedBox(width: 15.w),
                        ImageIcon(AssetImage("images/editic.png"),
                            color: Color(0xff008000), size: 18.r),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Pinput(
                      length: 4,
                      controller: pinController,
                      validator: (value) {
                        return value == validPin ? null : "Invalid OTP";
                      },
                      onCompleted: (pin) {
                        if (pin == validPin) {
                          // Instead of closing the dialog, show the loading dialog after 3 seconds
                        }
                      },
                      errorBuilder: (errorText, pin) {
                        return Text(
                          errorText ?? "",
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        );
                      },
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      "Re-send code: ${formatTime(timeLeft)}",
                      style: TextStyle(color: Color(0xffD32F2F)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).then((_) {
      // Clean up timer when dialog is closed
      timer?.cancel();
    });
  }
}
