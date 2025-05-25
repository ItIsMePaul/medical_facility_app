import 'package:firebase_dart/database.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:medical_facility_app/src/entities/facility.dart';

import 'facilities_repository.dart';

class FirebaseFacilitiesRepository implements FacilitiesRepository {
  FirebaseDatabase database;

  FirebaseFacilitiesRepository({required this.database});

  @override
  Future<bool> addFacility(Facility facility) async {
    try {
      final ref = database.reference().child('facilities').child(facility.id);
      await ref.set(facility.toJson());
      return true;
    } catch (e) {
      print('Error in addFacility: $e');
      return false;
    }
  }

  @override
  Future<List<Facility>> getAllFacilities() async {
    try {
      final ref = database.reference().child('facilities');
      var snapshot = await ref.once();
      if (snapshot.value == null) {
        return [];
      }
      final facilitiesData = snapshot.value as Map<dynamic, dynamic>;
      List<Facility> facilities = [];
      for (var facilityData in facilitiesData.values) {
        facilities.add(Facility.fromJson(facilityData));
      }
      return facilities;
    } catch (e) {
      print('Error in getAllFacilities: $e');
      return [];
    }
  }

  @override
  Future<Facility?> getFacilityByID(String id) async {
    try {
      final ref = database.reference().child('facilities').child(id);
      var snapshot = await ref.get();
      if (snapshot.value == null) return null;
      final facilityData = snapshot.value as dynamic;
      return Facility.fromJson(facilityData);
    } catch (e) {
      print('Error in getFacilityByID: $e');
      return null;
    }
  }

  @override
  Future<bool> updateFacility(Facility facility) async {
    try {
      final ref = database.reference().child('facilities').child(facility.id);
      await ref.set(facility.toJson());
      return true;
    } catch (e) {
      print('Error in updateFacility: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteFacility(String id) async {
    try {
      final ref = database.reference().child('facilities').child(id);
      await ref.remove();
      return true;
    } catch (e) {
      print('Error in deleteFacility: $e');
      return false;
    }
  }

  @override
  Future<Facility?> facilityExists(String name, String address) async {
    try {
      final ref = database.reference().child('facilities');
      final snapshot = await ref.once();

      if (snapshot.value == null) return null;

      final facilitiesData = snapshot.value as Map<dynamic, dynamic>;

      for (var facilityData in facilitiesData.values) {
        final facilityMap = Map<String, dynamic>.from(facilityData as Map);
        Facility facility = Facility.fromJson(facilityMap);

        if (name.toLowerCase() == facility.name.toLowerCase() &&
            address.toLowerCase() == facility.address.toLowerCase()) {
          return facility;
        }
      }

      return null;
    } catch (e) {
      print('Error in facilityExists: $e');
      return null;
    }
  }
}
