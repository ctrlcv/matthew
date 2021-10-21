class BookMark {
  int paragraph;
  int pageNo;
  String paragraphStr;
  String strongCode;

  BookMark({this.paragraph = -1, this.pageNo = 0, this.paragraphStr = "", this.strongCode = ""});

  @override
  String toString() {
    return 'BookMark{paragraph: $paragraph, pageNo: $pageNo, paragraphStr: $paragraphStr, strongCode: $strongCode}';
  }
}
