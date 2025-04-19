import 'dart:convert';

import 'package:equatable/equatable.dart';

class NoticeModel extends Equatable {
  final String id;
  final String imgae;
  const NoticeModel({required this.id, required this.imgae});

  NoticeModel copyWith({String? id, String? imgae}) {
    return NoticeModel(id: id ?? this.id, imgae: imgae ?? this.imgae);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'imgae': imgae};
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(id: map['id'] ?? '', imgae: map['imgae'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory NoticeModel.fromJson(String source) =>
      NoticeModel.fromMap(json.decode(source));

  @override
  String toString() => 'NoticeModel(id: $id, imgae: $imgae)';

  @override
  List<Object> get props => [id, imgae];
}
