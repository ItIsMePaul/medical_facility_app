import 'package:medical_facility_app/src/providers/repository_provider.dart';
import 'package:medical_facility_app/src/services/validation_service.dart';
import 'package:medical_facility_app/src/services/validation_service_interface.dart';
import 'package:riverpod/riverpod.dart';

final validationServiceProvider = Provider<ValidationServiceInterface>((ref) {
  final repositoryAsync = ref.watch(repositoryProvider);
  return repositoryAsync.when(
    data: (repository) => FacilityValidationService(repository),
    loading: () => throw Exception('Repository is loading'),
    error: (error, stack) => throw Exception('Repository error: $error'),
  );
});
