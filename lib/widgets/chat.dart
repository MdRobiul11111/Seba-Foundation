import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: Text("CHAT",style: TextStyle(color: Colors.white,fontSize: 18.sp)),
        ),
        backgroundColor: Color(0xff008000),

      ),

    );
  }
}
