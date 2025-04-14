import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPath {
  static var smsBaseUrl = dotenv.env['BASE_URL'] ?? "";

  //sms api
  static var smsApiKey = dotenv.env['SMS_API_KEY'] ?? "";
  static var smsSenderId = dotenv.env['SMS_SENDER_ID'] ?? "";
  static var smsType = dotenv.env['SMS_TYPE'] ?? "";
  static var smsAcode = dotenv.env['SMS_ACCOUNT_CODE'] ?? "";

  static const String sendSms = "SMS_TYPE";
}
