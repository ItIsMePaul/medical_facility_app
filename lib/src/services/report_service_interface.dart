import '../entities/facility.dart';

abstract class ReportServiceInterface {
  double calculateOccupancy({required Facility facility});

  List<Facility> filterByAvailableBeds({
    required List<Facility> facilities,
    required int minAvailable,
  });

  List<Facility> filterByOccupancy({
    required List<Facility> facilities,
    double minOccupancy = 0.0,
    double maxOccupancy = 100.0,
  });

  List<Facility> sortFacilities({
    required List<Facility> facilities,
    required SortBy criteria,
    bool ascending = true,
  });
}

enum SortBy { name, address, totalBeds, availableBeds, occupancy }
