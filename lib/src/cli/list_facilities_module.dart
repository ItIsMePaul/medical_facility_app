import 'dart:io';

import 'package:medical_facility_app/src/entities/facility.dart';
import 'package:medical_facility_app/src/providers/report_provider.dart';
import 'package:medical_facility_app/src/providers/repository_provider.dart';
import 'package:medical_facility_app/src/providers/table_formatter_provider.dart';
import 'package:riverpod/riverpod.dart';

class ListFacilitiesModule {
  final ProviderContainer container;

  ListFacilitiesModule({required this.container});

  Future<void> run() async {
    try {
      bool exitRequested = false;
      while (!exitRequested) {
        await clearScreen();
        final facilities = await fetchFacilities();
        if (facilities.isEmpty) {
          print('No facilities found.');
          print('Press Enter to return to the main menu...');
          stdin.readLineSync();
          return;
        } else {
          displayFacilities(facilities);
          int input = await handleUserInput();
          if (input == 0) {
            exitRequested = true;
          } else {
            if (input > 0 && input <= facilities.length) {
              await showFacilityDetails(facilities[input - 1]);
              print('Press Enter to return to the list...');
              stdin.readLineSync();
            } else {
              print('Invalid facility number');
              await Future.delayed(Duration(seconds: 1));
            }
          }
        }
      }
    } catch (e) {
      print('Error: $e');
      print('Press Enter to return to main menu...');
      stdin.readLineSync();
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
    print('  Enter facility number to view details');
    print('  0 - Return to main menu');
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

  Future<int> handleUserInput() async {
    while (true) {
      int? userInput = int.tryParse(stdin.readLineSync() ?? '');
      if (userInput == null) {
        print('Invalid input! Please input number!');
      } else {
        return userInput;
      }
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

  Future<void> showFacilityDetails(Facility facility) async {
    final service = container.read(reportServiceProvider);
    await clearScreen();
    print('=' * 40);
    print('FACILITY DETAILS');
    print('=' * 40);
    print('Name: ${facility.name}');
    print('Address: ${facility.address}');
    print('Total Beds: ${facility.totalBeds}');
    print('Available Beds: ${facility.availableBeds}');
    print('Occupancy: ${service.calculateOccupancy(facility: facility)}');
    print('=' * 40);
  }
}
