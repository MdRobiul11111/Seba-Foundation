import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seba_app1/application/app/promotion_provider.dart';

class Promotion extends ConsumerWidget {
  const Promotion({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final promotionList = ref.watch(promotionListProvider);
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
      body: promotionList.maybeWhen(
        data: (data) => ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final image = data[index].imgae;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
              child: Card(
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  width: double.infinity,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Failed to load image'));
                    },
                  ),
                ),
              ),
            );
          },
        ),
        orElse: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
