import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:matthew/constants/constants.dart';
import 'package:matthew/models/line_info.dart';
import 'package:matthew/models/matthew_data.dart';
import 'package:matthew/models/page_info.dart';

class Settings {
  static final Settings _instance = Settings._internal();

  factory Settings() {
    return _instance;
  }

  Settings._internal() {
    _fontName = Hive.box('matthew').get('setFontName') ?? FONT_GOWUN;
    _fontSize = Hive.box('matthew').get('setFontSize') ?? FONT_SIZE_3;
    _scrollVertical = Hive.box('matthew').get('setScrollVertical') ?? false;
    _bookMarks = Hive.box('matthew').get('setBookMark') ?? [];
    _bookMarkStrong = Hive.box('matthew').get('setBookMarkStrong') ?? [];
  }

  static double _fontSize = FONT_SIZE_3;
  static String _fontName = FONT_GOWUN;
  static bool _scrollVertical = false;
  static List<int> _bookMarks = [];
  static List<String> _bookMarkStrong = [];

  static double _screenWidth = 0;
  static double _screenHeight = 0;

  static double _safeScreenWidth = 0;
  static double _safeScreenHeight = 0;

  static double _headerScreenWidth = 0;
  static double _headerScreenHeight = 0;

  static double _strongDicScreenWidth = 0;
  static double _strongDicScreenHeight = 0;

  static double _verticalSpace = 0;
  static double _horizontalSpace = 0;

  static int _font1MaxLines = 0;
  static int _font2MaxLines = 0;
  static int _font3MaxLines = 0;
  static int _font4MaxLines = 0;
  static int _font5MaxLines = 0;
  static int _font6MaxLines = 0;

  static int _font1HeaderMaxLines = 0;
  static int _font2HeaderMaxLines = 0;
  static int _font3HeaderMaxLines = 0;
  static int _font4HeaderMaxLines = 0;
  static int _font5HeaderMaxLines = 0;
  static int _font6HeaderMaxLines = 0;

  static List<String> _matthewBody = [
    kChapter1All,
    kChapter2All,
    kChapter3All,
    kChapter4All,
    kChapter5All,
    kChapter6All,
    kChapter7All,
    kChapter8All,
    kChapter9All,
    kChapter10All,
    kChapter11All,
    kChapter12All
  ];

  static List<List<LineInfo>> _matthewLineInfoLists = [
    _lineInfoHeader,
    _lineInfoChapter01,
    _lineInfoChapter02,
    _lineInfoChapter03,
    _lineInfoChapter04,
    _lineInfoChapter05,
    _lineInfoChapter06,
    _lineInfoChapter07,
    _lineInfoChapter08,
    _lineInfoChapter09,
    _lineInfoChapter10,
    _lineInfoChapter11,
    _lineInfoChapter12,
    _lineInfoEnded
  ];

  static List<PageInfo> _pageInfoFont1 = [];
  static List<PageInfo> _pageInfoFont2 = [];
  static List<PageInfo> _pageInfoFont3 = [];
  static List<PageInfo> _pageInfoFont4 = [];
  static List<PageInfo> _pageInfoFont5 = [];
  static List<PageInfo> _pageInfoFont6 = [];

  static List<LineInfo> _lineInfoHeader = [];
  static List<LineInfo> _lineInfoChapter01 = [];
  static List<LineInfo> _lineInfoChapter02 = [];
  static List<LineInfo> _lineInfoChapter03 = [];
  static List<LineInfo> _lineInfoChapter04 = [];
  static List<LineInfo> _lineInfoChapter05 = [];
  static List<LineInfo> _lineInfoChapter06 = [];
  static List<LineInfo> _lineInfoChapter07 = [];
  static List<LineInfo> _lineInfoChapter08 = [];
  static List<LineInfo> _lineInfoChapter09 = [];
  static List<LineInfo> _lineInfoChapter10 = [];
  static List<LineInfo> _lineInfoChapter11 = [];
  static List<LineInfo> _lineInfoChapter12 = [];
  static List<LineInfo> _lineInfoEnded = [];

  void setFontSize(double fontSize) {
    _fontSize = fontSize;
    Hive.box('matthew').put("setFontSize", fontSize);
  }

