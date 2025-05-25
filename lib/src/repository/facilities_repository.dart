import '../entities/facility.dart';

abstract class FacilitiesRepository {
  Future<bool> addFacility(Facility facility);

  Future<Facility?> getFacilityByID(String id);

  Future<List<Facility>> getAllFacilities();

  Future<bool> updateFacility(Facility facility);

  Future<bool> deleteFacility(String id);

  Future<Facility?> facilityExists(String name, String address);
}
