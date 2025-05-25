import 'dart:io';

import 'package:medical_facility_app/src/providers/report_provider.dart';
import 'package:medical_facility_app/src/providers/repository_provider.dart';
import 'package:medical_facility_app/src/providers/table_formatter_provider.dart';
import 'package:medical_facility_app/src/services/report_service_interface.dart';
import 'package:riverpod/riverpod.dart';

import '../entities/facility.dart';

class GenerateReportModule {
  final ProviderContainer container;

  GenerateReportModule({required this.container});

  Future<void> run() async {
    try {
      await clearScreen();
      displayMenu();
      while (true) {
        String? inputStr = await readUserInput(
          prompt: 'Enter your choice (0-3)',
        );
        inputStr ??= '0';
        switch (inputStr) {
          case '0':
            print('Report generation is canceled.');
            print('Press Enter to return to main menu...');
            stdin.readLineSync();
            return;
          case '1':
            List<Facility> facilities = await generateReportByAvailableBeds();
            displayFacilities(facilities);
            break;
          case '2':
            List<Facility> facilities = await generateReportByOccupancy();
            displayFacilities(facilities);
            break;
          case '3':
            List<Facility> facilities = await generateSortedReport();
            displayFacilities(facilities);
            break;
          default:
            print('Invalid input! Please make correct choice!');
        }
      }
    } catch (e) {
      print('Error: $e');
      print('Press Enter to return to main menu...');
      stdin.readLineSync();
    }
  }

  void displayMenu() {
    print('=' * 40);
    print('REPORT GENERATION'.padLeft(12));
    print('=' * 40);
    print('Please select the type of report:');
    print('1. Facilities with at least N available beds');
    print('2. Facilities by occupancy percentage range');
    print('3. Sorted facilities list');
    print('0. Return to main menu');
    print('-' * 40);
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

  Future<List<Facility>> generateReportByAvailableBeds() async {
    try {
      final service = container.read(reportServiceProvider);
      int? minAvailable;
      while (true) {
        String? input = await readUserInput(
          prompt: 'Enter minimum available beds amount:',
        );
        if (input == null) return [];
        minAvailable = int.tryParse(input);
        if (minAvailable == null || minAvailable < 0) {
          print('Please enter a non-negative number!');
          continue;
        }
        break;
      }
      List<Facility> facilities = service.filterByAvailableBeds(
        facilities: await fetchFacilities(),
        minAvailable: minAvailable,
      );
      return facilities;
    } catch (e) {
      print('Error generating report: $e');
      return [];
    }
  }

  Future<List<Facility>> generateReportByOccupancy() async {
    try {
      final service = container.read(reportServiceProvider);
      double? minimal;
      double? maximum;
      while (true) {
        String? input = await readUserInput(
          prompt: 'Enter minimal occupancy (in range: 0 - 100%)',
        );
        if (input == null) return [];
        minimal = double.tryParse(input);
        if (minimal == null || minimal < 0 || minimal > 100) {
          print('Please enter a number between 0 and 100!');
          continue;
        }
        break;
      }
      while (true) {
        String? input = await readUserInput(
          prompt: 'Enter maximum occupancy (in range: 0 - 100%)',
        );
        if (input == null) return [];
        maximum = double.tryParse(input);
        if (maximum == null || maximum < 0 || maximum > 100) {
          print('Please enter a number between 0 and 100!');
          continue;
        }
        if (maximum < minimal) {
          print(
            'Maximum occupancy must be greater than or equal to minimal occupancy!',
          );
          continue;
        }
        break;
      }
      final allFacilities = await fetchFacilities();
      List<Facility> facilities = service.filterByOccupancy(
        facilities: allFacilities,
        minOccupancy: minimal,
        maxOccupancy: maximum,
      );
      return facilities;
    } catch (e) {
      print('Error generating report: $e');
      return [];
    }
  }

  Future<List<Facility>> generateSortedReport() async {
    try {
      final service = container.read(reportServiceProvider);
      final allFacilities = await fetchFacilities();
      SortBy criteria;
      bool ascending;
      while (true) {
        print(
          'Sort by: 1-Name, 2-Address, 3-Total Beds, 4-Available Beds, 5-Occupancy',
        );
        String? input = await readUserInput(
          prompt: 'Enter sort criteria (1-5)',
        );
        if (input == null) return [];
        switch (input) {
          case '1':
            criteria = SortBy.name;
            break;
          case '2':
            criteria = SortBy.address;
            break;
          case '3':
            criteria = SortBy.totalBeds;
            break;
          case '4':
            criteria = SortBy.availableBeds;
            break;
          case '5':
            criteria = SortBy.occupancy;
            break;
          default:
            print('please enter valid criteria');
            continue;
        }
        break;
      }
      while (true) {
        print('Sort by: 1-ascending, 2-descending');
        String? input = await readUserInput(prompt: 'Enter sort order (1-2)');
        if (input == null) return [];
        switch (input) {
          case '1':
            ascending = true;
            break;
          case '2':
            ascending = false;
            break;
          default:
            print('please enter valid order');
            continue;
        }
        break;
      }

      List<Facility> facilities = service.sortFacilities(
        facilities: allFacilities,
        criteria: criteria,
        ascending: ascending,
      );
      return facilities;
    } catch (e) {
      print('Error generating report: $e');
      return [];
    }
  }

  void displayFacilities(List<Facility> facilities) {
    if (facilities.isEmpty) {
      print('No facilities found for this report.');
      print('Press Enter to return to main menu...');
      stdin.readLineSync();
      return;
    }
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
