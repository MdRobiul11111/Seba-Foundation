import 'dart:convert';

import 'package:equatable/equatable.dart';

class SmsState extends Equatable {
  final String otp;
  final bool isVarified;
  final DateTime createdAt;
  const SmsState({
    required this.otp,
    required this.isVarified,
    required this.createdAt,
  });

  SmsState copyWith({
    String? otp,
    bool? isVarified,
    DateTime? createdAt,
  }) {
    return SmsState(
      otp: otp ?? this.otp,
      isVarified: isVarified ?? this.isVarified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'otp': otp,
      'isVarified': isVarified,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory SmsState.fromMap(Map<String, dynamic> map) {
    return SmsState(
      otp: map['otp'] ?? '',
      isVarified: map['isVarified'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SmsState.fromJson(String source) =>
      SmsState.fromMap(json.decode(source));

  @override
  String toString() =>
      'SmsState(otp: $otp, isVarified: $isVarified, createdAt: $createdAt)';

  @override
  List<Object> get props => [otp, isVarified, createdAt];

  factory SmsState.initial() {
    return SmsState(
      otp: '',
      isVarified: false,
      createdAt: DateTime.now(),
    );
  }
}
