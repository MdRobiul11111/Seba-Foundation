import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seba_app1/page/chat1.dart';

import '../widgets/donate.dart';
import '../widgets/home.dart';
import '../widgets/profile.dart';
import '../widgets/promotion.dart';
import 'login_signup.dart';
// Import the LoginSignup page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  PageController pageController = PageController(initialPage: 2);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onItemTapped(int index) {
    User? user = _auth.currentUser; // Get the current user

    if (user == null) {
      // If not logged in, navigate to LoginSignup page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginSignup()),
      );
      return;
    }

    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Exit App"),
            content: Text("Are you sure you want to exit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xff007600),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            Profile(),
            Donate(),
            Home(),
            Chat1(),
            Promotion(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 94.5.h,
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              _buildBarItem(
                  "images/profile.png", "Profile", "images/profilef.png", 0),
              _buildBarItem(
                  "images/donet.png", "Donate", "images/donatef.png", 1),
              _buildBarItem("images/home.png", "Home", "images/homef.png", 2),
              _buildBarItem("images/chat.png", "Chat", "images/chatf.png", 3),
              _buildBarItem(
                  "images/promotion.png", "Promotion", "images/promof.png", 4),
            ],
            backgroundColor: const Color(0xff008000),
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            unselectedItemColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: true,
            onTap: onItemTapped,
            enableFeedback: false,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem(
      String icon, String label, String filledIcon, int index) {
    bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Transform.translate(
        offset: isSelected ? Offset(0, 6.5) : Offset(0, 0),
        child: isSelected
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: EdgeInsets.all(6),
                child: ImageIcon(
                  AssetImage(filledIcon),
                  color: Colors.white,
                  size: 25,
                ),
              )
            : ImageIcon(
                AssetImage(icon),
                color: Colors.white,
              ),
      ),
      label: label,
    );
  }
}
