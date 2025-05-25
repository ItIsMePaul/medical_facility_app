import 'package:medical_facility_app/src/entities/facility.dart';
import 'package:medical_facility_app/src/repository/facilities_repository.dart';
import 'package:medical_facility_app/src/services/validation_service_interface.dart';

import '../entities/validation_result.dart';

class FacilityValidationService implements ValidationServiceInterface {
  final FacilitiesRepository repository;

  FacilityValidationService(this.repository);

  @override
  ValidationResult validateBeds({required int total, required int available}) {
    if (available > total) {
      return ValidationResult(
        isValid: false,
        errorMessage:
            'The number of available beds cannot be greater than the number of total beds!',
      );
    }
    return ValidationResult(isValid: true);
  }

  @override
  ValidationResult validateNotEmpty({
    required String value,
    String fieldName = 'Variable',
  }) {
    if (value.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: '$fieldName cannot be empty!',
      );
    }
    return ValidationResult(isValid: true);
  }

  @override
  ValidationResult validatePositiveInt({
    required int value,
    String fieldName = 'Variable',
  }) {
    if (value < 0) {
      return ValidationResult(
        isValid: false,
        errorMessage: '$fieldName cannot be negative!',
      );
    }
    return ValidationResult(isValid: true);
  }

  @override
  Future<ValidationResult> validateUniqueness({
    required String name,
    required String address,
    String? id,
  }) async {
    Facility? facility = await repository.facilityExists(name, address);
    if (id == null && facility != null) {
      return ValidationResult(
        isValid: false,
        errorMessage:
            'That name + address combination already exist in database!',
      );
    }
    if (facility != null && id != null && facility.id != id) {
      return ValidationResult(
        isValid: false,
        errorMessage:
            'That name + address combination already exist in database with another ID!',
      );
    }
    return ValidationResult(isValid: true);
  }
}
