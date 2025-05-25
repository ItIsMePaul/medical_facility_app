// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Facility _$FacilityFromJson(Map<String, dynamic> json) => _Facility(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  totalBeds: (json['totalBeds'] as num).toInt(),
  availableBeds: (json['availableBeds'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FacilityToJson(_Facility instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'totalBeds': instance.totalBeds,
  'availableBeds': instance.availableBeds,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
