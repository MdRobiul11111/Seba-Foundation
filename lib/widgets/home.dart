import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:seba_app1/widgets/profile.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../top_card_page/blood.dart';
import '../top_card_page/find_doctor.dart';
import '../top_card_page/hotline.dart';
import '../top_card_page/representative.dart';
import '../top_card_page/thela_regi.dart';
import '../page/chat1.dart';
import '../page/login_signup.dart';
import '../page/promo1.dart';
import '../page/regi_ambulance.dart';
import '../page/search_ambu.dart';
import 'donate.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentBannerPage = 0;
  final PageController _pageController = PageController();

  //Titles and images for the cards
  // ignore: unused_field
  final List<String> _titles = [
    "Blood",
    "Thalassemia patients",
    "Representative registration",
    "Find doctor",
    "Hotline",
    "Ambulance",
  ];

  // ignore: unused_field
  final List<String> _images = [
    "images/blood.png",
    "images/thala.png",
    "images/repren.png",
    "images/find.png",
    "images/hotline.png",
    "images/ambu.png",
  ];

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
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Could not launch the link")),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No link available")),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No link found in database")),
        );
      }
    }
  }

  // void _checkLoginAndNaviga1te(BuildContext context) async {
  //   try {
  //     // Fetch the document from Firestore
  //     final DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection("Links")
  //         .doc("aboutUs")
  //         .get();

  //     // Check if the document exists and contains data
  //     if (snapshot.exists && snapshot.data() != null) {
  //       // Safely extract the link using null-aware operator
  //       final String? link = snapshot.get("link");

  //       // Validate the link
  //       if (link != null && link.isNotEmpty) {
  //         final Uri? url = Uri.tryParse(link);

  //         if (url != null) {
  //           // Attempt to launch the URL
  //           final bool canLaunch = await canLaunchUrl(url);

  //           if (canLaunch) {
  //             await launchUrl(url, mode: LaunchMode.externalApplication);
  //           } else {
  //             // Show error if URL cannot be launched
  //             if (context.mounted) {
  //               _showErrorSnackBar(context, "Could not launch the link");
  //             }
  //           }
  //         } else {
  //           if (context.mounted) {
  //             _showErrorSnackBar(context, "Invalid URL format");
  //           }
  //         }
  //       } else {
  //         if (context.mounted) {
  //           _showErrorSnackBar(context, "No link available");
  //         }
  //       }
  //     } else {
  //       if (context.mounted) {
  //         _showErrorSnackBar(context, "No link found in database");
  //       }
  //     }
  //   } catch (e) {
  //     // Handle any unexpected errors
  //     if (context.mounted) {
  //       _showErrorSnackBar(
  //           context, "An error occurred while fetching the link");
  //     }
  //   }
  // }

