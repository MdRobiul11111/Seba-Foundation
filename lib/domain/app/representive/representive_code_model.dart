import 'dart:convert';

import 'package:equatable/equatable.dart';

class RepresentiveCodeModel extends Equatable {
  final String name;
  final String code;
  final bool isUsed;
  const RepresentiveCodeModel({
    required this.name,
    required this.code,
    required this.isUsed,
  });

  RepresentiveCodeModel copyWith({String? name, String? code, bool? isUsed}) {
    return RepresentiveCodeModel(
      name: name ?? this.name,
      code: code ?? this.code,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'code': code, 'isUsed': isUsed};
  }

  factory RepresentiveCodeModel.fromMap(Map<String, dynamic> map) {
    return RepresentiveCodeModel(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      isUsed: map['isUsed'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory RepresentiveCodeModel.fromJson(String source) =>
      RepresentiveCodeModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RepresentiveCodeModel(name: $name, code: $code, isUsed: $isUsed)';

  @override
  List<Object> get props => [name, code, isUsed];
}
