import 'line_info.dart';
import 'matthew_data.dart';

class PageInfo {
  final double fontSize;
  final int chapter;
  final int pageNumber;
  final String content;
  final String firstLine;
  final String lastLine;
  List<ParaFormat> paragraphs = [];
  List<LineInfo> lineInfoList = [];

  PageInfo(
      {required this.fontSize,
      required this.chapter,
      required this.pageNumber,
      required this.content,
      required this.firstLine,
      required this.lastLine});

  void setParagraphs(List<ParaFormat> paragraphs) {
    this.paragraphs = paragraphs;
  }

  List<ParaFormat> getParagraphs() {
    return paragraphs;
  }

  void setLineInfoList(List<LineInfo> lineInfoList) {
    this.lineInfoList = lineInfoList;
  }

  List<LineInfo> getLineInfoList() {
    return lineInfoList;
  }

  @override
  String toString() {
    return 'PageInfo{fontSize: $fontSize, chapter: $chapter, pageNumber: $pageNumber, firstLine: $firstLine, lastLine: $lastLine, paragraphs $paragraphs}';
  }
}