// Helper method to show error snackbar
  // void _showErrorSnackBar(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }

  // void _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     debugPrint("Could not launch $url");
  //   }
  // }

  // void _showMessage(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  static const platform = MethodChannel('com.yourapp/link_opener');

  static Future<void> _checkLoginAndNavigat8e(BuildContext context) async {
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
          try {
            // Use method channel to open link in native browser
            final bool? result = await platform.invokeMethod('openLink', link);

            if (result != true) {
              if (context.mounted) {
                _sh22owErrorSnackBar(context, "Could not launch the link");
              }
            }
          } on PlatformException catch (e) {
            // Handle platform-specific errors
            if (context.mounted) {
              _sh22owErrorSnackBar(context, "Error opening link: ${e.message}");
            }
          }
        } else {
          if (context.mounted) {
            _sh22owErrorSnackBar(context, "No link available");
          }
        }
      } else {
        if (context.mounted) {
          _sh22owErrorSnackBar(context, "No link found in database");
        }
      }
    } catch (e) {
      // Handle any unexpected errors
      if (context.mounted) {
        _sh22owErrorSnackBar(
            context, "An error occurred while fetching the link");
      }
    }
  }

  // static Future<void> _checkLoginAndNavigat81e(BuildContext context) async {
  //   try {
  //     // Fetch the document from Firestore
  //     final DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection("Links")
  //         .doc("sliders")
  //         .get();

  //     // Check if the document exists and contains data
  //     if (snapshot.exists && snapshot.data() != null) {
  //       // Safely extract the link using null-aware operator
  //       final String? link = snapshot.get("link");

  //       // Validate the link
  //       if (link != null && link.isNotEmpty) {
  //         try {
  //           // Use method channel to open link in native browser
  //           final bool? result = await platform.invokeMethod('openLink', link);

  //           if (result != true) {
  //             if (context.mounted) {
  //               _sh22owErrorSnackBar(context, "Could not launch the link");
  //             }
  //           }
  //         } on PlatformException catch (e) {
  //           // Handle platform-specific errors
  //           if (context.mounted) {
  //             _sh22owErrorSnackBar(context, "Error opening link: ${e.message}");
  //           }
  //         }
  //       } else {
  //         if (context.mounted) {
  //           _sh22owErrorSnackBar(context, "No link available");
  //         }
  //       }
  //     } else {
  //       if (context.mounted) {
  //         _sh22owErrorSnackBar(context, "No link found in database");
  //       }
  //     }
  //   } catch (e) {
  //     // Handle any unexpected errors
  //     if (context.mounted) {
  //       _sh22owErrorSnackBar(
  //           context, "An error occurred while fetching the link");
  //     }
  //   }
  // }

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
  // static void _showErrorSnackBa1r(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }

  List<Map<String, dynamic>> sliderData = [];
  bool isSliderLoading = false;
  bool isBannerLoading = true;
  List<Map<String, dynamic>> bannerData = [];

  Future<void> loadBannerData() async {
    setState(() => isBannerLoading = true);
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Image').get();

      // Store all banner data
      bannerData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'url': data['url'] ?? '',
          // Add any other fields you need from your banner documents
        };
      }).toList();

      setState(() {
        isBannerLoading = false;
      });
    } catch (e) {
      setState(() => isBannerLoading = false);
      Logger().e('Error loading banner data: $e');
    }
    Logger().f("Loaded banner data: $bannerData");
  }

  @override
  void initState() {
    super.initState();
    loadBannerData();
    loadSliderData();
  }

  Widget buildBannerWithLoadedData() {
    if (isBannerLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Use loaded data if available, otherwise use default data
    if (bannerData.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginSignup(),
            ),
          );
        },
        child: CarouselSlider(
          options: CarouselOptions(
            height: 150.h,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 1200),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerPage = index;
              });
            },
          ),
          items: bannerData.map((doc) {
            final imageUrl = doc['url'] ?? '';
            return Builder(
              builder: (BuildContext context) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginSignup(),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Text('Failed to load image'));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      );
    } else {
      // Fallback to local images if no Firestore data
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginSignup(),
            ),
          );
        },
        child: CarouselSlider(
          options: CarouselOptions(
            height: 140.h,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 1200),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerPage = index;
              });
            },
          ),
          items: [
            "Item 1",
            "Item 2",
            "Item 3",
          ].map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginSignup(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "images/banner1.png",
                      width: 320.w,
                      height: 40.h,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      );
    }
  }

