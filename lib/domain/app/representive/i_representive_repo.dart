import 'package:flutter/material.dart';

abstract class IRepresentiveRepo {
  Future<void> updateRepresentiveCode({
    required String code,
    required BuildContext context,
  });
  Future<String> checkRepresentiveCode({
    required String code,
  });
}
