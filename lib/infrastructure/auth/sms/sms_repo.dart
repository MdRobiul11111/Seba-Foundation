import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:seba_app1/application/auth/sms/sms_state.dart';
import 'package:seba_app1/application/core/api_path.dart';
import 'package:seba_app1/domain/auth/sms/i_sms_repo.dart';
import 'package:seba_app1/domain/auth/sms/sms_model.dart';

class SmsRepo extends ISmsRepo {
  final Dio smsDio;

  SmsRepo(this.smsDio);

  final smsCollection = FirebaseFirestore.instance.collection("Otp");

  @override
  Future<SmsState?> sendSms({required String phone}) async {
    final otp = generatePin();
    try {
      final smsModel = SmsModel(
          contacts: '88$phone',
          acode: ApiPath.smsAcode,
          senderId: ApiPath.smsSenderId,
          apiKey: ApiPath.smsApiKey,
          type: ApiPath.smsType,
          msg:
              'Seba Foundation: Your OTP is $otp. It is valid for 2 minutes. Do not share this code with anyone.',
          transactionType: 'T',
          contentID: '');
      await smsDio.post(
        ApiPath.sendSms,
        queryParameters: smsModel.toMap(),
      );
      // final requestId = response.data["info"]["requestID"];
      // await smsCollection.doc(requestId).set({
      //   "requestId": requestId,
      //   "phoneNumber": smsModel.contacts,
      //   "pin": otp,
      //   "createdAt": DateTime.now(),
      // });
      return SmsState(
          otp: otp,
          isVarified: false,
          createdAt: DateTime.now(),
          isExpired: false);
    } on DioException catch (e) {
      final message =
          e.response?.data["response"]["message"] ?? "Unknown error";
      Logger().e(message);
      return null;
    }
  }

  String generatePin() {
    final random = Random();
    final pin = random.nextInt(9000) + 1000; // Generate a 4-digit pin
    return pin.toString();
  }
}
