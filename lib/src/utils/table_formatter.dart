import 'package:medical_facility_app/src/config/table_config.dart';
import 'package:medical_facility_app/src/entities/facility.dart';
import 'package:medical_facility_app/src/utils/table_formatter_interface.dart';

class TableFormatter implements TableFormatterInterface {
  final TableConfig config;
  TableFormatter({TableConfig? config})
    : config = config ?? TableConfig.simple();

  @override
  List<int> calculateColumnWidths<T>({
    required List<T> data,
    required List<String> headers,
    required List<String> properties,
  }) {
    List<int> columnWidths = List.filled(headers.length, 0);
    for (var i = 0; i < headers.length; i++) {
      columnWidths[i] = headers[i].length;
    }
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < properties.length; j++) {
        int width = 0;
        if (properties[j] == 'id') {
          width = (i + 1).toString().length;
          columnWidths[j] = _compareWidths(columnWidths[j], width);
        } else {
          dynamic property = _getPropertyValue(
            object: data[i],
            property: properties[j],
          );
          if (property != null) {
            width = property.toString().length;
          }
          columnWidths[j] = _compareWidths(columnWidths[j], width);
        }
      }
    }
    return columnWidths;
  }

  @override
  String formatDivider({required List<int> columnWidths}) {
    StringBuffer divider = StringBuffer(config.crossingChar);
    for (var width in columnWidths) {
      divider.write(
        config.horizontalLine * (width + config.padding * 2) +
            config.crossingChar,
      );
    }
    return divider.toString();
  }

  @override
  String formatHeader({
    required List<String> headers,
    required List<int> columnWidths,
  }) {
    if (headers.length != columnWidths.length) {
      throw Exception(
        'Length of headers and length of columnWidths should be equal!',
      );
    }
    StringBuffer header = StringBuffer(config.verticalLine);
    for (var i = 0; i < headers.length; i++) {
      header.write(
        _formatCell(
          value: headers[i],
          width: columnWidths[i],
          alignment: TextAlignment.center,
        ),
      );
      header.write(config.verticalLine);
    }
    return header.toString();
  }

  @override
  String formatRow({
    required List<String> cells,
    required List<int> columnWidths,
  }) {
    if (cells.length != columnWidths.length) {
      throw Exception(
        'Length of cells and length of columnWidths should be equal!',
      );
    }
    StringBuffer row = StringBuffer(config.verticalLine);
    for (var i = 0; i < cells.length; i++) {
      row.write(
        _formatCell(
          value: cells[i],
          width: columnWidths[i],
          alignment: config.defaultAlignment,
        ),
      );
      row.write(config.verticalLine);
    }
    return row.toString();
  }

  @override
  String formatTable<T>({
    required List<T> data,
    required List<String> headers,
    required List<String> properties,
  }) {
    List<int> columnWidths = calculateColumnWidths(
      data: data,
      headers: headers,
      properties: properties,
    );
    StringBuffer table = StringBuffer();
    table.writeln(formatDivider(columnWidths: columnWidths));
    table.writeln(formatHeader(headers: headers, columnWidths: columnWidths));
    table.writeln(formatDivider(columnWidths: columnWidths));
    for (var i = 0; i < data.length; i++) {
      List<String> cells = [];
      for (var j = 0; j < properties.length; j++) {
        dynamic value;
        if (properties[j] == 'id') {
          value = i + 1;
        } else {
          value = _getPropertyValue(object: data[i], property: properties[j]);
        }
        cells.add(value?.toString() ?? '');
      }
      table.writeln(formatRow(cells: cells, columnWidths: columnWidths));
      table.writeln(formatDivider(columnWidths: columnWidths));
    }
    return table.toString();
  }

  String _formatCell({
    required String value,
    required int width,
    required TextAlignment alignment,
  }) {
    if (value.isEmpty) {
      return ' ' * (width + config.padding * 2);
    }

    StringBuffer cell = StringBuffer(' ' * config.padding);
    if (value.length > width) {
      if (width <= 3) {
        value = "...".substring(0, width);
      } else {
        value = '${value.substring(0, width - 3)}...';
      }
    }
    switch (alignment) {
      case TextAlignment.left:
        cell.write(value + ' ' * (width - value.length));
        break;
      case TextAlignment.center:
        cell.write(
          ' ' * ((width - value.length) / 2).floor() +
              value +
              ' ' * ((width - value.length) / 2).ceil(),
        );
        break;
      case TextAlignment.right:
        cell.write(' ' * (width - value.length) + value);
        break;
    }
    cell.write(' ' * config.padding);
    return cell.toString();
  }

  dynamic _getPropertyValue({
    required dynamic object,
    required String property,
  }) {
    if (object is Map) {
      return object[property];
    }
    if (object is Facility) {
      switch (property) {
        case 'name':
          return object.name;
        case 'address':
          return object.address;
        case 'totalBeds':
          return object.totalBeds;
        case 'availableBeds':
          return object.availableBeds;
        case 'occupancy':
          if (object.totalBeds == 0) return 0.0;
          return '${((object.totalBeds - object.availableBeds) / object.totalBeds * 100).toStringAsFixed(1)}%';
        default:
          return null;
      }
    }
    return null;
  }

  int _compareWidths(int currentWidth, int width) {
    if (currentWidth < width) {
      if (config.maxColumnWidth == -1 || width <= config.maxColumnWidth) {
        return width;
      } else {
        return config.maxColumnWidth;
      }
    }
    return currentWidth;
  }
}
