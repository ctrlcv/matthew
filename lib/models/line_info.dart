class LineInfo {
  final int index;
  final int chapter;
  final int paragraph;
  final String lineText;

  LineInfo(
      {required this.index,
      required this.chapter,
      required this.paragraph,
      required this.lineText});

  @override
  String toString() {
    return 'LineInfo{index: $index, chapter: $chapter, paragraph: $paragraph, lineText: $lineText}';
  }
}
