import 'dart:io';

import 'package:medical_facility_app/src/providers/repository_provider.dart';
import 'package:medical_facility_app/src/providers/table_formatter_provider.dart';
import 'package:medical_facility_app/src/providers/validation_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../entities/facility.dart';

class UpdateFacilityModule {
  final ProviderContainer container;

  UpdateFacilityModule({required this.container});

  Future<void> run() async {
    try {
      await clearScreen();
      final facilities = await fetchFacilities();
      if (facilities.isEmpty) {
        print('No facilities available to update.');
        print('Press Enter to return to main menu...');
        stdin.readLineSync();
        return;
      }
      displayFacilities(facilities);
      int index = await selectFacility(facilities.length);
      if (index == 0) return;
      Facility facility = await updateFacilityData(facilities[index - 1]);
      facility = facility.copyWith(updatedAt: DateTime.now());
      bool result = await saveFacility(facility);
      displayResult(success: result, facilityName: facility.name);
      return;
    } catch (e) {
      print('Error: $e');
      print('Press Enter to return to main menu...');
      stdin.readLineSync();
    }
  }

  Future<List<Facility>> fetchFacilities() async {
    try {
      final repository = container.read(repositoryProvider).value;
      if (repository == null) {
        print('Repository is not initialized');
        return [];
      }
      final facilities = await repository.getAllFacilities();
      facilities.sort((a, b) => a.name.compareTo(b.name));
      return facilities;
    } catch (e) {
      print('Error fetching facilities: $e');
      return [];
    }
  }

  void displayFacilities(List<Facility> facilities) {
    final headers = [
      "№",
      "Name",
      "Address",
      "Total Beds",
      "Available Beds",
      "Occupancy",
    ];
    final properties = [
      "id",
      "name",
      "address",
      "totalBeds",
      "availableBeds",
      "occupancy",
    ];

    final tableFormatter = container.read(tableFormatterProvider);
    String table = tableFormatter.formatTable(
      data: facilities,
      headers: headers,
      properties: properties,
    );
    print(table);
    print('=' * 40);
    print('Total facilities: ${facilities.length}');
    print('=' * 40);
    print('Options:');
    print('  Enter facility number to update');
    print('  0 - Return to main menu');
  }

  Future<int> selectFacility(int amountOfElements) async {
    try {
      while (true) {
        String? inputStr = await readUserInput(
          prompt: 'Enter facility number to update (or 0 to return)',
        );
        if (inputStr == null) return 0;

        int? input = int.tryParse(inputStr);
        if (input == null) {
          print('Please enter a valid number.');
          continue;
        }
        if (input == 0) return 0;
        if (input < 1 || input > amountOfElements) {
          print(
            'Invalid selection. Please enter a number between 1 and $amountOfElements or 0 to return.',
          );
          continue;
        }
        return input;
      }
    } catch (e) {
      print("Error selecting facility: $e");
      return 0;
    }
  }

  Future<Facility> updateFacilityData(Facility facility) async {
    try {
      while (true) {
        await clearScreen();
        print('=' * 40);
        print('UPDATING FACILITY');
        print('=' * 40);
        print('Name: ${facility.name}');
        print('Address: ${facility.address}');
        print('Total Beds: ${facility.totalBeds}');
        print('Available Beds: ${facility.availableBeds}');
        print('=' * 40);
        print('SELECT FIELD TO UPDATE:');
        print('1. Name');
        print('2. Address');
        print('3. Available Beds');
        print('4. Total Beds');
        print('0. Done (Save changes and return)');
        print('=' * 40);
        String? input = await readUserInput(
          prompt: 'Please choose action (0-4)',
        );
        switch (input) {
          case '1':
            String? name = await updateName(facility);
            if (name != null) {
              facility = facility.copyWith(name: name);
              print('Name successfully updated!');
              print('Press Enter to continue...');
              stdin.readLineSync();
            }
            break;
          case '2':
            String? address = await updateAddress(facility);
            if (address != null) {
              facility = facility.copyWith(address: address);
              print('Address successfully updated!');
              print('Press Enter to continue...');
              stdin.readLineSync();
            }
            break;
          case '3':
            int? availableBeds = await updateAvailableBeds(facility);
            if (availableBeds != null) {
              facility = facility.copyWith(availableBeds: availableBeds);
              print('AvailableBeds successfully updated!');
              print('Press Enter to continue...');
              stdin.readLineSync();
            }
            break;
          case '4':
            int? totalBeds = await updateTotalBeds(facility);
            if (totalBeds != null) {
              facility = facility.copyWith(totalBeds: totalBeds);
              print('TotalBeds successfully updated!');
              print('Press Enter to continue...');
              stdin.readLineSync();
            }
            break;
          case '0':
            return facility;
          default:
            print('Invalid option. Please try again.');
            print('Press Enter to continue...');
            stdin.readLineSync();
            break;
        }
      }
    } catch (e) {
      print("Error during updating: $e");
      return facility;
    }
  }

