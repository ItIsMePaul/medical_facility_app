import 'dart:io';

import 'package:medical_facility_app/src/cli/main_menu.dart';
import 'package:medical_facility_app/src/providers/firebase_provider.dart';
import 'package:riverpod/riverpod.dart';

Future<void> main() async {
  final container = ProviderContainer();
  try {
    print('Initizlizing Firebase...');
    await container.read(firebaseInitProvider.future);
    print('Firebase initialized successfully!');

    final mainMenu = MainMenu(container: container);
    await mainMenu.run();
  } catch (e) {
    print('Error: $e');
    exit(1);
  } finally {
    container.dispose();
    exit(0);
  }
}
