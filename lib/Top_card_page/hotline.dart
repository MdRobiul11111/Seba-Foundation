import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../page/login_signup.dart';

class Hotline extends StatefulWidget {
  const Hotline({super.key});

  @override
  State<Hotline> createState() => _HotlineState();
}

class _HotlineState extends State<Hotline> {
  // Check if user is logged in and navigate to login page if not
  void _checkLoginAndNavigate(Function() navigateFunction) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      // User is logged in, proceed with navigation
      navigateFunction();
    } else {
      // User is not logged in, redirect to login page
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginSignup()));
    }
  }

  Future<void> _openLink(BuildContext context) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Links")
        .doc("sliders")
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      String? link = snapshot["link"];
      if (link != null && link.isNotEmpty) {
        final Uri url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not launch the link")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No link available")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No link found in database")),
      );
    }
  }

  void _checkLoginAndNaviga1te(BuildContext context) async {
    try {
      // Fetch the document from Firestore
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Links")
          .doc("aboutUs")
          .get();

      // Check if the document exists and contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Safely extract the link using null-aware operator
        final String? link = snapshot.get("link");

        // Validate the link
        if (link != null && link.isNotEmpty) {
          final Uri? url = Uri.tryParse(link);

          if (url != null) {
            // Attempt to launch the URL
            final bool canLaunch = await canLaunchUrl(url);

            if (canLaunch) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              // Show error if URL cannot be launched
              _showErrorSnackBar(context, "Could not launch the link");
            }
          } else {
            _showErrorSnackBar(context, "Invalid URL format");
          }
        } else {
          _showErrorSnackBar(context, "No link available");
        }
      } else {
        _showErrorSnackBar(context, "No link found in database");
      }
    } catch (e) {
      // Handle any unexpected errors
      _showErrorSnackBar(context, "An error occurred while fetching the link");
    }
  }

