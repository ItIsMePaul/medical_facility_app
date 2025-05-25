abstract class TableFormatterInterface {
  String formatTable<T>({
    required List<T> data,
    required List<String> headers,
    required List<String> properties,
  });

  String formatRow({
    required List<String> cells,
    required List<int> columnWidths,
  });

  String formatHeader({
    required List<String> headers,
    required List<int> columnWidths,
  });

  String formatDivider({required List<int> columnWidths});

  List<int> calculateColumnWidths<T>({
    required List<T> data,
    required List<String> headers,
    required List<String> properties,
  });
}
