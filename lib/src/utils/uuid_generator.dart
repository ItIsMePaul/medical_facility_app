import 'package:uuid/uuid.dart';

import 'uuid_generator_interface.dart';

class UuidGenerator implements UuidGeneratorInterface {
  final Uuid _uuid = Uuid();
  @override
  String generateV1() => _uuid.v1();

  @override
  String generateV4() => _uuid.v4();

  @override
  String generateV5(String? namespace, String? name) =>
      _uuid.v5(namespace, name);

  @override
  bool isValidUuid(String uuid) => Uuid.isValidUUID(fromString: uuid);
}
