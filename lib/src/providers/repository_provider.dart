import 'package:riverpod/riverpod.dart';

import '../repository/facilities_repository.dart';
import '../repository/firebase_facilities_repository.dart';
import 'firebase_provider.dart';

final repositoryProvider = FutureProvider<FacilitiesRepository>((ref) {
  final database = ref.read(firebaseDatabaseProvider);
  return FirebaseFacilitiesRepository(database: database);
});
