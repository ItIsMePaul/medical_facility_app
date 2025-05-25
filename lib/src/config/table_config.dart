class TableConfig {
  final String horizontalLine;
  final String verticalLine;
  final String crossingChar;
  final int padding;
  final TextAlignment defaultAlignment;
  final int maxColumnWidth;

  TableConfig({
    required this.horizontalLine,
    required this.verticalLine,
    required this.crossingChar,
    required this.padding,
    this.defaultAlignment = TextAlignment.left,
    this.maxColumnWidth = -1,
  });

  factory TableConfig.simple() {
    return TableConfig(
      horizontalLine: '-',
      verticalLine: '|',
      crossingChar: '+',
      padding: 1,
    );
  }
}

enum TextAlignment { left, center, right }
