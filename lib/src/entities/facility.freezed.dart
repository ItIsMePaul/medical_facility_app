// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Facility {

 String get id; String get name; String get address; int get totalBeds; int get availableBeds; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacilityCopyWith<Facility> get copyWith => _$FacilityCopyWithImpl<Facility>(this as Facility, _$identity);

  /// Serializes this Facility to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Facility&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.totalBeds, totalBeds) || other.totalBeds == totalBeds)&&(identical(other.availableBeds, availableBeds) || other.availableBeds == availableBeds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,totalBeds,availableBeds,createdAt,updatedAt);

@override
String toString() {
  return 'Facility(id: $id, name: $name, address: $address, totalBeds: $totalBeds, availableBeds: $availableBeds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FacilityCopyWith<$Res>  {
  factory $FacilityCopyWith(Facility value, $Res Function(Facility) _then) = _$FacilityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address, int totalBeds, int availableBeds, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$FacilityCopyWithImpl<$Res>
    implements $FacilityCopyWith<$Res> {
  _$FacilityCopyWithImpl(this._self, this._then);

  final Facility _self;
  final $Res Function(Facility) _then;

/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? totalBeds = null,Object? availableBeds = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,totalBeds: null == totalBeds ? _self.totalBeds : totalBeds // ignore: cast_nullable_to_non_nullable
as int,availableBeds: null == availableBeds ? _self.availableBeds : availableBeds // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Facility implements Facility {
  const _Facility({required this.id, required this.name, required this.address, required this.totalBeds, required this.availableBeds, required this.createdAt, required this.updatedAt});
  factory _Facility.fromJson(Map<String, dynamic> json) => _$FacilityFromJson(json);

@override final  String id;
@override final  String name;
@override final  String address;
@override final  int totalBeds;
@override final  int availableBeds;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacilityCopyWith<_Facility> get copyWith => __$FacilityCopyWithImpl<_Facility>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Facility&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.totalBeds, totalBeds) || other.totalBeds == totalBeds)&&(identical(other.availableBeds, availableBeds) || other.availableBeds == availableBeds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,totalBeds,availableBeds,createdAt,updatedAt);

@override
String toString() {
  return 'Facility(id: $id, name: $name, address: $address, totalBeds: $totalBeds, availableBeds: $availableBeds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FacilityCopyWith<$Res> implements $FacilityCopyWith<$Res> {
  factory _$FacilityCopyWith(_Facility value, $Res Function(_Facility) _then) = __$FacilityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address, int totalBeds, int availableBeds, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$FacilityCopyWithImpl<$Res>
    implements _$FacilityCopyWith<$Res> {
  __$FacilityCopyWithImpl(this._self, this._then);

  final _Facility _self;
  final $Res Function(_Facility) _then;

/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? totalBeds = null,Object? availableBeds = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Facility(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,totalBeds: null == totalBeds ? _self.totalBeds : totalBeds // ignore: cast_nullable_to_non_nullable
as int,availableBeds: null == availableBeds ? _self.availableBeds : availableBeds // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