// Helper method to show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static const platform = MethodChannel('com.yourapp/link_opener');

  static Future<void> _checkLoginAndNavigat8e(
      BuildContext context, String documents) async {
    try {
      // Fetch the document from Firestore
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Links")
          .doc(documents)
          .get();

      // Check if the document exists and contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Safely extract the link using null-aware operator
        final String? link = snapshot.get("link");

        // Validate the link
        if (link != null && link.isNotEmpty) {
          try {
            // Use method channel to open link in native browser
            final bool? result = await platform.invokeMethod('openLink', link);

            if (result != true) {
              _sh22owErrorSnackBar(context, "Could not launch the link");
            }
          } on PlatformException catch (e) {
            // Handle platform-specific errors
            _sh22owErrorSnackBar(context, "Error opening link: ${e.message}");
          }
        } else {
          _sh22owErrorSnackBar(context, "No link available");
        }
      } else {
        _sh22owErrorSnackBar(context, "No link found in database");
      }
    } catch (e) {
      // Handle any unexpected errors
      _sh22owErrorSnackBar(
          context, "An error occurred while fetching the link");
    }
  }

  static Future<void> _checkLoginAndNavigat81e(BuildContext context) async {
    try {
      // Fetch the document from Firestore
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Links")
          .doc("sliders")
          .get();

      // Check if the document exists and contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Safely extract the link using null-aware operator
        final String? link = snapshot.get("link");

        // Validate the link
        if (link != null && link.isNotEmpty) {
          try {
            // Use method channel to open link in native browser
            final bool? result = await platform.invokeMethod('openLink', link);

            if (result != true) {
              _sh22owErrorSnackBar(context, "Could not launch the link");
            }
          } on PlatformException catch (e) {
            // Handle platform-specific errors
            _sh22owErrorSnackBar(context, "Error opening link: ${e.message}");
          }
        } else {
          _sh22owErrorSnackBar(context, "No link available");
        }
      } else {
        _sh22owErrorSnackBar(context, "No link found in database");
      }
    } catch (e) {
      // Handle any unexpected errors
      _sh22owErrorSnackBar(
          context, "An error occurred while fetching the link");
    }
  }

  // Helper method to show error snackbar
  static void _sh22owErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Helper method to show error snackbar
  static void _showErrorSnackBa1r(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _fetchPhoneNumber() async {
    try {
      // Fetch the document from Firestore
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Links")
          .doc("phone")
          .get();

      // Check if the document exists and contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Safely extract the phone number
        final String? number = snapshot.get("number");

        // Update state if number is found
        if (number != null && number.isNotEmpty) {
          setState(() {
            _phoneNumber = number;
          });
        }
      }
    } catch (e) {
      print("Error fetching phone number: $e");
      // State remains "No number found" if there's an error
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      // Fetch the document from Firestore
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Links")
          .doc("location")
          .get();

      // Check if the document exists and contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Safely extract the location and maps link
        final String? locationText = snapshot.get("text");
        final String? mapUrl = snapshot.get("mapsLink");

        // Update state if location is found
        if (locationText != null && locationText.isNotEmpty) {
          setState(() {
            _location = locationText;
            _mapsLink = mapUrl ?? "";
          });
        }
      }
    } catch (e) {
      print("Error fetching location: $e");
      // State remains "No location found" if there's an error
    }
  }

  // Method to launch location in maps
  void _launchLocation() async {
    // If maps link exists, try to launch it
    if (_mapsLink.isNotEmpty) {
      try {
        final Uri uri = Uri.parse(_mapsLink);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw 'Could not launch location';
        }
      } catch (e) {
        print('Error launching location: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open location')),
        );
      }
    } else {
      // If no maps link, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No location link available')),
      );
    }
  }

  String _location = "No location found";
  String _mapsLink = "";
  String _phoneNumber = "No number found";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hotline",
              style: TextStyle(color: Colors.white, fontSize: 24.sp)),
          backgroundColor: Color(0xff008000),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                width: 120.w,
                height: 120.w,
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                "একসাথে চলি স্বাস্থ্যসেবায় নতুন দিগন্ত\n\n তৈরি করি- সেবা ফাউন্ডেশন।",
                style: TextStyle(
                    height: 0.9.sp,
                    fontFamily: "SolaimanLipi",
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialIcon(
                    lottieAsset: "images/web.json",
                    width: 50.w,
                    height: 50.w,
                    onTap: () => _checkLoginAndNavigat8e(context, "websiteUrl"),
                  ),

                  // Facebook Icon
                  _buildSocialIcon(
                    lottieAsset: "images/fb.json",
                    width: 40.w,
                    height: 40.w,
                    onTap: () => _checkLoginAndNavigat8e(context, "faceeUrl"),
                  ),

                  // YouTube Icon
                  _buildSocialIcon(
                    lottieAsset: "images/uTube.json",
                    width: 60.w,
                    height: 60.w,
                    onTap: () => _checkLoginAndNavigat8e(context, "uTubeUrl"),
                  ),

                  // Instagram Icon
                  _buildSocialIcon(
                    lottieAsset: "images/insta.json",
                    width: 35.w,
                    height: 35.w,
                    onTap: () => _checkLoginAndNavigat8e(context, "instaUrl"),
                  ),

                  // Twitter Icon
                  _buildSocialIcon(
                    lottieAsset: "images/twi.json",
                    width: 60.w,
                    height: 60.w,
                    onTap: () => _checkLoginAndNavigat8e(context, "twiUrl"),
                  ),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: Lottie.asset("images/wp.json")),
                  Text(
                    "   $_phoneNumber",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 80.w,
                      height: 80.w,
                      child: Lottie.asset("images/loc.json")),
                  Text(
                    "   $_location",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  // Helper method to create consistent social media icons
  Widget _buildSocialIcon({
    required String lottieAsset,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Lottie.asset(
          lottieAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
