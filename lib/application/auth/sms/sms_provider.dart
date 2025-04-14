import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seba_app1/application/auth/sms/sms_state.dart';
import 'package:seba_app1/application/core/sms_dio_provider.dart';
import 'package:seba_app1/domain/auth/sms/i_sms_repo.dart';
import 'package:seba_app1/infrastructure/auth/sms/sms_repo.dart';

final smsRepoProvider = FutureProvider<ISmsRepo>((ref) async {
  final smsDio = ref.watch(smsDioProvider);
  return SmsRepo(smsDio);
});

final smsStateProvider = StateNotifierProvider<SmsNotifier, SmsState>((ref) {
  return SmsNotifier(ref);
});

class SmsNotifier extends StateNotifier<SmsState> {
  final Ref ref;
  SmsNotifier(this.ref) : super(SmsState.initial());

  Future<bool> sendOtp(String phoneNumber) async {
    final smsRepo = await ref.watch(smsRepoProvider.future);
    final otp = await smsRepo.sendSms(phone: phoneNumber);
    if (otp != null) {
      state = otp;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    final time = DateTime.now().difference(state.createdAt).inSeconds;
    if (state.otp == otp && time < 120) {
      state = state.copyWith(isVarified: true, isExpired: false);
      return true;
    } else {
      if (time > 120) {
        state = state.copyWith(isVarified: false, isExpired: true);
      } else {
        state = state.copyWith(isVarified: false);
      }
      return false;
    }
  }
}
