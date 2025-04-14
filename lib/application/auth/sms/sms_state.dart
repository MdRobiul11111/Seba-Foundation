import 'dart:convert';

import 'package:equatable/equatable.dart';

class SmsState extends Equatable {
  final String otp;
  final bool isVarified;
  final DateTime createdAt;
  final bool isExpired;
  const SmsState({
    required this.otp,
    required this.isVarified,
    required this.createdAt,
    required this.isExpired,
  });

  SmsState copyWith({
    String? otp,
    bool? isVarified,
    DateTime? createdAt,
    bool? isExpired,
  }) {
    return SmsState(
      otp: otp ?? this.otp,
      isVarified: isVarified ?? this.isVarified,
      createdAt: createdAt ?? this.createdAt,
      isExpired: isExpired ?? this.isExpired,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'otp': otp,
      'isVarified': isVarified,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isExpired': isExpired,
    };
  }

  factory SmsState.fromMap(Map<String, dynamic> map) {
    return SmsState(
      otp: map['otp'] ?? '',
      isVarified: map['isVarified'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isExpired: map['isExpired'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SmsState.fromJson(String source) =>
      SmsState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SmsState(otp: $otp, isVarified: $isVarified, createdAt: $createdAt, isExpired: $isExpired)';
  }

  @override
  List<Object> get props => [otp, isVarified, createdAt, isExpired];

  factory SmsState.initial() {
    return SmsState(
        otp: '',
        isVarified: false,
        createdAt: DateTime.now(),
        isExpired: false);
  }
}
