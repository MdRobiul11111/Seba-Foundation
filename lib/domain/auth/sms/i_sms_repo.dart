import 'package:seba_app1/application/auth/sms/sms_state.dart';

abstract class ISmsRepo {
  Future<SmsState?> sendSms({required String phone});
}
