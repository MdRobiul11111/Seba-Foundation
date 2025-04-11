import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _textController;
  late Animation<Offset> _textLeftAnimation;
  late Animation<Offset> _textRightAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation setup
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // Text animation setup
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _textLeftAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textRightAnimation = Tween<Offset>(
      begin: Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Start animations sequentially
    _logoController.forward().then((_) => _textController.forward());

    _navigateToHome();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 8), () {});
    Navigator.of(context).pushReplacementNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation
              ScaleTransition(
                scale: _logoAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 258.0),
                  child: Image.asset(
                    "images/logo.png",
                    width: 120.w,
                    height: 120.w,
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Text Animation
              SlideTransition(
                position: _textLeftAnimation,
                child: Text(
                  "আমরা তরুণ আমরা অদম্য",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "SolaimanLipi",
                    color: Colors.black,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              SlideTransition(
                position: _textRightAnimation,
                child: Text(
                  "মানবিক পৃথিবী আমাদের প্রতিজ্ঞা",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "SolaimanLipi",
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 260.h),
            ],
          ),
        ),
      ),
    );
  }
}
