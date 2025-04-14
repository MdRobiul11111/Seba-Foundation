import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'signup_screen.dart';
import 'home_page.dart'; // Assuming you have a HomePage

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginSignup> {
  final _formkey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool value = false;

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future _loginUser(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Checking data..."),
              ],
            ),
          );
        },
      );

      String phoneNumber = _userController.text.trim();
      String password = _passwordController.text.trim();
      String email = "$phoneNumber@gmail.com";

      try {
        // Check if user exists in the 'Users' collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .get();

        if (userDoc.exists) {
          // User exists in 'Users' collection, check password
          String storedPassword = userDoc['password'];

          if (password == storedPassword) {
            // Password matches, sign in with Firebase Auth
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);

            if (context.mounted) {
              Navigator.of(context).pop(); // Dismiss the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          } else {
            if (context.mounted) {
              Navigator.of(context).pop(); // Dismiss the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Incorrect password")),
              );
            }
          }
        } else {
          // User does not exist in 'Users' collection, check 'Useername' collection
          DocumentSnapshot usernameDoc = await FirebaseFirestore.instance
              .collection('Useername')
              .doc(email)
              .get();

          if (usernameDoc.exists) {
            // User exists in 'Useername' collection, perform your operation here
            // For example, you can create the user in the 'Users' collection
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(email)
                .set({
              'password': password, // Save the password
              // Add other user data here
            });

            // Sign in with Firebase Auth
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);

            if (context.mounted) {
              Navigator.of(context).pop(); // Dismiss the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          } else {
            // User does not exist in either collection
            if (context.mounted) {
              Navigator.of(context).pop(); // Dismiss the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("User does not exist")),
              );
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Dismiss the dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}")),
          );
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
              height: 520.h,
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
                      TextFormField(
                        controller: _userController,
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
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Color(0xffD32F2F),
                            side: BorderSide(color: Color(0xffD32F2F)),
                            checkColor: Colors.white,
                            value: value,
                            onChanged: (bool? newValue) {
                              setState(() {
                                value = newValue!;
                              });
                            },
                          ),
                          Text("Keep me logged in",
                              style: TextStyle(color: Color(0xffD32F2F)))
                        ],
                      ),
                      SizedBox(height: 15.h),
                      TextButton(
                        onPressed: () {
                          _loginUser(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xff008000)),
                            shape:
                                MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            )),
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 50.w))),
                        child: Text("Login",
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () {
                          _showForgetP(context);
                        },
                        child: Text(
                          "Forget Password",
                          style: TextStyle(
                              color: Color(0xffD32F2F),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xffD32F2F),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text("Don't have account yet?"),
                      SizedBox(height: 5.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        child: Text(
                          "Sign Up Now",
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

  void _showForgetP(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff008000),
                borderRadius: BorderRadius.circular(25.r),
              ),
              height: 300.h,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0.w),
                      child: Text(
                        "Forget Password",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.sp),
                      ),
                    ),
                  ),
                  Container(
                    height: 224.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(48.r),
                          bottomLeft: Radius.circular(25.r),
                          bottomRight: Radius.circular(25.r)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 57.h,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter your number",
                                helperStyle:
                                    TextStyle(color: Colors.grey.shade300),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.sp,
                                    ),
                                    borderRadius: BorderRadius.circular(15.r)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff008000),
                                      width: 1.sp,
                                    ),
                                    borderRadius: BorderRadius.circular(15.r)),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                            child: Divider(color: Color(0xffFF0000)),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showVerify(context);
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xff008000)),
                                    foregroundColor:
                                        MaterialStatePropertyAll(Colors.white),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.r)))),
                                child: Text("Send OTP"),
                              ),
                              SizedBox(width: 15.w),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white),
                                    foregroundColor: MaterialStatePropertyAll(
                                        Color(0xff008000)),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            side: BorderSide(
                                                color: Color(0xff008000),
                                                width: 1.sp))),
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 39.sp))),
                                child: Text("Cancel"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showVerify(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: 400.h,
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Text(
                          "Verify",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: Color(0xff008000)),
                        ),
                        Text(
                          "Verification code sent to your number",
                          style: TextStyle(color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "017*********",
                              style: TextStyle(
                                  color: Color(0xffD32F2F), fontSize: 18.sp),
                            ),
                            SizedBox(width: 15.w),
                            ImageIcon(AssetImage("images/editic.png"),
                                color: Color(0xff008000), size: 18.r),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                          height: 52.h,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Enter your OTP",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              contentPadding:
                                  EdgeInsets.only(top: 20.h, left: 20.w),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.sp,
                                  ),
                                  borderRadius: BorderRadius.circular(15.r)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff008000),
                                    width: 1.sp,
                                  ),
                                  borderRadius: BorderRadius.circular(15.r)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff008000)),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              )),
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 50.w))),
                          child: Text("Confirm"),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "Re-send code: 02:00",
                          style: TextStyle(
                              color: Color(0xffD32F2F), fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -43,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("images/otp_logo.png"),
                    radius: 55.r,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
