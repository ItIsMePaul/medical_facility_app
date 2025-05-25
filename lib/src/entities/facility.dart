import 'package:freezed_annotation/freezed_annotation.dart';

part 'facility.freezed.dart';
part 'facility.g.dart';

@freezed
abstract class Facility with _$Facility {
  const factory Facility({
    required String id,
    required String name,
    required String address,
    required int totalBeds,
    required int availableBeds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Facility;
  factory Facility.fromJson(Map<String, dynamic> json) =>
      _$FacilityFromJson(json);
}