  double getFontSize() {
    return _fontSize;
  }

  void setFontName(String fontName) {
    _fontName = fontName;
    Hive.box('matthew').put("setFontName", fontName);
  }

  String getFontName() {
    return _fontName;
  }

  void setScrollVertical(bool scrollVertical) {
    _scrollVertical = scrollVertical;
    Hive.box('matthew').put("setScrollVertical", scrollVertical);
  }

  bool getScrollVertical() {
    return _scrollVertical;
  }

  bool isBookMarkPage(var bookMarkNo) {
    bool result = false;

    if (bookMarkNo is int) {
      for (int i = 0; i < _bookMarks.length; i++) {
        if (_bookMarks[i] == bookMarkNo) {
          return true;
        }
      }
    } else {
      for (int i = 0; i < _bookMarkStrong.length; i++) {
        if (_bookMarkStrong[i] == bookMarkNo) {
          return true;
        }
      }
    }

    return result;
  }

  void setBookMarks(var bookMarkNo) {
    if (bookMarkNo is int) {
      if (isBookMarkPage(bookMarkNo)) {
        _bookMarks.remove(bookMarkNo);
      } else {
        _bookMarks.add(bookMarkNo);
      }
      _bookMarks.sort();
      print('setBookMarks $_bookMarks');
      Hive.box('matthew').put("setBookMark", _bookMarks);
    } else {
      if (isBookMarkPage(bookMarkNo)) {
        _bookMarkStrong.remove(bookMarkNo);
      } else {
        _bookMarkStrong.add(bookMarkNo);
      }
      _bookMarkStrong.sort((itemA, itemB) {
        String itemAIndex = "";
        String itemBIndex = "";

        int itemANum = 0;
        int itemBNum = 0;

        for (int i = 0; i < itemA.length; i++) {
          if (itemA[i] == '0' ||
              itemA[i] == '1' ||
              itemA[i] == '2' ||
              itemA[i] == '3' ||
              itemA[i] == '4' ||
              itemA[i] == '5' ||
              itemA[i] == '6' ||
              itemA[i] == '7' ||
              itemA[i] == '8' ||
              itemA[i] == '9') {
            itemAIndex += itemA[i];
          } else {
            if (itemAIndex.length != 0) {
              break;
            }
          }
        }

        for (int i = 0; i < itemB.length; i++) {
          if (itemB[i] == '0' ||
              itemB[i] == '1' ||
              itemB[i] == '2' ||
              itemB[i] == '3' ||
              itemB[i] == '4' ||
              itemB[i] == '5' ||
              itemB[i] == '6' ||
              itemB[i] == '7' ||
              itemB[i] == '8' ||
              itemB[i] == '9') {
            itemBIndex += itemB[i];
          } else {
            if (itemBIndex.length != 0) {
              break;
            }
          }
        }

        itemANum = int.parse(itemAIndex);
        itemBNum = int.parse(itemBIndex);

        if (itemANum > itemBNum) {
          return 1;
        } else if (itemANum < itemBNum) {
          return -1;
        } else {
          return 0;
        }
      });
      print('setBookMarks $_bookMarkStrong');
      Hive.box('matthew').put("setBookMarkStrong", _bookMarkStrong);
    }
  }

  TextStyle getFontStyle({Color color = Colors.black}) {
    if (_fontName.isEmpty) {
      return TextStyle(
        fontSize: _fontSize,
        color: color,
        height: LINE_HEIGHT,
      );
    } else {
      return TextStyle(
        fontFamily: _fontName,
        fontSize: _fontSize,
        height: LINE_HEIGHT,
        color: color,
      );
    }
  }

