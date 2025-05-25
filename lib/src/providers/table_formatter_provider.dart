import 'package:medical_facility_app/src/utils/table_formatter.dart';
import 'package:riverpod/riverpod.dart';

import '../utils/table_formatter_interface.dart';

final tableFormatterProvider = Provider<TableFormatterInterface>((ref) {
  return TableFormatter();
});
