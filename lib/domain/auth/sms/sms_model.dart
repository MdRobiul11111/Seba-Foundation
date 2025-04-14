import 'dart:convert';

import 'package:equatable/equatable.dart';

class SmsModel extends Equatable {
  final String acode;
  final String apiKey;
  final String senderId;
  final String type;
  final String msg;
  final String contacts;
  final String transactionType;
  final String contentID;
  const SmsModel({
    required this.acode,
    required this.apiKey,
    required this.senderId,
    required this.type,
    required this.msg,
    required this.contacts,
    required this.transactionType,
    required this.contentID,
  });

  SmsModel copyWith({
    String? acode,
    String? apiKey,
    String? senderId,
    String? type,
    String? msg,
    String? contacts,
    String? transactionType,
    String? contentID,
  }) {
    return SmsModel(
      acode: acode ?? this.acode,
      apiKey: apiKey ?? this.apiKey,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      msg: msg ?? this.msg,
      contacts: contacts ?? this.contacts,
      transactionType: transactionType ?? this.transactionType,
      contentID: contentID ?? this.contentID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'acode': acode,
      'api_key': apiKey,
      'senderid': senderId,
      'type': type,
      'msg': msg,
      'contacts': contacts,
      'transactionType': transactionType,
      'contentID': contentID,
    };
  }

  factory SmsModel.fromMap(Map<String, dynamic> map) {
    return SmsModel(
      acode: map['acode'] ?? '',
      apiKey: map['api_key'] ?? '',
      senderId: map['senderid'] ?? '',
      type: map['type'] ?? '',
      msg: map['msg'] ?? '',
      contacts: map['contacts'] ?? '',
      transactionType: map['transactionType'] ?? '',
      contentID: map['contentID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SmsModel.fromJson(String source) =>
      SmsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SmsModel(acode: $acode, apiKey: $apiKey, senderId: $senderId, type: $type, msg: $msg, contacts: $contacts, transactionType: $transactionType, contentId: $contentID)';
  }

  @override
  List<Object> get props {
    return [
      acode,
      apiKey,
      senderId,
      type,
      msg,
      contacts,
      transactionType,
      contentID,
    ];
  }
}
