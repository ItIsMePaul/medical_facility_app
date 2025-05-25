import 'package:medical_facility_app/src/entities/facility.dart';
import 'package:medical_facility_app/src/services/report_service_interface.dart';

class FacilityReportService implements ReportServiceInterface {
  @override
  double calculateOccupancy({required Facility facility}) {
    int totalBeds = facility.totalBeds;
    int availableBeds = facility.availableBeds;
    if (totalBeds == 0.0) {
      print('totalBeds cannot be zero!');
      return 0.0;
    }
    return (totalBeds - availableBeds) / totalBeds * 100;
  }

  @override
  List<Facility> filterByAvailableBeds({
    required List<Facility> facilities,
    required int minAvailable,
  }) {
    if (minAvailable < 0) {
      print('minAvailable cannot be negative!');
      return [];
    }
    if (facilities.isEmpty) {
      print('facilities is empty!');
      return [];
    }
    return facilities
        .where((facility) => facility.availableBeds >= minAvailable)
        .toList();
  }

  @override
  List<Facility> filterByOccupancy({
    required List<Facility> facilities,
    double minOccupancy = 0.0,
    double maxOccupancy = 100.0,
  }) {
    if (minOccupancy < 0.0 || minOccupancy > 100.0) {
      print('minOccupancy should be in range 0...100 %!');
      return [];
    }
    if (maxOccupancy < 0.0 || maxOccupancy > 100.0) {
      print('maxOccupancy should be in range 0...100 %!');
      return [];
    }
    if (minOccupancy > maxOccupancy) {
      print('minOccupancy cannot be greater than maxOccupancy!');
      return [];
    }
    if (facilities.isEmpty) {
      print('facilities is empty!');
      return [];
    }
    return facilities
        .where(
          (facility) =>
              calculateOccupancy(facility: facility) >= minOccupancy &&
              calculateOccupancy(facility: facility) <= maxOccupancy,
        )
        .toList();
  }

  @override
  List<Facility> sortFacilities({
    required List<Facility> facilities,
    required SortBy criteria,
    bool ascending = true,
  }) {
    switch (criteria) {
      case SortBy.name:
        if (ascending) {
          facilities.sort((a, b) => a.name.compareTo(b.name));
        } else {
          facilities.sort((a, b) => b.name.compareTo(a.name));
        }
        break;
      case SortBy.address:
        if (ascending) {
          facilities.sort((a, b) => a.address.compareTo(b.address));
        } else {
          facilities.sort((a, b) => b.address.compareTo(a.address));
        }
        break;
      case SortBy.totalBeds:
        if (ascending) {
          facilities.sort((a, b) => a.totalBeds.compareTo(b.totalBeds));
        } else {
          facilities.sort((a, b) => b.totalBeds.compareTo(a.totalBeds));
        }
        break;
      case SortBy.availableBeds:
        if (ascending) {
          facilities.sort((a, b) => a.availableBeds.compareTo(b.availableBeds));
        } else {
          facilities.sort((a, b) => b.availableBeds.compareTo(a.availableBeds));
        }
        break;
      case SortBy.occupancy:
        if (ascending) {
          facilities.sort(
            (a, b) => calculateOccupancy(
              facility: a,
            ).compareTo(calculateOccupancy(facility: b)),
          );
        } else {
          facilities.sort(
            (a, b) => calculateOccupancy(
              facility: b,
            ).compareTo(calculateOccupancy(facility: a)),
          );
        }
        break;
    }
    return facilities;
  }
}
