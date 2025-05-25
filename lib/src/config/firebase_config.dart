import 'package:dotenv/dotenv.dart';

class FirebaseConfig {
  late final String apiKey;
  late final String authDomain;
  late final String databaseURL;
  late final String projectID;
  late final String storageBucket;
  late final String appID;
  late final String messagingSenderId;
  bool _isLoaded = false;

  static final FirebaseConfig _instance = FirebaseConfig._internal();

  factory FirebaseConfig() => _instance;

  FirebaseConfig._internal();

  void load() {
    if (_isLoaded) return;

    final env = DotEnv()..load();

    apiKey = env['FIREBASE_API_KEY'] ?? '';
    authDomain = env['FIREBASE_AUTH_DOMAIN'] ?? '';
    databaseURL = env['FIREBASE_DATABASE_URL'] ?? '';
    projectID = env['FIREBASE_PROJECT_ID'] ?? '';
    storageBucket = env['FIREBASE_STORAGE_BUCKET'] ?? '';
    appID = env['FIREBASE_APP_ID'] ?? '';
    messagingSenderId = env['MESSAGING_SENDER_ID'] ?? '';

    if (apiKey.isEmpty ||
        authDomain.isEmpty ||
        databaseURL.isEmpty ||
        projectID.isEmpty ||
        storageBucket.isEmpty ||
        appID.isEmpty ||
        messagingSenderId.isEmpty) {
      throw Exception(
        'Firebase configuration isn\'t full. Please cheack .env file',
      );
    }
    _isLoaded = true;
  }
}
