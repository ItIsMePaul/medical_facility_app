import 'dart:io';

import 'package:medical_facility_app/src/providers/repository_provider.dart';
import 'package:medical_facility_app/src/providers/uuid_provider.dart';
import 'package:medical_facility_app/src/providers/validation_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../entities/facility.dart';

class AddFacilityModule {
  final ProviderContainer container;

  AddFacilityModule({required this.container});

  Future<void> run() async {
    try {
      await clearScreen();
      print('Starting facility addition process...');
      Facility? facility = await collectFacilityData();
      if (facility == null) {
        print('Facility data collection was cancelled or failed.');
        print('Press Enter to return to main menu...');
        stdin.readLineSync();
        return;
      }
      print('Facility data collected successfully. Saving...');
      bool result = await saveFacility(facility);
      displayResult(success: result, facilityName: facility.name);
      return;
    } catch (e) {
      print('Error: $e');
      print('Press Enter to return to main menu...');
      stdin.readLineSync();
    }
  }

  Future<Facility?> collectFacilityData() async {
    try {
      final uuid = container.read(uuidProvider);
      print('Collecting name...');
      String? name = await collectName();
      if (name == null) {
        print('Name collection cancelled.');
        return null;
      }
      print('Name collected: $name');
      print('Collecting address...');
      String? address = await collectAddress();
      if (address == null) {
        print('Address collection cancelled.');
        return null;
      }
      print('Address collected: $address');
      print('Validating uniqueness...');
      bool isUnique = await validateUniqueness(name: name, address: address);
      if (!isUnique) {
        print('Uniqueness validation failed.');
        return null;
      }
      print('Uniqueness validated.');
      print('Collecting totalBeds...');
      int? totalBeds = await collectTotalBeds();
      if (totalBeds == null) {
        print('TotalBeds collection cancelled.');
        return null;
      }
      print('TotalBeds collected: $totalBeds');
      int? availableBeds = await collectAvailableBeds(totalBeds);
      if (availableBeds == null) {
        print('AvailableBeds collection cancelled.');
        return null;
      }
      print('AvailableBeds collected: $availableBeds');
      return Facility(
        id: uuid.generateV1(),
        name: name,
        address: address,
        totalBeds: totalBeds,
        availableBeds: availableBeds,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> collectName() async {
    try {
      while (true) {
        final service = container.read(validationServiceProvider);
        final input = await readUserInput(
          prompt: 'Please enter the name of the facility',
        );
        if (input == null) {
          print('Input cancelled!');
          return null;
        }
        final result = service.validateNotEmpty(
          value: input,
          fieldName: 'Name',
        );
        if (result.isValid) {
          return input;
        } else {
          print('${result.errorMessage}. Please try again.');
        }
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  Future<String?> collectAddress() async {
    try {
      while (true) {
        final service = container.read(validationServiceProvider);
        final input = await readUserInput(
          prompt: 'Please enter the address of the facility',
        );
        if (input == null) {
          print('Input cancelled!');
          return null;
        }
        final result = service.validateNotEmpty(
          value: input,
          fieldName: 'Address',
        );
        if (result.isValid) {
          return input;
        } else {
          print('${result.errorMessage}. Please try again.');
        }
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  Future<int?> collectTotalBeds() async {
    try {
      while (true) {
        final service = container.read(validationServiceProvider);
        final input = await readUserInput(
          prompt:
              'Please enter the total number of beds (must be a positive integer):',
        );
        if (input == null) {
          print('Input cancelled!');
          return null;
        }
        int? totalBeds = int.tryParse(input);
        if (totalBeds == null) {
          print('The entered value should be integer!');
          continue;
        }
        final result = service.validatePositiveInt(
          value: totalBeds,
          fieldName: 'totalBeds',
        );
        if (result.isValid) {
          return totalBeds;
        } else {
          print('${result.errorMessage}. Please try again.');
        }
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  Future<int?> collectAvailableBeds(int totalBeds) async {
    try {
      while (true) {
        final service = container.read(validationServiceProvider);
        final input = await readUserInput(
          prompt:
              'Please enter the total number of available beds (out of $totalBeds, must be a positive integer or zero):',
        );
        if (input == null) {
          print('Input cancelled!');
          return null;
        }
        int? availableBeds = int.tryParse(input);
        if (availableBeds == null) {
          print('The entered value should be integer!');
          continue;
        }
        final result1 = service.validatePositiveInt(
          value: availableBeds,
          fieldName: 'availableBeds',
        );
        final result2 = service.validateBeds(
          total: totalBeds,
          available: availableBeds,
        );
        if (result1.isValid && result2.isValid) {
          return availableBeds;
        } else {
          List<String> errors = [];
          if (!result1.isValid) errors.add(result1.errorMessage!);
          if (!result2.isValid) errors.add(result2.errorMessage!);
          print('${errors.join(". ")}. Please try again.');
        }
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  Future<bool> validateUniqueness({
    required String name,
    required String address,
  }) async {
    try {
      final service = container.read(validationServiceProvider);
      final result = await service.validateUniqueness(
        name: name,
        address: address,
      );
      print('Uniqueness result: ${result.isValid}');
      if (result.isValid) {
        return true;
      } else {
        print('Error: ${result.errorMessage}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> saveFacility(Facility facility) async {
    try {
      final repository = container.read(repositoryProvider).value;
      bool? result = await repository?.addFacility(facility);
      if (result == null || !result) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> displayResult({
    required bool success,
    required String facilityName,
  }) async {
    if (success) {
      print('Facility $facilityName was saved!');
    } else {
      print('Facility $facilityName was not saved!');
    }
    print('Press Enter to return to main menu...');
    stdin.readLineSync();
  }

  Future<String?> readUserInput({
    required String prompt,
    bool allowEmpty = false,
  }) async {
    while (true) {
      print('$prompt, (type "cancel" to abort):');
      String userInput = stdin.readLineSync() ?? '';
      if (!allowEmpty && userInput.trim().isEmpty) {
        print('Input can\'t be empty!');
        continue;
      }
      if (userInput.trim().toLowerCase() == 'cancel') {
        return null;
      }
      return userInput.trim();
    }
  }

  Future<void> clearScreen() async {
    try {
      if (Platform.isWindows) {
        final result = await Process.run('cmd', [
          '/c',
          'cls',
        ], runInShell: true);
        if (result.exitCode != 0) {
          throw Exception('cls command failed');
        }
      } else {
        final result = await Process.run('clear', [], runInShell: true);
        if (result.exitCode != 0) {
          throw Exception('clear command failed');
        }
      }
    } catch (e) {
      try {
        stdout.write('\x1B[2J\x1B[H');
        await stdout.flush();
      } catch (e2) {
        print('\n' * 50);
      }
    }
  }
}