  TextStyle getCustomFontStyle(
      {required double fontSize,
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal,
      double height = LINE_HEIGHT,
      double letterSpacing = 0}) {
    if (fontSize == 0) {
      fontSize = _fontSize;
    }

    if (_fontName.isEmpty) {
      return TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight, height: height, letterSpacing: letterSpacing);
    } else {
      return TextStyle(fontFamily: _fontName, fontSize: fontSize, color: color, fontWeight: fontWeight, height: height, letterSpacing: letterSpacing);
    }
  }

  void setScreenWidth(double screenWidth) {
    _screenWidth = screenWidth;
  }

  double getScreenWidth() {
    return _screenWidth;
  }

  void setScreenHeight(double screenHeight) {
    _screenHeight = screenHeight;
  }

  double getScreenHeight() {
    return _screenHeight;
  }

  void setSafeScreenWidth(double screenWidth) {
    _safeScreenWidth = screenWidth;
  }

  double getSafeScreenWidth() {
    return _safeScreenWidth;
  }

  void setSafeScreenHeight(double screenHeight) {
    _safeScreenHeight = screenHeight;
  }

  double getSafeScreenHeight() {
    return _safeScreenHeight;
  }

  void setHeaderScreenWidth(double headerWidth) {
    _headerScreenWidth = headerWidth;
  }

  double getHeaderScreenWidth() {
    return _headerScreenWidth;
  }

  void setHeaderScreenHeight(double headerHeight) {
    _headerScreenHeight = headerHeight;
  }

  double getHeaderScreenHeight() {
    return _headerScreenHeight;
  }

  void setStrongDicScreenWidth(double strongDicWidth) {
    _strongDicScreenWidth = strongDicWidth;
  }

  double getStrongDicScreenWidth() {
    return _strongDicScreenWidth;
  }

  void setStrongDicScreenHeight(double stringDicHeight) {
    _strongDicScreenHeight = stringDicHeight;
  }

  double getStrongDicScreenHeight() {
    return _strongDicScreenHeight;
  }

  void setVerticalSpace(double space) {
    _verticalSpace = space;
  }

  double getVerticalSpace() {
    return _verticalSpace;
  }

  void setHorizontalSpace(double space) {
    _horizontalSpace = space;
  }

  double getHorizontalSpace() {
    return _horizontalSpace;
  }

  void initPageInfo() {
    _font1MaxLines = 0;
    _font2MaxLines = 0;
    _font3MaxLines = 0;
    _font4MaxLines = 0;
    _font5MaxLines = 0;
    _font6MaxLines = 0;

    _font1HeaderMaxLines = 0;
    _font2HeaderMaxLines = 0;
    _font3HeaderMaxLines = 0;
    _font4HeaderMaxLines = 0;
    _font5HeaderMaxLines = 0;
    _font6HeaderMaxLines = 0;

    _pageInfoFont1 = [];
    _pageInfoFont2 = [];
    _pageInfoFont3 = [];
    _pageInfoFont4 = [];
    _pageInfoFont5 = [];
    _pageInfoFont6 = [];

    _lineInfoHeader = [];
    _lineInfoChapter01 = [];
    _lineInfoChapter02 = [];
    _lineInfoChapter03 = [];
    _lineInfoChapter04 = [];
    _lineInfoChapter05 = [];
    _lineInfoChapter06 = [];
    _lineInfoChapter07 = [];
    _lineInfoChapter08 = [];
    _lineInfoChapter09 = [];
    _lineInfoChapter10 = [];
    _lineInfoChapter11 = [];
    _lineInfoChapter12 = [];
    _lineInfoEnded = [];
  }

  void setMaxLines(double fontSize, int maxLines) {
    if (fontSize == FONT_SIZE_1) {
      _font1MaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_2) {
      _font2MaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_3) {
      _font3MaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_4) {
      _font4MaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_5) {
      _font5MaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_6) {
      _font6MaxLines = maxLines;
    }
  }

  int getMaxLines(double fontSize) {
    if (fontSize == FONT_SIZE_1) {
      return _font1MaxLines;
    } else if (fontSize == FONT_SIZE_2) {
      return _font2MaxLines;
    } else if (fontSize == FONT_SIZE_3) {
      return _font3MaxLines;
    } else if (fontSize == FONT_SIZE_4) {
      return _font4MaxLines;
    } else if (fontSize == FONT_SIZE_5) {
      return _font5MaxLines;
    } else if (fontSize == FONT_SIZE_6) {
      return _font6MaxLines;
    }

    return _font2MaxLines;
  }

  void setHeaderMaxLines(double fontSize, int maxLines) {
    if (fontSize == FONT_SIZE_1) {
      _font1HeaderMaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_2) {
      _font2HeaderMaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_3) {
      _font3HeaderMaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_4) {
      _font4HeaderMaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_5) {
      _font5HeaderMaxLines = maxLines;
    } else if (fontSize == FONT_SIZE_6) {
      _font6HeaderMaxLines = maxLines;
    }
  }

  int getHeaderMaxLines(double fontSize) {
    if (fontSize == FONT_SIZE_1) {
      return _font1HeaderMaxLines;
    } else if (fontSize == FONT_SIZE_2) {
      return _font2HeaderMaxLines;
    } else if (fontSize == FONT_SIZE_3) {
      return _font3HeaderMaxLines;
    } else if (fontSize == FONT_SIZE_4) {
      return _font4HeaderMaxLines;
    } else if (fontSize == FONT_SIZE_5) {
      return _font5HeaderMaxLines;
    } else if (fontSize == FONT_SIZE_6) {
      return _font6HeaderMaxLines;
    }

    return _font2HeaderMaxLines;
  }

  void setPageInfo(double fontSize, List<PageInfo> pageInfo) {
    if (fontSize == FONT_SIZE_1) {
      _pageInfoFont1 = pageInfo;
    } else if (fontSize == FONT_SIZE_2) {
      _pageInfoFont2 = pageInfo;
    } else if (fontSize == FONT_SIZE_3) {
      _pageInfoFont3 = pageInfo;
    } else if (fontSize == FONT_SIZE_4) {
      _pageInfoFont4 = pageInfo;
    } else if (fontSize == FONT_SIZE_5) {
      _pageInfoFont5 = pageInfo;
    } else if (fontSize == FONT_SIZE_6) {
      _pageInfoFont6 = pageInfo;
    }
  }

  List<PageInfo> getPageInfo(double fontSize) {
    if (fontSize == FONT_SIZE_1) {
      return _pageInfoFont1;
    } else if (fontSize == FONT_SIZE_2) {
      return _pageInfoFont2;
    } else if (fontSize == FONT_SIZE_3) {
      return _pageInfoFont3;
    } else if (fontSize == FONT_SIZE_4) {
      return _pageInfoFont4;
    } else if (fontSize == FONT_SIZE_5) {
      return _pageInfoFont5;
    } else if (fontSize == FONT_SIZE_6) {
      return _pageInfoFont6;
    }

    return _pageInfoFont2;
  }

  void setLineInfo(int chapter, List<LineInfo> lineInfo) {
    switch (chapter) {
      case 0:
        _lineInfoHeader = lineInfo;
        break;
      case 1:
        _lineInfoChapter01 = lineInfo;
        break;
      case 2:
        _lineInfoChapter02 = lineInfo;
        break;
      case 3:
        _lineInfoChapter03 = lineInfo;
        break;
      case 4:
        _lineInfoChapter04 = lineInfo;
        break;
      case 5:
        _lineInfoChapter05 = lineInfo;
        break;
      case 6:
        _lineInfoChapter06 = lineInfo;
        break;
      case 7:
        _lineInfoChapter07 = lineInfo;
        break;
      case 8:
        _lineInfoChapter08 = lineInfo;
        break;
      case 9:
        _lineInfoChapter09 = lineInfo;
        break;
      case 10:
        _lineInfoChapter10 = lineInfo;
        break;
      case 11:
        _lineInfoChapter11 = lineInfo;
        break;
      case 12:
        _lineInfoChapter12 = lineInfo;
        break;
      case 13:
        _lineInfoEnded = lineInfo;
        break;
    }
  }

  List<LineInfo> getLineInfo(int chapter) {
    switch (chapter) {
      case 0:
        return _lineInfoHeader;
      case 1:
        return _lineInfoChapter01;
      case 2:
        return _lineInfoChapter02;
      case 3:
        return _lineInfoChapter03;
      case 4:
        return _lineInfoChapter04;
      case 5:
        return _lineInfoChapter05;
      case 6:
        return _lineInfoChapter06;
      case 7:
        return _lineInfoChapter07;
      case 8:
        return _lineInfoChapter08;
      case 9:
        return _lineInfoChapter09;
      case 10:
        return _lineInfoChapter10;
      case 11:
        return _lineInfoChapter11;
      case 12:
        return _lineInfoChapter12;
      case 13:
        return _lineInfoEnded;
    }

    return _lineInfoHeader;
  }
}
