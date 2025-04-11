import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile1 extends StatefulWidget {
  const Profile1({super.key});

  @override
  State<Profile1> createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  bool value = false;
  bool value1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: Text("PROFILE",
              style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        ),
        backgroundColor: const Color(0xff008000),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0.w),
            child: IconButton(
              onPressed: () {},
              icon: ImageIcon(
                const AssetImage("images/editic.png"),
                color: Colors.white,
                size: 23.r,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              height: 265.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Top and Bottom Containers
                  Column(
                    children: [
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        color: const Color(0xffD9D9D9),
                      ),
                      Container(
                        height: 50.h,
                        width: double.infinity,
                      ),
                    ],
                  ),
                  // Profile Image (CircleAvatar)
                  Positioned(
                    top: 125.h,
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundImage: const AssetImage("images/logo.png"),
                    ),
                  ),
                ],
              ),
            ),

            // Row with Button and Text
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(const Color(0xff008000)),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 15.w),
                      ),
                    ),
                    child: const Text("Available Now"),
                  ),
                  SizedBox(width: 10.w),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_outlined,
                        color: Color(0xff008000),
                      ),
                      Text(
                        "120 Days",
                        style: TextStyle(
                          color: const Color(0xff008000),
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // TextField Below the Row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    labelText: "Name",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    labelText: "Blood group",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    labelText: "Number",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    labelText: "Division",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    labelText: "District",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    labelText: "Thana",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    labelText: "Local Address",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    suffixIcon: Row(
                      children: [
                        Text(
                          "  Donation Complete",
                          style: TextStyle(
                              color: Color(0xff008000), fontSize: 18.sp),
                        ),
                        Spacer(),
                        Checkbox(
                          activeColor: Color(0xff008000),
                          side: BorderSide(color: Color(0xff008000)),
                          checkColor: Colors.white,
                          value: value,
                          onChanged: (bool? newValue) {
                            setState(() {
                              value = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.w, color: Color(0xff008000))),
                    suffixIcon: Row(
                      children: [
                        Text(
                          "  As a blood donor",
                          style: TextStyle(
                              color: Color(0xff008000), fontSize: 18.sp),
                        ),
                        Spacer(),
                        Checkbox(
                          activeColor: Color(0xff008000),
                          side: BorderSide(color: Color(0xff008000)),
                          checkColor: Colors.white,
                          value: value1,
                          onChanged: (bool? newValue) {
                            setState(() {
                              value1 = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