// Add this function to load slider data
  Future<void> loadSliderData() async {
    setState(() => isSliderLoading = true);
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('SlidersImformation')
          .get();

      // Store all slider data
      sliderData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'imageUrl': data['imageUrl'] ?? '',
          'title': data['title'] ??
              'আমরা তরুণ, আমরা অদম্য,\n\nমানবিক পৃথিবী আমাদের প্রতিজ্ঞা',
          // Add any other fields you need from your slider documents
        };
      }).toList();

      setState(() {
        isSliderLoading = false;
      });
    } catch (e) {
      setState(() => isSliderLoading = false);
      Logger().e('Error loading slider data: $e');
    }
    Logger().f("AAAA$sliderData");
  }

  // Improved carousel slider with Firestore data
  Widget buildSliderWithLoadedData() {
    if (isSliderLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Use loaded data if available, otherwise use default data
    if (sliderData.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 320.h,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          viewportFraction: 0.8,
        ),
        items: sliderData.map((item) {
          // Extract data from loaded items
          final imageUrl = item['imageUrl'] ?? '';
          final title = item['title'] ??
              'আমরা তরুণ, আমরা অদম্য,\n\nমানবিক পৃথিবী আমাদের প্রতিজ্ঞা';

          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => _checkLoginAndNavigate(() {
                  // Add navigation logic if needed
                }),
                child: Card(
                  elevation: 5,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () => _checkLoginAndNavigate(() {
                      // Add navigation logic if needed
                    }),
                    child: SizedBox(
                      width: double.infinity,
                      height: 300.h,
                      child: Column(
                        children: [
                          Image.asset(
                            "images/notice.png",
                            width: 160.sp,
                            height: 60,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showImageDialog(context, imageUrl);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            "images/sampleim.png");
                                      },
                                    )
                                  : Image.asset("images/sampleim.png"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.0.w, top: 8.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      height: 0.9.sp,
                                      fontFamily: "Noto Sans Bengali",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _openLink(context),
                                  icon: ImageIcon(
                                    const AssetImage("images/button.png"),
                                    color: const Color(0xff008000),
                                    size: 47.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    } else {
      // Default fallback items
      return CarouselSlider(
        options: CarouselOptions(
          height: 320.h,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          viewportFraction: 0.8,
        ),
        items: [
          "Item 1",
          "Item 2",
          "Item 3",
          "Item 4",
          "Item 5",
        ].map((item) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => _checkLoginAndNavigate(() {}),
                child: Card(
                  elevation: 5,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () => _checkLoginAndNavigate(() {}),
                    child: SizedBox(
                      width: double.infinity,
                      height: 300.h,
                      child: Column(
                        children: [
                          Image.asset(
                            "images/notice.png",
                            width: 160.sp,
                            height: 60,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showImageDialog(context, "");
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Image.asset("images/sampleim.png"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.0.w, top: 8.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "আমরা তরুণ, আমরা অদম্য,\n\nমানবিক পৃথিবী আমাদের প্রতিজ্ঞা",
                                    style: TextStyle(
                                      height: 0.9.sp,
                                      fontFamily: "Noto Sans Bengali",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _openLink(context),
                                  icon: ImageIcon(
                                    const AssetImage("images/button.png"),
                                    color: const Color(0xff008000),
                                    size: 47.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    }
  }

// Add this function to your class to show the image dialog
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.all(10),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset("images/sampleim.png");
                                    },
                                  )
                                : Image.asset(
                                    "images/sampleim.png",
                                    fit: BoxFit.contain,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Top Banner Section
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff008000),
                  image: DecorationImage(
                    image: AssetImage("images/bg2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
                height: 230.h,
                child: Column(
                  children: [
                    // Popup Menu Button
                    Container(
                      alignment: Alignment.topLeft,
                      child: PopupMenuButton<int>(
                        onSelected: (selected) {
                          if (selected == 6) {
                            // Navigate to settings
                          }
                        },
                        icon: ImageIcon(
                          const AssetImage("images/drawer.png"),
                          size: 25.r,
                          color: Colors.white,
                        ),
                        elevation: 2,
                        iconSize: 28,
                        color: Colors.white,
                        itemBuilder: (context) => <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                const Icon(Icons.home_outlined),
                                SizedBox(width: 8.w),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<int>(
                            onTap: () {
                              _checkLoginAndNavigate(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Donate()),
                                );
                              });
                            },
                            value: 2,
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/donet.png"),
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Donate",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<int>(
                            onTap: () {
                              _checkLoginAndNavigate(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chat1()),
                                );
                              });
                            },
                            value: 3,
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/chat.png"),
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Chat",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<int>(
                            onTap: () {
                              _checkLoginAndNavigate(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Promotion()),
                                );
                              });
                            },
                            value: 4,
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/promotion.png"),
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Promotion",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<int>(
                            onTap: () {
                              _checkLoginAndNavigate(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile()),
                                );
                              });
                            },
                            value: 5,
                            child: Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/profile.png"),
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<int>(
                            onTap: () {
                              _checkLoginAndNavigat8e(context);
                            },
                            value: 6,
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline),
                                SizedBox(width: 8.w),
                                Text(
                                  "About Us",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<int>(
                            onTap: _handleLogout,
                            value: 7,
                            child: Row(
                              children: [
                                const Icon(Icons.logout),
                                SizedBox(width: 8.w),
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Carousel Slider with StreamBuilder
                    buildBannerWithLoadedData(),

                    // Dots Indicator
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                          width: _currentBannerPage == index ? 12.w : 8.w,
                          height: _currentBannerPage == index ? 12.w : 8.w,
                          decoration: BoxDecoration(
                            color: _currentBannerPage == index
                                ? Colors.white
                                : Colors.white.withValues(alpha: .6),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Horizontal Scroll Section
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180.h,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            topList("Blood", "images/blood.png"),
                            topList("Thalassemia patients", "images/thala.png"),
                            topList("Representative registration",
                                "images/repren.png"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            topList("Find doctor", "images/find.png"),
                            topList("Hotline", "images/hotline.png"),
                            topList("Ambulance", "images/ambu.png"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: WormEffect(
                      dotHeight: 12.h,
                      dotWidth: 12.h,
                      activeDotColor: Color(0xffCC2B2C),
                      dotColor: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Bottom Carousel Slider
              buildSliderWithLoadedData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topList(String title, String image) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.sp, horizontal: 5.sp),
      child: GestureDetector(
        onTap: () {
          // Check login and navigate based on the title
          if (title == "Find doctor") {
            _checkLoginAndNavigate(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FindDoctor()));
            });
          } else if (title == "Blood") {
            _checkLoginAndNavigate(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Blood()));
            });
          } else if (title == "Thalassemia patients") {
            _checkLoginAndNavigate(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ThelaRegi()));
            });
          } else if (title == "Representative registration") {
            _checkLoginAndNavigate(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Representative()));
            });
          } else if (title == "Hotline") {
            _checkLoginAndNavigate(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Hotline()));
            });
          } else if (title == "Ambulance") {
            _checkLoginAndNavigate(() {
              _showAmbuO(context);
            });
          }
        },
        child: Card(
          elevation: 5,
          child: SizedBox(
            width: 120.w,
            height: 150.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  width: 50.w,
                  height: 70.w,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.2.sp,
                    fontFamily: 'Roboto', // Standard font
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAmbuO(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            height: 280.h,
            child: Padding(
              padding: EdgeInsets.only(top: 13.0.h, left: 17.w, right: 17.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    "What Do You Want",
                    style: TextStyle(
                      color: const Color(0xff008000),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      fontFamily: 'Roboto', // Standard font
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _checkLoginAndNavigate(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchAmbu()));
                          });
                        },
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(18.0.sp),
                            child: Column(
                              children: [
                                Image.asset("images/search.png", width: 50.w),
                                SizedBox(height: 15.h),
                                Text(
                                  "Search\n\nAmbulance",
                                  style: TextStyle(
                                    color: Colors.black,
                                    height: 0.7.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto', // Standard font
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _checkLoginAndNavigate(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegiAmbulance()));
                          });
                        },
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(18.0.sp),
                            child: Column(
                              children: [
                                Image.asset("images/edit.png", width: 50.w),
                                SizedBox(height: 15.h),
                                Text(
                                  "Register\n\nAmbulance",
                                  style: TextStyle(
                                    color: Colors.black,
                                    height: 0.7.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto', // Standard font
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLogout() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are not signed in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully logged out'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginSignup()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to logout: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
