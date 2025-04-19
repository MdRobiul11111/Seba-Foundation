import 'dart:convert';

import 'package:equatable/equatable.dart';

class PromotionModel extends Equatable {
  final String id;
  final String imgae;
  const PromotionModel({required this.id, required this.imgae});

  PromotionModel copyWith({String? id, String? imgae}) {
    return PromotionModel(id: id ?? this.id, imgae: imgae ?? this.imgae);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'imgae': imgae};
  }

  factory PromotionModel.fromMap(Map<String, dynamic> map) {
    return PromotionModel(id: map['id'] ?? '', imgae: map['imgae'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory PromotionModel.fromJson(String source) =>
      PromotionModel.fromMap(json.decode(source));

  @override
  String toString() => 'PromotionModel(id: $id, imgae: $imgae)';

  @override
  List<Object> get props => [id, imgae];
}
