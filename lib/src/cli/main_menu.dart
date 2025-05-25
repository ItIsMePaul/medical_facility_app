import 'dart:io';

import 'package:medical_facility_app/src/cli/delete_facility_module.dart';
import 'package:medical_facility_app/src/cli/generate_report_module.dart';
import 'package:medical_facility_app/src/cli/list_facilities_module.dart';
import 'package:medical_facility_app/src/cli/update_facility_module.dart';
import 'package:riverpod/riverpod.dart';

import 'add_facility_module.dart';

class MainMenu {
  final ProviderContainer container;

  MainMenu({required this.container});

  Future<void> run() async {
    try {
      bool exitRequested = false;
      while (!exitRequested) {
        await clearScreen();
        displayMenu();
        String input = await readUserInput(validPattern: '([1-6])');
        exitRequested = await processSelection(input);
      }
    } catch (e) {
      print('');
    }
  }

  void displayMenu() {
    final divider = '=' * 40;
    StringBuffer buffer = StringBuffer();
    buffer.writeln(divider);
    buffer.writeln(_centerText(text: 'Medical Facility Management', width: 40));
    buffer.writeln(divider);
    buffer.writeln('MAIN MENU:');
    buffer.writeln('1. Add new facility');
    buffer.writeln('2. Update facility');
    buffer.writeln('3. Delete facility');
    buffer.writeln('4. List all facilities');
    buffer.writeln('5. Generate report');
    buffer.writeln('6. Exit');
    buffer.writeln(divider);
    print(buffer.toString());
  }

  Future<String> readUserInput({
    String prompt = 'Please enter your choice (1-6): ',
    required String validPattern,
    String errorMessage = 'Invalid input. Please try again.',
  }) async {
    while (true) {
      print(prompt);
      String? userInput = stdin.readLineSync();
      if (userInput == null ||
          userInput.trim().isEmpty ||
          !RegExp(validPattern).hasMatch(userInput.trim())) {
        print(errorMessage);
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

  Future<bool> confirmExit() async {
    Set<String> possibleAnswers = {'y', 'n', 'yes', 'no'};
    print('Are you sure you want to exit? (y/n)');
    String input;
    while (true) {
      input = (stdin.readLineSync() ?? '').toLowerCase().trim();
      if (possibleAnswers.contains(input)) {
        break;
      } else {
        print('Invalid input!');
        print('Are you sure you want to exit? (y/n)');
      }
    }
    if (input == 'y' || input == 'yes') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> processSelection(String input) async {
    switch (input) {
      case '1':
        await dispatchToAddFacility();
        return false;
      case '2':
        await dispatchToUpdateFacility();
        return false;
      case '3':
        await dispatchToDeleteFacility();
        return false;
      case '4':
        await dispatchToListFacilities();
        return false;
      case '5':
        await dispatchToGenerateReport();
        return false;
      case '6':
        bool result = await confirmExit();
        return result;
      default:
        return false;
    }
  }

  Future<void> dispatchToAddFacility() async {
    await AddFacilityModule(container: container).run();
  }

  Future<void> dispatchToUpdateFacility() async {
    await UpdateFacilityModule(container: container).run();
  }

  Future<void> dispatchToDeleteFacility() async {
    await DeleteFacilityModule(container: container).run();
  }

  Future<void> dispatchToListFacilities() async {
    await ListFacilitiesModule(container: container).run();
  }

  Future<void> dispatchToGenerateReport() async {
    await GenerateReportModule(container: container).run();
  }

  String _centerText({required String text, required int width}) {
    return ' ' * ((width - text.length) ~/ 2) + text;
  }
}
