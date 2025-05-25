import 'package:riverpod/riverpod.dart';

import '../utils/uuid_generator.dart';
import '../utils/uuid_generator_interface.dart';

final uuidProvider = Provider<UuidGeneratorInterface>((ref) {
  return UuidGenerator();
});
