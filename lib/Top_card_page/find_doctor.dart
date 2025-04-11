import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FindDoctor extends StatelessWidget {
  const FindDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Doctor",style: TextStyle(color: Colors.white,fontSize: 24.sp)),
        backgroundColor: Color(0xff008000),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: Center(
        child: Container(
         width: 320.w,
          height: 320.w,
          decoration: BoxDecoration(
            color: Color(0xff008000),
            shape: BoxShape.circle
          ),
          child: Center(child: Text("Coming Soon..!",style: TextStyle(color: Colors.white,fontSize: 22.sp),)),
        ),
      ),
    );
  }
}