  Future<String?> updateName(Facility facility) async {
    print('Current facility name: ${facility.name}');
    try {
      while (true) {
        String? input = await readUserInput(prompt: 'Enter new facility name');
        if (input == null) return null;
        final service = container.read(validationServiceProvider);
        var result = service.validateNotEmpty(value: input, fieldName: 'name');
        if (!result.isValid) {
          print('${result.errorMessage}. Please try again.');
          continue;
        }
        if (input != facility.name) {
          bool isUnique = await isNameAddressUnique(
            name: input,
            address: facility.address,
            id: facility.id,
          );
          if (!isUnique) {
            continue;
          }
        }
        return input;
      }
    } catch (e) {
      print("Error updating name: $e");
      return null;
    }
  }

  Future<String?> updateAddress(Facility facility) async {
    print('Current facility address: ${facility.address}');
    try {
      while (true) {
        String? input = await readUserInput(
          prompt: 'Enter new facility address',
        );
        if (input == null) return null;
        final service = container.read(validationServiceProvider);
        var result = service.validateNotEmpty(
          value: input,
          fieldName: 'address',
        );
        if (!result.isValid) {
          print('${result.errorMessage}. Please try again.');
          continue;
        }
        if (input != facility.address) {
          bool isUnique = await isNameAddressUnique(
            name: facility.name,
            address: input,
            id: facility.id,
          );
          if (!isUnique) {
            continue;
          }
        }
        return input;
      }
    } catch (e) {
      print("Error updating address: $e");
      return null;
    }
  }

  Future<int?> updateTotalBeds(Facility facility) async {
    print('Current total beds: ${facility.totalBeds}');
    print('Current available beds: ${facility.availableBeds}');
    try {
      while (true) {
        String? input = await readUserInput(
          prompt: 'Enter new total beds count',
        );
        if (input == null) return null;
        int? newTotalBeds = int.tryParse(input);
        if (newTotalBeds == null) {
          print('Please enter a valid number');
          continue;
        }
        final service = container.read(validationServiceProvider);
        var result = service.validatePositiveInt(
          value: newTotalBeds,
          fieldName: 'totalBeds',
        );
        if (!result.isValid) {
          print('${result.errorMessage}. Please try again.');
          continue;
        }
        result = service.validateBeds(
          total: newTotalBeds,
          available: facility.availableBeds,
        );
        if (!result.isValid) {
          print(result.errorMessage);
          print("You may need to update available beds first!");
          continue;
        }
        return newTotalBeds;
      }
    } catch (e) {
      print("Error updating total beds: $e");
      return null;
    }
  }

  Future<int?> updateAvailableBeds(Facility facility) async {
    print('Current total beds: ${facility.totalBeds}');
    print('Current available beds: ${facility.availableBeds}');
    try {
      while (true) {
        String? input = await readUserInput(
          prompt: 'Enter new available beds count',
        );
        if (input == null) return null;
        int? newAvailableBeds = int.tryParse(input);
        if (newAvailableBeds == null) {
          print('Please enter a valid number!');
          continue;
        }
        final service = container.read(validationServiceProvider);
        var result = service.validatePositiveInt(
          value: newAvailableBeds,
          fieldName: 'availableBeds',
        );
        if (!result.isValid) {
          print('${result.errorMessage}. Please try again.');
          continue;
        }
        result = service.validateBeds(
          total: facility.totalBeds,
          available: newAvailableBeds,
        );
        if (!result.isValid) {
          print(result.errorMessage);
          print("You may need to update total beds first!");
          continue;
        }
        return newAvailableBeds;
      }
    } catch (e) {
      print("Error updating available beds: $e");
      return null;
    }
  }

  Future<bool> isNameAddressUnique({
    required String name,
    required String address,
    required String id,
  }) async {
    try {
      final service = container.read(validationServiceProvider);
      final result = await service.validateUniqueness(
        name: name,
        address: address,
        id: id,
      );
      if (result.isValid) {
        return true;
      } else {
        print(result.errorMessage);
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
      if (repository == null) {
        print('Repository is not initialized');
        return false;
      }
      bool result = await repository.updateFacility(facility);
      return result;
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
      print('Facility $facilityName was updated!');
    } else {
      print('Facility $facilityName was not updated!');
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
