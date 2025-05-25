abstract class UuidGeneratorInterface {
  String generateV1();

  String generateV4();

  String generateV5(String? namespace, String? name);

  bool isValidUuid(String uuid);
}
