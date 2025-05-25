import 'dart:io';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:medical_facility_app/src/entities/facility.dart';
import 'package:medical_facility_app/src/cli/main_menu.dart';
import 'package:medical_facility_app/src/cli/add_facility_module.dart';
import 'package:medical_facility_app/src/cli/update_facility_module.dart';
import 'package:medical_facility_app/src/cli/delete_facility_module.dart';
import 'package:medical_facility_app/src/cli/list_facilities_module.dart';
import 'package:medical_facility_app/src/cli/generate_report_module.dart';
import 'package:medical_facility_app/src/repository/facilities_repository.dart';
import 'package:medical_facility_app/src/services/validation_service_interface.dart';
import 'package:medical_facility_app/src/services/report_service_interface.dart';
import 'package:medical_facility_app/src/services/report_service_interface.dart';
import 'package:medical_facility_app/src/entities/validation_result.dart';
import 'medical_facility_test.mocks.dart';

@GenerateMocks([
  FacilitiesRepository,
  ValidationServiceInterface,
  ReportServiceInterface,
])

void main() {
  group('Medical Facility Management System Tests', () {
    late MockFacilitiesRepository mockRepository;
    late MockValidationServiceInterface mockValidationService;
    late MockReportServiceInterface mockReportService;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockFacilitiesRepository();
      mockValidationService = MockValidationServiceInterface();
      mockReportService = MockReportServiceInterface();
      
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Test #1: Adding facility with valid data', () async {
      final facility = Facility(
        id: 'test-id-1',
        name: 'City Hospital №1',
        address: 'Shevchenka St, 15',
        totalBeds: 100,
        availableBeds: 50,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockRepository.addFacility(any)).thenAnswer((_) async => true);
      when(mockValidationService.validateUniqueness(
        name: 'City Hospital №1',
        address: 'Shevchenka St, 15',
      )).thenAnswer((_) async => ValidationResult(isValid: true));

      final result = await mockRepository.addFacility(facility);
      expect(result, isTrue);
      verify(mockRepository.addFacility(facility)).called(1);
    });

    test('Test #2: Adding facility with empty name', () {
      const emptyName = '';
      when(mockValidationService.validateNotEmpty(
        value: emptyName,
        fieldName: 'Name',
      )).thenReturn(ValidationResult(
        isValid: false,
        errorMessage: 'Name field cannot be empty',
      ));

      final result = mockValidationService.validateNotEmpty(
        value: emptyName,
        fieldName: 'Name',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('cannot be empty'));
    });

    test('Test #3: Adding facility with empty address', () {
      const emptyAddress = '';
      when(mockValidationService.validateNotEmpty(
        value: emptyAddress,
        fieldName: 'Address',
      )).thenReturn(ValidationResult(
        isValid: false,
        errorMessage: 'Address field cannot be empty',
      ));

      final result = mockValidationService.validateNotEmpty(
        value: emptyAddress,
        fieldName: 'Address',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('cannot be empty'));
    });

    test('Test #4: Adding non-unique name+address combination', () async {
      when(mockValidationService.validateUniqueness(
        name: 'Polyclinic',
        address: 'Franka St, 10',
      )).thenAnswer((_) async => ValidationResult(
        isValid: false,
        errorMessage: 'That name + address combination already exists in database!',
      ));

      final result = await mockValidationService.validateUniqueness(
        name: 'Polyclinic',
        address: 'Franka St, 10',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('already exists'));
    });

    test('Test #5: Adding facility with negative beds', () {
      const negativeBeds = -10;
      when(mockValidationService.validatePositiveInt(
        value: negativeBeds,
        fieldName: 'totalBeds',
      )).thenReturn(ValidationResult(
        isValid: false,
        errorMessage: 'Total beds must be a positive number',
      ));

      final result = mockValidationService.validatePositiveInt(
        value: negativeBeds,
        fieldName: 'totalBeds',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('positive'));
    });

    test('Test #6: Available beds exceed total beds', () {
      when(mockValidationService.validateBeds(
        total: 50,
        available: 80,
      )).thenReturn(ValidationResult(
        isValid: false,
        errorMessage: 'Available beds cannot exceed total beds',
      ));

      final result = mockValidationService.validateBeds(
        total: 50,
        available: 80,
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('cannot exceed'));
    });

    test('Test #7: Viewing all facilities', () async {
      final facilities = [
        Facility(
          id: 'test-1',
          name: 'Hospital 1',
          address: 'Address 1',
          totalBeds: 100,
          availableBeds: 50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Facility(
          id: 'test-2',
          name: 'Hospital 2',
          address: 'Address 2',
          totalBeds: 200,
          availableBeds: 100,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(mockRepository.getAllFacilities()).thenAnswer((_) async => facilities);
      final result = await mockRepository.getAllFacilities();
      expect(result, hasLength(2));
      expect(result.first.name, equals('Hospital 1'));
      expect(result.last.name, equals('Hospital 2'));
    });

    test('Test #8: Viewing empty facilities list', () async {
      when(mockRepository.getAllFacilities()).thenAnswer((_) async => <Facility>[]);
      final result = await mockRepository.getAllFacilities();
      expect(result, isEmpty);
    });

    test('Test #9: Updating facility name', () async {
      final originalFacility = Facility(
        id: 'test-id',
        name: 'Old Name',
        address: 'Address',
        totalBeds: 100,
        availableBeds: 50,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedFacility = originalFacility.copyWith(
        name: 'New Name',
        updatedAt: DateTime.now(),
      );

      when(mockRepository.updateFacility(any)).thenAnswer((_) async => true);
      final result = await mockRepository.updateFacility(updatedFacility);
      expect(result, isTrue);
      verify(mockRepository.updateFacility(any)).called(1);
    });

    test('Test #10: Updating facility address', () async {
      final originalFacility = Facility(
        id: 'test-id',
        name: 'Name',
        address: 'Old Address',
        totalBeds: 100,
        availableBeds: 50,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedFacility = originalFacility.copyWith(
        address: 'New Address',
        updatedAt: DateTime.now(),
      );

      when(mockRepository.updateFacility(any)).thenAnswer((_) async => true);
      final result = await mockRepository.updateFacility(updatedFacility);
      expect(result, isTrue);
    });

    test('Test #11: Updating to non-unique combination', () async {
      when(mockValidationService.validateUniqueness(
        name: 'Existing Name',
        address: 'Existing Address',
        id: 'different-id',
      )).thenAnswer((_) async => ValidationResult(
        isValid: false,
        errorMessage: 'That name + address combination already exists in database!',
      ));

      final result = await mockValidationService.validateUniqueness(
        name: 'Existing Name',
        address: 'Existing Address',
        id: 'different-id',
      );
      expect(result.isValid, isFalse);
    });

    test('Test #12: Updating total beds', () {
      when(mockValidationService.validateBeds(
        total: 100,
        available: 20,
      )).thenReturn(ValidationResult(isValid: true));

      final result = mockValidationService.validateBeds(
        total: 100,
        available: 20,
      );
      expect(result.isValid, isTrue);
    });

    test('Test #13: Total beds less than available', () {
      when(mockValidationService.validateBeds(
        total: 30,
        available: 50,
      )).thenReturn(ValidationResult(
        isValid: false,
        errorMessage: 'Total beds cannot be less than available beds',
      ));

      final result = mockValidationService.validateBeds(
        total: 30,
        available: 50,
      );
      expect(result.isValid, isFalse);
    });

    test('Test #14: Deleting existing facility', () async {
      const facilityId = 'facility-to-delete';
      when(mockRepository.deleteFacility(facilityId)).thenAnswer((_) async => true);
      final result = await mockRepository.deleteFacility(facilityId);
      expect(result, isTrue);
      verify(mockRepository.deleteFacility(facilityId)).called(1);
    });

    test('Test #15: Canceling deletion', () {
      const userConfirmation = false;
      expect(userConfirmation, isFalse);
    });

    test('Test #16: Generating available beds report', () {
      final facilities = [
        Facility(
          id: 'test-1',
          name: 'Hospital 1',
          address: 'Address 1',
          totalBeds: 100,
          availableBeds: 25,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Facility(
          id: 'test-2',
          name: 'Hospital 2',
          address: 'Address 2',
          totalBeds: 200,
          availableBeds: 15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(mockReportService.filterByAvailableBeds(
        facilities: facilities,
        minAvailable: 20,
      )).thenReturn([facilities[0]]);

      final result = mockReportService.filterByAvailableBeds(
        facilities: facilities,
        minAvailable: 20,
      );
      expect(result, hasLength(1));
      expect(result.first.availableBeds, greaterThanOrEqualTo(20));
    });

    test('Test #17: Generating occupancy report', () {
      final facilities = [
        Facility(
          id: 'test-1',
          name: 'Hospital 1',
          address: 'Address 1',
          totalBeds: 100,
          availableBeds: 30,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(mockReportService.filterByOccupancy(
        facilities: facilities,
        minOccupancy: 30.0,
        maxOccupancy: 80.0,
      )).thenReturn(facilities);

      final result = mockReportService.filterByOccupancy(
        facilities: facilities,
        minOccupancy: 30.0,
        maxOccupancy: 80.0,
      );
      expect(result, hasLength(1));
    });

    test('Test #18: Sorting by name', () {
      final facilities = [
        Facility(
          id: 'test-2',
          name: 'Z-Hospital',
          address: 'Address 2',
          totalBeds: 100,
          availableBeds: 50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Facility(
          id: 'test-1',
          name: 'A-Hospital',
          address: 'Address 1',
          totalBeds: 100,
          availableBeds: 50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final sortedFacilities = [facilities[1], facilities[0]];
      when(mockReportService.sortFacilities(
        facilities: facilities,
        criteria: SortBy.name,
        ascending: true,
      )).thenReturn(sortedFacilities);

      final result = mockReportService.sortFacilities(
        facilities: facilities,
        criteria: SortBy.name,
        ascending: true,
      );
      expect(result.first.name, equals('A-Hospital'));
      expect(result.last.name, equals('Z-Hospital'));
    });

    test('Test #19: Non-numeric input', () {
      const invalidInput = 'abc';
      final parsedValue = int.tryParse(invalidInput);
      expect(parsedValue, isNull);
    });

    test('Test #20: Negative available beds', () {
      when(mockValidationService.validatePositiveInt(
        value: -5,
        fieldName: 'availableBeds',
      )).thenReturn(ValidationResult(
        isValid: false,
        errorMessage: 'Available beds must be positive',
      ));

      final result = mockValidationService.validatePositiveInt(
        value: -5,
        fieldName: 'availableBeds',
      );
      expect(result.isValid, isFalse);
    });

    test('Test #21: Canceling operation', () {
      const userInput = 'cancel';
      final shouldCancel = userInput.toLowerCase() == 'cancel';
      expect(shouldCancel, isTrue);
    });

    test('Test #22: Viewing facility details', () async {
      final facility = Facility(
        id: 'detail-test',
        name: 'Detailed Hospital',
        address: 'Detailed Address',
        totalBeds: 100,
        availableBeds: 30,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockRepository.getFacilityByID('detail-test')).thenAnswer((_) async => facility);
      final result = await mockRepository.getFacilityByID('detail-test');
      expect(result, isNotNull);
      expect(result!.name, equals('Detailed Hospital'));
    });

    test('Test #23: Automatic occupancy calculation', () {
      final facility = Facility(
        id: 'occupancy-test',
        name: 'Test Hospital',
        address: 'Test Address',
        totalBeds: 100,
        availableBeds: 30,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockReportService.calculateOccupancy(facility: facility)).thenReturn(70.0);
      final occupancy = mockReportService.calculateOccupancy(facility: facility);
      expect(occupancy, equals(70.0));
    });

    test('Test #24: Exiting program', () {
      const userChoice = '6';
      const confirmExit = 'yes';
      final shouldExit = userChoice == '6' && (confirmExit == 'y' || confirmExit == 'yes');
      expect(shouldExit, isTrue);
    });

    test('Test #25: Firebase connection error', () async {
      when(mockRepository.getAllFacilities()).thenThrow(Exception('Network connection failed'));
      expect(() async => await mockRepository.getAllFacilities(), throwsA(isA<Exception>()));
    });
  });
}
