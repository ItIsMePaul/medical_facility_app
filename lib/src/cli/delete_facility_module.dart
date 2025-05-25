import 'dart:io';

import 'package:medical_facility_app/src/providers/repository_provider.dart';
import 'package:medical_facility_app/src/providers/table_formatter_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../entities/facility.dart';

class DeleteFacilityModule {
  final ProviderContainer container;

  DeleteFacilityModule({required this.container});

  Future<void> run() async {
    try {
      await clearScreen();
      final facilities = await fetchFacilities();
      if (facilities.isEmpty) {
        print('No facilities available to delete.');
        print('Press Enter to return to main menu...');
        stdin.readLineSync();
        return;
      }
      displayFacilities(facilities);
      int index = await selectFacility(facilities.length);
      if (index == 0) return;
      Facility facility = facilities[index - 1];
      bool confirmed = await confirmDeletion(facility);
      if (confirmed) {
        bool result = await deleteFacility(facility);
        displayResult(success: result, facilityName: facility.name);
      } else {
        print('Deletion is canceled! Press Enter to return to main menu...');
        stdin.readLineSync();
      }
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
    print('WARNING: Deletion is permanent and cannot be undone!');
    print('=' * 40);
    print('Options:');
    print('  Enter facility number to delete');
    print('  0 - Return to main menu');
  }

  Future<int> selectFacility(int amountOfElements) async {
    try {
      while (true) {
        String? inputStr = await readUserInput(
          prompt: 'Enter facility number to delete (or 0 to return)',
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

  Future<bool> confirmDeletion(Facility facility) async {
    try {
      await clearScreen();
      print('=' * 40);
      print('DELETING FACILITY - CONFIRMATION');
      print('=' * 40);
      print('You are about to delete the following facility:');
      print('Name: ${facility.name}');
      print('Address: ${facility.address}');
      print('Total Beds: ${facility.totalBeds}');
      print('Available Beds: ${facility.availableBeds}');
      print('=' * 40);
      print('WARNING: This action cannot be undone!');
      print('=' * 40);
      String? input = await readUserInput(
        prompt: 'Type "DELETE" to confirm deletion or anything else to cancel',
      );
      return input != null && input.toUpperCase().trim() == 'DELETE';
    } catch (e) {
      print('Error during confirmation: $e');
      return false;
    }
  }

  Future<bool> deleteFacility(Facility facility) async {
    try {
      final repository = container.read(repositoryProvider).value;
      if (repository == null) {
        print('Repository is not initialized');
        return false;
      }
      bool result = await repository.deleteFacility(facility.id);
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
      print('Facility $facilityName was deleted!');
    } else {
      print('Facility $facilityName was not deleted!');
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
