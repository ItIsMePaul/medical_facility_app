import 'package:medical_facility_app/src/services/report_service.dart';
import 'package:medical_facility_app/src/services/report_service_interface.dart';
import 'package:riverpod/riverpod.dart';

final reportServiceProvider = Provider<ReportServiceInterface>((ref) {
  return FacilityReportService();
});
