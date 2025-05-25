import '../entities/validation_result.dart';

abstract class ValidationServiceInterface {
  ValidationResult validateNotEmpty({
    required String value,
    String fieldName = 'Variable',
  });
  ValidationResult validatePositiveInt({
    required int value,
    String fieldName = 'Variable',
  });
  ValidationResult validateBeds({required int total, required int available});
  Future<ValidationResult> validateUniqueness({
    required String name,
    required String address,
    String? id,
  });
}
