import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seba_app1/domain/app/representive/i_representive_repo.dart';
import 'package:seba_app1/domain/app/representive/representive_code_model.dart';

class RepresentiveRepo extends IRepresentiveRepo {
  final codeCollection = FirebaseFirestore.instance.collection(
    'representive_code',
  );

  @override
  Future<String> checkRepresentiveCode({required String code}) async {
    final docRef = codeCollection.doc(code);
    final data = await docRef.get();
    if (data.exists) {
      final representiveCode =
          RepresentiveCodeModel.fromMap(data.data() as Map<String, dynamic>);
      if (representiveCode.isUsed) {
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Code Already Used!'),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
        return 'used';
      } else {
        return 'active';
      }
    } else {
      // if (context.mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Code not exists!'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
      return 'not exists';
    }
  }

  @override
  Future<void> updateRepresentiveCode(
      {required String code, required BuildContext context}) async {
    final docRef = codeCollection.doc(code);
    final data = await docRef.get();
    if (data.exists) {
      final representiveCode =
          RepresentiveCodeModel.fromMap(data.data() as Map<String, dynamic>);
      await docRef.set(representiveCode.copyWith(isUsed: true).toMap());
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Code not exists!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
