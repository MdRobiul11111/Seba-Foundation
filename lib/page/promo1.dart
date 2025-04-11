import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Promotion extends StatefulWidget {
  const Promotion({super.key});

  @override
  State<Promotion> createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<Map<String, String>> items = [
    {"title": "Card 1",
      "subtitle": "This is the first card"},
    {"title": "Card 2", "subtitle": "This is the second card"},
    {"title": "Card 3", "subtitle": "This is the third card"},
    {"title": "Card 4", "subtitle": "This is the fourth card"},

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: Text(
            "PROMOTION",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
        backgroundColor: const Color(0xff008000),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('Image').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index){
                  final item = items[index];
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 6.h),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r)
                        ),
                        width: double.infinity,
                        height: 180.h,
                        child: Image.asset("images/promo.png",fit: BoxFit.cover,),
                      ),

                    ),
                  );
                });
          }

          final images = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index].data() as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                child: Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    width: double.infinity,
                    height: 180.h,
                    child: Image.network(
                      image['url'] ?? '', // Ensure 'url' is the field name in Firestore
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Failed to load image'));
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}