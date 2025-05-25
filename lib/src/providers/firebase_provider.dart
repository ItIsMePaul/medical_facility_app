import 'package:firebase_dart/firebase_dart.dart';
import 'package:riverpod/riverpod.dart';

import '../config/firebase_config.dart';

final firebaseInitProvider = FutureProvider<FirebaseApp>((ref) async {
  final config = FirebaseConfig()..load();
  FirebaseDart.setup();
  try {
    return await Firebase.initializeApp(
      name: 'medical_facility_app',
      options: FirebaseOptions(
        apiKey: config.apiKey,
        authDomain: config.authDomain,
        databaseURL: config.databaseURL,
        projectId: config.projectID,
        storageBucket: config.storageBucket,
        appId: config.appID,
        messagingSenderId: config.messagingSenderId,
      ),
    );
  } catch (e) {
    if (e.toString().contains('already exists')) {
      return Firebase.app('medical_facility_app');
    }
    rethrow;
  }
});

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  final firebaseApp = ref.watch(firebaseInitProvider).value;
  if (firebaseApp == null) {
    throw Exception('Firebase not initialized');
  }
  return FirebaseDatabase(app: firebaseApp);
});
