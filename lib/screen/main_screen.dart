import 'dart:async';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:matthew/dialog/font_set_dialog.dart';
import 'package:matthew/models/bookmark_model.dart';
import 'package:matthew/models/strong_dic_data.dart';
import 'package:matthew/screen/pdf_screen.dart';
import 'package:matthew/screen/search_screen.dart';
import 'package:matthew/utils/settings.dart';

import '../constants/constants.dart';
import '../models/line_info.dart';
import '../models/matthew_data.dart';
import '../swipe_detector.dart';
import 'bookmark_screen.dart';
import 'contents_screen.dart';
import 'data_initialization.dart';
import 'header_pages.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Settings _settings = Settings();
  HeaderPage _headerPage = HeaderPage();

  List<List<LineInfo>> _lineInfoList = [];

  List<LineInfo> _lineInfoHeader = [];
  List<LineInfo> _lineInfoChapter1 = [];
  List<LineInfo> _lineInfoChapter2 = [];
  List<LineInfo> _lineInfoChapter3 = [];
  List<LineInfo> _lineInfoChapter4 = [];
  List<LineInfo> _lineInfoChapter5 = [];
  List<LineInfo> _lineInfoChapter6 = [];
  List<LineInfo> _lineInfoChapter7 = [];
  List<LineInfo> _lineInfoChapter8 = [];
  List<LineInfo> _lineInfoChapter9 = [];
  List<LineInfo> _lineInfoChapter10 = [];
  List<LineInfo> _lineInfoChapter11 = [];
  List<LineInfo> _lineInfoChapter12 = [];
  List<LineInfo> _lineInfoEnded = [];

  int _bookTitleCounter = 4;
  int _headerPageCounter = 0;
  int _contentCounter = 3;
  int _innerTitleCounter = 1;
  int _chapter1PageCounter = 0;
  int _chapter2PageCounter = 0;
  int _chapter3PageCounter = 0;
  int _chapter4PageCounter = 0;
  int _chapter5PageCounter = 0;
  int _chapter6PageCounter = 0;
  int _chapter7PageCounter = 0;
  int _chapter8PageCounter = 0;
  int _chapter9PageCounter = 0;
  int _chapter10PageCounter = 0;
  int _chapter11PageCounter = 0;
  int _chapter12PageCounter = 0;
  int _strongDicPageCounter = 0;
  int _endedPageCounter = 0;
  int _totalHeaderCounter = 0;
  int _totalPageCounter = 0;

  List<int> _pageIndex = [];

  PageController _pageController = PageController();

  int _currentPageNo = 0;
  int _beforePageNo = 0;

  bool _showMenu = false;
  Timer _showMenuTimer = new Timer(Duration(milliseconds: 1000), () {});

  bool _showScrollSetPanel = false;
  bool _setScrollVertical = false;

  bool _showFontSetPanel = false;
  String _setFontName = "";
  double _setFontSize = 0;

  int _firstParagraph = -1;
  int _lastParagraph = -1;

  bool _isCopyMode = false;

  @override
  void initState() {
    print("MainViewer initState()");
    super.initState();

    _showScrollSetPanel = false;
    _setScrollVertical = _settings.getScrollVertical();

    _showFontSetPanel = false;
    _setFontName = _settings.getFontName();
    _setFontSize = _settings.getFontSize();

    calculatorPageInfo();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int currentPage = Hive.box('matthew').get("currentPage") ?? -1;

      if (currentPage == -1) {
        int currentParagraph = Hive.box("matthew").get("currentParagraph") ?? -1;
        String currentStrongDicCode = Hive.box('matthew').get("currentStrongCode") ?? "";
        print('mainScreen() initState() - fail to load currentPage =========================');
        print('currentParagraph $currentParagraph currentStrongDicCode $currentStrongDicCode');

        if (currentStrongDicCode.isNotEmpty) {
          jumpToPageByStrongCode(currentStrongDicCode);
        } else if (currentParagraph != -1) {
          jumpToPageByParagraph(currentParagraph);
        } else {
          _pageController.jumpToPage(0);
        }
      } else {
        print('mainScreen() initState() - success to load currentPage =======================');
        print('currentPage $currentPage');
        _pageController.jumpToPage(currentPage);
      }
    });
  }

  void calculatorPageInfo() {
    _lineInfoHeader = _settings.getLineInfo(0);
    _lineInfoChapter1 = _settings.getLineInfo(1);
    _lineInfoChapter2 = _settings.getLineInfo(2);
    _lineInfoChapter3 = _settings.getLineInfo(3);
    _lineInfoChapter4 = _settings.getLineInfo(4);
    _lineInfoChapter5 = _settings.getLineInfo(5);
    _lineInfoChapter6 = _settings.getLineInfo(6);
    _lineInfoChapter7 = _settings.getLineInfo(7);
    _lineInfoChapter8 = _settings.getLineInfo(8);
    _lineInfoChapter9 = _settings.getLineInfo(9);
    _lineInfoChapter10 = _settings.getLineInfo(10);
    _lineInfoChapter11 = _settings.getLineInfo(11);
    _lineInfoChapter12 = _settings.getLineInfo(12);
    _lineInfoEnded = _settings.getLineInfo(13);

    int maxLines = _settings.getMaxLines(_settings.getFontSize());
    int headerMaxLines = _settings.getHeaderMaxLines(_settings.getFontSize());

    _headerPageCounter = getHeaderPageCounter(_lineInfoHeader, headerMaxLines);
    _contentCounter = getContentPageCounter();
    _chapter1PageCounter = getPageCounter(_lineInfoChapter1, maxLines);
    _chapter2PageCounter = getPageCounter(_lineInfoChapter2, maxLines);
    _chapter3PageCounter = getPageCounter(_lineInfoChapter3, maxLines);
    _chapter4PageCounter = getPageCounter(_lineInfoChapter4, maxLines);
    _chapter5PageCounter = getPageCounter(_lineInfoChapter5, maxLines);
    _chapter6PageCounter = getPageCounter(_lineInfoChapter6, maxLines);
    _chapter7PageCounter = getPageCounter(_lineInfoChapter7, maxLines);
    _chapter8PageCounter = getPageCounter(_lineInfoChapter8, maxLines);
    _chapter9PageCounter = getPageCounter(_lineInfoChapter9, maxLines);
    _chapter10PageCounter = getPageCounter(_lineInfoChapter10, maxLines);
    _chapter11PageCounter = getPageCounter(_lineInfoChapter11, maxLines);
    _chapter12PageCounter = getPageCounter(_lineInfoChapter12, maxLines);
    _totalHeaderCounter = _bookTitleCounter + _headerPageCounter + _contentCounter + _innerTitleCounter;
    _strongDicPageCounter = getStrongDicPageCounter();
    _endedPageCounter = getHeaderPageCounter(_lineInfoEnded, headerMaxLines);

    _totalPageCounter = _totalHeaderCounter +
        _chapter1PageCounter +
        _chapter2PageCounter +
        _chapter3PageCounter +
        _chapter4PageCounter +
        _chapter5PageCounter +
        _chapter6PageCounter +
        _chapter7PageCounter +
        _chapter8PageCounter +
        _chapter9PageCounter +
        _chapter10PageCounter +
        _chapter11PageCounter +
        _chapter12PageCounter +
        _strongDicPageCounter +
        _endedPageCounter;

    _pageIndex = [
      4,
      _totalHeaderCounter,
      _totalHeaderCounter + _chapter1PageCounter,
      _totalHeaderCounter + _chapter1PageCounter + _chapter2PageCounter,
      _totalHeaderCounter + _chapter1PageCounter + _chapter2PageCounter + _chapter3PageCounter,
      _totalHeaderCounter + _chapter1PageCounter + _chapter2PageCounter + _chapter3PageCounter + _chapter4PageCounter,
      _totalHeaderCounter + _chapter1PageCounter + _chapter2PageCounter + _chapter3PageCounter + _chapter4PageCounter + _chapter5PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter +
          _chapter8PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter +
          _chapter8PageCounter +
          _chapter9PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter +
          _chapter8PageCounter +
          _chapter9PageCounter +
          _chapter10PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter +
          _chapter8PageCounter +
          _chapter9PageCounter +
          _chapter10PageCounter +
          _chapter11PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter +
          _chapter8PageCounter +
          _chapter9PageCounter +
          _chapter10PageCounter +
          _chapter11PageCounter +
          _chapter12PageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter +
          _chapter8PageCounter +
          _chapter9PageCounter +
          _chapter10PageCounter +
          _chapter11PageCounter +
          _chapter12PageCounter +
          _strongDicPageCounter,
      _totalHeaderCounter +
          _chapter1PageCounter +
          _chapter2PageCounter +
          _chapter3PageCounter +
          _chapter4PageCounter +
          _chapter5PageCounter +
          _chapter6PageCounter +
          _chapter7PageCounter +
          _chapter8PageCounter +
          _chapter9PageCounter +
          _chapter10PageCounter +
          _chapter11PageCounter +
          _chapter12PageCounter +
          _strongDicPageCounter +
          _endedPageCounter
    ];

    _lineInfoList = [
      _lineInfoHeader,
      _lineInfoChapter1,
      _lineInfoChapter2,
      _lineInfoChapter3,
      _lineInfoChapter4,
      _lineInfoChapter5,
      _lineInfoChapter6,
      _lineInfoChapter7,
      _lineInfoChapter8,
      _lineInfoChapter9,
      _lineInfoChapter10,
      _lineInfoChapter11,
      _lineInfoChapter12,
      _lineInfoEnded,
    ];

    print(_pageIndex);
    _pageController = PageController(initialPage: 0);
  }

  int getHeaderPageCounter(List<LineInfo> lineInfoList, int maxLines) {
    int pageCount = 0;

    int offset = ((maxLines / 3) * 1).floor();

    if ((lineInfoList.length + offset) % maxLines == 0) {
      pageCount = ((lineInfoList.length + offset) / maxLines).floor();
    } else {
      pageCount = ((lineInfoList.length + offset) / maxLines).floor() + 1;
    }

    return pageCount;
  }

  int getContentPageCounter() {
    int pageCount = 0;

    double screenHeight = _settings.getHeaderScreenHeight();
    int maxLines = (screenHeight / HEADER_CONTENT_HEIGHT).floor();

    if (15 % maxLines == 0) {
      pageCount = (15 / maxLines).floor();
    } else {
      pageCount = (15 / maxLines).floor() + 1;
    }

    return pageCount;
  }

  int getStrongDicPageCounter() {
    int pageCount = 0;

    double screenHeight = _settings.getStrongDicScreenHeight();
    int maxLines = (screenHeight / STRONG_DIC_ITEM_HEIGHT).floor();

    if (kStrongDic.length % maxLines == 0) {
      pageCount = (kStrongDic.length / maxLines).floor() + 1;
    } else {
      pageCount = (kStrongDic.length / maxLines).floor() + 2;
    }

    print('getStrongDicPageCounter() $pageCount');

    return pageCount;
  }

  int getPageCounter(List<LineInfo> lineInfoList, int maxLines) {
    int pageCount = 0;

    int offset = ((maxLines / 3) * 2).floor();

    if ((lineInfoList.length - offset) % maxLines == 0) {
      pageCount = ((lineInfoList.length - offset) / maxLines).floor() + 2;
    } else {
      pageCount = ((lineInfoList.length - offset) / maxLines).floor() + 3;
    }

    return pageCount;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void calculateScreenSize() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var size = MediaQuery.of(context).size;
      print('calculateScreenSize size $size');
    });
  }

  void _onPageChange(int pageNo) {
    _beforePageNo = _currentPageNo;
    _currentPageNo = pageNo;

    print('_onPageChange() page ' + _beforePageNo.toString() + ' --> ' + _currentPageNo.toString());

    // print('_onPageChange() _firstParagraph $_firstParagraph');
    // print('_onPageChange() _lastParagraph $_lastParagraph');
    // print('_onPageChange() _pageIndex[13] ${_pageIndex[13]}');

    int storeParagraph = isChapterTitlePage(pageNo);
    Hive.box('matthew').put("currentPage", _currentPageNo);

    if (!isStrongCodePage() || _currentPageNo == _pageIndex[13]) {
      if (storeParagraph >= 0) {
        storeParagraph = _firstParagraph;
      }

      if (_currentPageNo < _totalHeaderCounter) {
        storeParagraph = (_currentPageNo * -1) - 100;
      }

      print('_onPageChange() storePageInfo - storeParagraph: $storeParagraph');
      Hive.box('matthew').put("currentParagraph", storeParagraph);
      Hive.box('matthew').put("currentStrongCode", "");
    } else {
      String firstStrongCode = getStrongCodeByPageNo(_currentPageNo);

      print('_onPageChange() storePageInfo - firstStrongCode: $firstStrongCode');
      Hive.box('matthew').put("currentParagraph", -1);
      Hive.box('matthew').put("currentStrongCode", firstStrongCode);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onClickMenuSearch() {
    print('onClickMenuSearch()');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          onClickParagraph: (paragraphNo) {
            print("onClickParagraph $paragraphNo");
            _pageController.jumpToPage(getPageNoByParagraph(paragraphNo));
            if (mounted) {
              setState(() {});
            }
          },
          onClickStrongCode: (strongCode) {
            print("onClickStrongCode $strongCode");
            _pageController.jumpToPage(getPageNoByStrongDicCode(strongCode));
            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  void _onClickMenuViewBookMark() {
    _showMenu = false;

    if (_showMenuTimer.isActive) {
      _showMenuTimer.cancel();
    }

    if (mounted) {
      setState(() {});
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookMarkScreen(
          onClickPage: (value) {
            print("onClickPage $value");
            _pageController.jumpToPage(value);
            if (mounted) {
              setState(() {});
            }
          },
          bookMarks: getBookMarkList(),
        ),
      ),
    );
  }

  List<BookMark> getBookMarkList() {
    List<BookMark> result = [];

    List<int> bookmarks = Hive.box('matthew').get('setBookMark') ?? [];

    for (int i = 0; i < bookmarks.length; i++) {
      BookMark bMark = BookMark(
        paragraph: bookmarks[i],
        pageNo: getPageNoByParagraph(bookmarks[i]),
        paragraphStr: getParagraphStrByNumber(bookmarks[i]),
      );
      // print(bMark);
      result.add(bMark);
    }

    List<String> bookmarkStrong = Hive.box('matthew').get('setBookMarkStrong') ?? [];

    for (int i = 0; i < bookmarkStrong.length; i++) {
      BookMark bMark = BookMark(
        paragraph: -1,
        pageNo: getPageNoByStrongDicCode(bookmarkStrong[i]),
        paragraphStr: getStrongDicMean(bookmarkStrong[i]),
        strongCode: bookmarkStrong[i],
      );

      print(bMark);
      result.add(bMark);
    }

    return result;
  }

  String getStrongDicMean(String code) {
    for (int i = 0; i < kStrongDic.length; i++) {
      if (code == kStrongDic[i].code) {
        return kStrongDic[i].mean;
      }
    }
    return "";
  }

  String getStrongCodeByPageNo(int pageNo) {
    int indexOfDic = pageNo - _pageIndex[13];
    int maxLines = (_settings.getStrongDicScreenHeight() / STRONG_DIC_ITEM_HEIGHT).floor();
    int firstStrongIndex = (maxLines * (indexOfDic - 1)) - 1;
    print('getStrongCodeByPageNo() indexOfDic $indexOfDic, firstStrongIndex $firstStrongIndex');

    if (firstStrongIndex < 0) {
      firstStrongIndex = 0;
    }
    if (firstStrongIndex >= kStrongDic.length) {
      firstStrongIndex = kStrongDic.length - 1;
    }

    return kStrongDic[firstStrongIndex].code;
  }

  int getPageNoByStrongDicCode(String code) {
    int indexOfDic = -1;
    for (int i = 0; i < kStrongDic.length; i++) {
      if (code == kStrongDic[i].code) {
        indexOfDic = i;
        break;
      }
    }

    int startPageIndex = _pageIndex[13];
    int maxLines = (_settings.getStrongDicScreenHeight() / STRONG_DIC_ITEM_HEIGHT).floor();

    print('getPageNoByStrongDicCode indexOfDic $indexOfDic startPageIndex $startPageIndex, maxLines $maxLines');

    for (int i = 1; i < _strongDicPageCounter; i++) {
      int startIndex;
      int endIndex;

      if (i == 1) {
        startIndex = 0;
        endIndex = startIndex + maxLines - 1;
      } else {
        startIndex = (maxLines * (i - 1)) - 1;
        endIndex = startIndex + maxLines;
      }

      if (startIndex <= indexOfDic && indexOfDic <= endIndex) {
        return startPageIndex + i + 1;
      }
    }

    return -1;
  }

  String getParagraphStrByNumber(int paragraph) {
    String result = "";
    int chapterNo = getChapterNoByParagraph(paragraph);
    int chapterIndex = kStartParagraph[chapterNo - 1];
    print('paragraph : $paragraph, chapterNo : $chapterNo, chapterIndex $chapterIndex');
    List<LineInfo> lineInfo = _lineInfoList[chapterNo];

    for (int i = 0; i < lineInfo.length; i++) {
      if (lineInfo[i].paragraph + chapterIndex - 1 < paragraph) {
        continue;
      } else if (lineInfo[i].paragraph + chapterIndex - 1 > paragraph) {
        break;
      }
      // print(lineInfo[i].paragraph);
      result = result + lineInfo[i].lineText;
    }

    // print(result);
    return result;
  }

  void _onClickMenuContent() {
    _showMenu = false;

    if (_showMenuTimer.isActive) {
      _showMenuTimer.cancel();
    }

    if (mounted) {
      setState(() {});
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentsScreen(
            onClickPage: (value) {
              print("onClickPage $value");
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
              if (mounted) {
                setState(() {});
              }
            },
            pagesIndex: _pageIndex),
      ),
    );
  }

  void _onClickMenuSetBookMark() {
    _showMenu = false;

    if (_showMenuTimer.isActive) {
      _showMenuTimer.cancel();
    }

    if (isStrongCodePage()) {
      int indexOfChapter = _currentPageNo - _pageIndex[13];
      int startIndex;
      int endIndex;
      int maxLines = (_settings.getStrongDicScreenHeight() / STRONG_DIC_ITEM_HEIGHT).floor();

      if (indexOfChapter == 1) {
        startIndex = 0;
        endIndex = startIndex + maxLines - 1;
      } else {
        startIndex = (maxLines * (indexOfChapter - 1)) - 1;
        endIndex = startIndex + maxLines;
      }

      bool isBookMarked = false;

      for (int i = startIndex; i < endIndex; i++) {
        if (i >= kStrongDic.length) {
          break;
        }

        if (_settings.isBookMarkPage(kStrongDic[i].code)) {
          isBookMarked = true;
          break;
        }
      }

      if (isBookMarked) {
        print('_onClickMenuSetBookMark() [Strong] isBookMarked is TRUE, remove bookMark');
        for (int i = startIndex; i < endIndex; i++) {
          if (_settings.isBookMarkPage(kStrongDic[i].code)) {
            _settings.setBookMarks(kStrongDic[i].code);
          }
        }
      } else {
        print('_onClickMenuSetBookMark() [Strong] isBookMarked is FALSE, Add New bookMark');
        _settings.setBookMarks(kStrongDic[startIndex].code);
      }

      if (mounted) {
        setState(() {});
      }

      return;
    }

    if (_firstParagraph == -1) {
      print('_onClickMenuSetBookMark() Not set _firstParagraph');
      return;
    }

    bool isBookMarked = false;

    for (int i = _firstParagraph; i <= _lastParagraph; i++) {
      if (_settings.isBookMarkPage(i)) {
        isBookMarked = true;
        break;
      }
    }

    if (isBookMarked) {
      print('_onClickMenuSetBookMark() isBookMarked is TRUE, remove bookMark');
      for (int i = _firstParagraph; i <= _lastParagraph; i++) {
        if (_settings.isBookMarkPage(i)) {
          _settings.setBookMarks(i);
        }
      }
    } else {
      print('_onClickMenuSetBookMark() isBookMarked is FALSE, Add New bookMark');
      _settings.setBookMarks(_firstParagraph);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onClickMenuSetFont() {
    _showMenu = false;

    if (_showMenuTimer.isActive) {
      _showMenuTimer.cancel();
    }

    _showFontSetPanel = true;
    if (mounted) {
      setState(() {});
    }
  }

  void _onClickMenuSetScroll() {
    print('onClickMenuSetScroll()');
    _showMenu = false;

    if (_showMenuTimer.isActive) {
      _showMenuTimer.cancel();
    }

    _showScrollSetPanel = true;
    if (mounted) {
      setState(() {});
    }
  }

  void _onClickMenuPdf() {
    print('onClickMenuPdf()');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _totalPageCounter,
              onPageChanged: _onPageChange,
              scrollDirection: _settings.getScrollVertical() ? Axis.vertical : Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox.expand(
                  child: getBodyText(index),
                );
              },
            ),
            if (!_isCopyMode) buildControlPanel(),
            if (_isCopyMode) buildCopyModeTitle(),
            if (_showFontSetPanel || _showScrollSetPanel)
              Container(
                color: Color(0x77000000),
              ),
            if (_showFontSetPanel) buildSetFontPanel(),
            if (_showScrollSetPanel) buildSetScrollPanel(),
          ],
        ),
      ),
    );
  }

  Widget buildCopyModeTitle() {
    return Positioned(
      top: 20,
      left: 0,
      child: Container(
        height: 24,
        width: _settings.getScreenWidth(),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.copy,
              color: Color(0xFF167EC7),
              size: 20,
            ),
            SizedBox(
              width: 6,
            ),
            Container(
              height: 24,
              padding: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Color(0xFF167EC7),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                "복사모드",
                style: TextStyle(
                  fontFamily: _settings.getFontName(),
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildControlPanel() {
    if (_currentPageNo > 3 + _headerPageCounter && _currentPageNo < _totalHeaderCounter - 1) {
      return Container();
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: _showMenu ? 70 : 0,
          curve: Curves.fastOutSlowIn,
          color: Color(0xFF167EC7),
          child: getTopMenu(),
        ),
        if (_settings.getScrollVertical())
          Expanded(
            child: SwipeDetector(
              onSwipeDown: () {
                _showMenu = false;

                if (_showMenuTimer.isActive) {
                  _showMenuTimer.cancel();
                }

                if (mounted) {
                  setState(() {});
                }

                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              onSwipeUp: () {
                _showMenu = false;

                if (_showMenuTimer.isActive) {
                  _showMenuTimer.cancel();
                }

                if (mounted) {
                  setState(() {});
                }

                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: GestureDetector(
                onLongPress: () {
                  print('onControl - onLongPress()');
                  _isCopyMode = true;

                  if (mounted) {
                    setState(() {});
                  }
                },
                onTap: () {
                  print('onControl - onTap $_currentPageNo $_totalHeaderCounter');
                  if (_currentPageNo < _totalHeaderCounter) {
                    return;
                  }

                  for (int i = 0; i < _pageIndex.length; i++) {
                    if (_currentPageNo == _pageIndex[i]) {
                      return;
                    }
                  }

                  _showMenu = true;
                  if (mounted) {
                    setState(() {});
                  }

                  if (_showMenuTimer.isActive) {
                    _showMenuTimer.cancel();
                  }

                  _showMenuTimer = new Timer(Duration(milliseconds: 2200), () {
                    _showMenu = false;
                    if (mounted) {
                      setState(() {});
                    }
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          )
        else
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 10,
                  child: SizedBox.expand(
                    child: GestureDetector(
                      onLongPress: () {
                        print('onControl - onLongPress()');
                        _isCopyMode = true;

                        if (mounted) {
                          setState(() {});
                        }
                      },
                      onTap: () {
                        _showMenu = false;

                        if (_showMenuTimer.isActive) {
                          _showMenuTimer.cancel();
                        }

                        if (mounted) {
                          setState(() {});
                        }

                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 12,
                  child: SizedBox.expand(
                    child: GestureDetector(
                      onLongPress: () {
                        print('onControl - onLongPress()');
                        _isCopyMode = true;

                        if (mounted) {
                          setState(() {});
                        }
                      },
                      onTap: () {
                        print('onControl - onTap $_currentPageNo $_totalHeaderCounter');
                        if (_currentPageNo < _totalHeaderCounter) {
                          return;
                        }

                        for (int i = 0; i < _pageIndex.length; i++) {
                          if (_currentPageNo == _pageIndex[i]) {
                            return;
                          }
                        }

                        _showMenu = true;
                        if (mounted) {
                          setState(() {});
                        }

                        if (_showMenuTimer.isActive) {
                          _showMenuTimer.cancel();
                        }

                        _showMenuTimer = new Timer(Duration(milliseconds: 2200), () {
                          _showMenu = false;
                          if (mounted) {
                            setState(() {});
                          }
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: SizedBox.expand(
                    child: GestureDetector(
                      onLongPress: () {
                        print('onControl - onLongPress()');
                        _isCopyMode = true;

                        if (mounted) {
                          setState(() {});
                        }
                      },
                      onTap: () {
                        _showMenu = false;

                        if (_showMenuTimer.isActive) {
                          _showMenuTimer.cancel();
                        }

                        if (mounted) {
                          setState(() {});
                        }

                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: _showMenu ? 70 : 0,
          curve: Curves.fastOutSlowIn,
          color: Color(0xFF167EC7),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getBottomMenuItem("목차", 'icon_content', _onClickMenuContent),
              getBottomMenuItem("북마크", 'icon_bookmark', _onClickMenuViewBookMark),
              getBottomMenuItem("폰트", 'icon_fontset', _onClickMenuSetFont),
              getBottomMenuItem("스크롤", 'icon_scroll', _onClickMenuSetScroll),
              getBottomMenuItem("PDF", 'icon_pdf', _onClickMenuPdf),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSetFontPanel() {
    String displayFontName = "";
    int displayFontSize = 0;

    switch (_setFontName) {
      case "notosans":
        displayFontName = "본고딕";
        break;

      case "notoserif":
        displayFontName = "본명조";
        break;

      case "gmarket":
        displayFontName = "지마켓산스";
        break;

      case "nexon":
        displayFontName = "넥슨Lv1고딕";
        break;

      case "gowun":
        displayFontName = "고운돋움";
        break;

      case "kyobo":
        displayFontName = "교보손글씨";
        break;

      default:
        displayFontName = "시스템폰트";
        break;
    }

    if (_setFontSize == FONT_SIZE_1) {
      displayFontSize = 1;
    } else if (_setFontSize == FONT_SIZE_2) {
      displayFontSize = 2;
    } else if (_setFontSize == FONT_SIZE_3) {
      displayFontSize = 3;
    } else if (_setFontSize == FONT_SIZE_4) {
      displayFontSize = 4;
    } else if (_setFontSize == FONT_SIZE_5) {
      displayFontSize = 5;
    } else if (_setFontSize == FONT_SIZE_6) {
      displayFontSize = 6;
    }

    return Positioned(
      bottom: 30,
      left: 0,
      child: Container(
        width: _settings.getScreenWidth() - 48,
        height: 568,
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color(0xFF167EC7),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF167EC7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "미리보기",
                      style: TextStyle(
                        fontFamily: _settings.getFontName(),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 305,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 6,
                          text: TextSpan(
                            text: "그때부터 예수님은 “",
                            style: TextStyle(
                              fontFamily: _setFontName,
                              fontSize: _setFontSize,
                              color: Colors.black,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: "회개해라! 하늘들의 왕국이 가까왔기 때문이다.",
                                style: TextStyle(
                                  fontFamily: _setFontName,
                                  fontSize: _setFontSize,
                                  color: Colors.red,
                                ),
                              ),
                              TextSpan(
                                text: "”라고 전파하시며 말씀하시기 시작하셨습니다",
                                style: TextStyle(
                                  fontFamily: _setFontName,
                                  fontSize: _setFontSize,
                                  color: Colors.black,
                                ),
                              ),
                              // TextSpan(
                              //   text: "\n예수님께서 갈릴리 바닷가를 걸으시다가 바다로 그물을 던지는 두 형제 곧 베드로라 하는 시몬과 그의 형제 안드레를 보셨습니다. 그들이 어부였기에 그들에게 말씀하십니다. “",
                              //   style: TextStyle(
                              //     fontFamily: _setFontName,
                              //     fontSize: _setFontSize,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              // TextSpan(
                              //   text: "나를 뒤쫓아 와라! 너희를 사람들의 어부들로 만들 것이다.",
                              //   style: TextStyle(
                              //     fontFamily: _setFontName,
                              //     fontSize: _setFontSize,
                              //     color: Colors.red,
                              //   ),
                              // ),
                              // TextSpan(
                              //   text: "”",
                              //   style: TextStyle(
                              //     fontFamily: _setFontName,
                              //     fontSize: _setFontSize,
                              //     color: Colors.black,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 30,
              color: Colors.transparent,
            ),
            Container(
              height: 6,
              color: Color(0xFF167EC7),
            ),
            Container(
              height: 132,
              color: Color(0xFFEDEDED),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "글  꼴",
                        style: TextStyle(
                          fontFamily: _settings.getFontName(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF167EC7),
                        ),
                      ),
                      SizedBox(width: 14),
                      GestureDetector(
                        onTap: () async {
                          final resultStr = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FontSetDialog();
                            },
                            barrierDismissible: false,
                          );

                          print(resultStr);
                          if (resultStr != null && resultStr.isNotEmpty) {
                            _setFontName = resultStr;
                          }

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 252,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Color(0xFF167EC7),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 8,
                                  ),
                                  child: Text(
                                    displayFontName,
                                    style: TextStyle(
                                      fontFamily: _setFontName,
                                      fontSize: 16,
                                      color: Color(0xFF7B7979),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  right: 8,
                                ),
                                child: Icon(
                                  Icons.expand_more_outlined,
                                  size: 24,
                                  color: Color(0xFF7B7979),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "크  기",
                        style: TextStyle(
                          fontFamily: _settings.getFontName(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF167EC7),
                        ),
                      ),
                      SizedBox(width: 14),
                      Container(
                        width: 46,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Color(0xFF167EC7),
                            width: 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          displayFontSize.toString(),
                          style: TextStyle(
                            fontFamily: _settings.getFontName(),
                            fontSize: 16,
                            color: Color(0xFF7B7979),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          displayFontSize--;

                          if (displayFontSize <= 0) {
                            displayFontSize = 1;
                          }

                          if (displayFontSize == 1) {
                            _setFontSize = FONT_SIZE_1;
                          } else if (displayFontSize == 2) {
                            _setFontSize = FONT_SIZE_2;
                          } else if (displayFontSize == 3) {
                            _setFontSize = FONT_SIZE_3;
                          } else if (displayFontSize == 4) {
                            _setFontSize = FONT_SIZE_4;
                          } else if (displayFontSize == 5) {
                            _setFontSize = FONT_SIZE_5;
                          } else if (displayFontSize == 6) {
                            _setFontSize = FONT_SIZE_6;
                          }

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 97,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                            ),
                            border: Border.all(
                              color: Color(0xFF167EC7),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/minus.png',
                            height: 20,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          displayFontSize++;

                          if (displayFontSize >= 6) {
                            displayFontSize = 6;
                          }

                          if (displayFontSize == 1) {
                            _setFontSize = FONT_SIZE_1;
                          } else if (displayFontSize == 2) {
                            _setFontSize = FONT_SIZE_2;
                          } else if (displayFontSize == 3) {
                            _setFontSize = FONT_SIZE_3;
                          } else if (displayFontSize == 4) {
                            _setFontSize = FONT_SIZE_4;
                          } else if (displayFontSize == 5) {
                            _setFontSize = FONT_SIZE_5;
                          } else if (displayFontSize == 6) {
                            _setFontSize = FONT_SIZE_6;
                          }

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 97,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0xFF167EC7),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                            border: Border.all(
                              color: Color(0xFF167EC7),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/plus.png',
                            height: 20,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Color(0xFFD0D0D0),
                    height: 6,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color(0xFF65CCFF),
                    height: 6,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showFontSetPanel = false;

                      _setFontSize = _settings.getFontSize();
                      _setFontName = _settings.getFontName();

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: Color(0xFF7B7979),
                      height: 44,
                      alignment: Alignment.center,
                      child: Text(
                        "취소",
                        style: TextStyle(fontFamily: _settings.getFontName(), fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      _showFontSetPanel = false;

                      _settings.setFontSize(_setFontSize);
                      _settings.setFontName(_setFontName);

                      _settings.initPageInfo();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataInit(removeThisWidget: true)),
                      );

                      calculatorPageInfo();

                      int currentParagraph = Hive.box("matthew").get("currentParagraph") ?? -1;
                      String currentStrongCode = Hive.box("matthew").get("currentStrongCode") ?? "";

                      if (currentParagraph != -1) {
                        jumpToPageByParagraph(currentParagraph);
                      } else if (currentStrongCode.isNotEmpty) {
                        jumpToPageByStrongCode(currentStrongCode);
                      } else {
                        print("INVALID STATUS, currentParagraph $currentParagraph, currentStrongCode $currentStrongCode");
                        _pageController.jumpToPage(0);
                        _currentPageNo = 0;
                      }

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: Color(0xFF167EC7),
                      height: 44,
                      alignment: Alignment.center,
                      child: Text(
                        "확인",
                        style: TextStyle(fontFamily: _settings.getFontName(), fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSetScrollPanel() {
    return Positioned(
      bottom: 30,
      left: 0,
      child: Container(
        width: _settings.getScreenWidth() - 48,
        height: 188,
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Container(
              height: 6,
              color: Color(0xFF167EC7),
            ),
            Container(
              height: 132,
              color: Color(0xFFEDEDED),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _setScrollVertical = false;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/scroll_set_horizontal.png",
                              height: 52,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 22,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    _setScrollVertical ? "assets/images/circle_unselected.png" : "assets/images/circle_selected.png",
                                    height: 18,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  height: 22,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "가  로",
                                    style: TextStyle(
                                      fontFamily: _settings.getFontName(),
                                      fontSize: 16,
                                      color: Color(0xFF142A4D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _setScrollVertical = true;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/scroll_set_vertical.png",
                              height: 52,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 22,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    _setScrollVertical ? "assets/images/circle_selected.png" : "assets/images/circle_unselected.png",
                                    height: 18,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  height: 22,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "세  로",
                                    style: TextStyle(
                                      fontFamily: _settings.getFontName(),
                                      fontSize: 16,
                                      color: Color(0xFF142A4D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Color(0xFFD0D0D0),
                    height: 6,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color(0xFF65CCFF),
                    height: 6,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showScrollSetPanel = false;
                      _setScrollVertical = _settings.getScrollVertical();

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: Color(0xFF7B7979),
                      height: 44,
                      alignment: Alignment.center,
                      child: Text(
                        "취소",
                        style: TextStyle(fontFamily: _settings.getFontName(), fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showScrollSetPanel = false;
                      _settings.setScrollVertical(_setScrollVertical);

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: Color(0xFF167EC7),
                      height: 44,
                      alignment: Alignment.center,
                      child: Text(
                        "확인",
                        style: TextStyle(fontFamily: _settings.getFontName(), fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTopMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: !_showMenu
              ? Container()
              : Container(
                  alignment: Alignment.center,
                  child: Slider(
                    activeColor: Color(0xFF65CCFF),
                    inactiveColor: Color(0xFFD0D0D0),
                    value: _currentPageNo.toDouble(),
                    min: 0,
                    max: _totalPageCounter.toDouble(),
                    onChanged: (double newValue) {
                      setState(() {
                        _currentPageNo = newValue.toInt();
                      });
                    },
                    onChangeStart: (value) {
                      if (_showMenuTimer.isActive) {
                        _showMenuTimer.cancel();
                      }
                    },
                    onChangeEnd: (value) {
                      print('onChangeEnd $value');
                      if (_showMenuTimer.isActive) {
                        _showMenuTimer.cancel();
                      }

                      _showMenuTimer = new Timer(Duration(milliseconds: 1500), () {
                        _showMenu = false;
                        if (mounted) {
                          setState(() {});
                        }
                      });

                      _pageController.jumpToPage(value.toInt());
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            _onClickMenuSearch();
          },
          child: Container(
            width: 55,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/icon_search.png",
              height: 24,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _onClickMenuSetBookMark();
          },
          child: Container(
            width: 55,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/icon_bookmark.png",
              height: 24,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }

  Widget getBottomMenuItem(String title, String icon, Function onClick) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 2,
              ),
              Image.asset(
                "assets/images/$icon.png",
                height: 24,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                title,
                style: _settings.getCustomFontStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void jumpToPageByParagraph(int paragraph) {
    print('jumpToPageByParagraph paragraph $paragraph');

    int pageNo;

    if (paragraph <= -100) {
      pageNo = (paragraph + 100) * -1;
    } else {
      pageNo = getPageNoByParagraph(paragraph);
      print('jumpToPageByParagraph pageNo $pageNo');
      if (pageNo <= 0) {
        pageNo = 0;
      }
    }

    if (_pageController.hasClients) {
      _pageController.jumpToPage(pageNo);
      _currentPageNo = pageNo;
    } else {
      Future.delayed(Duration(milliseconds: 300), () {
        _pageController.jumpToPage(pageNo);
        _currentPageNo = pageNo;
      });
    }
  }

  void jumpToPageByStrongCode(String code) {
    int pageNo = getPageNoByStrongDicCode(code);
    print('jumpToPageByStrongCode code $code pageNo $pageNo');
    if (pageNo <= 0) {
      pageNo = 0;
    }

    if (_pageController.hasClients) {
      _pageController.jumpToPage(pageNo);
      _currentPageNo = pageNo;
    } else {
      Future.delayed(Duration(milliseconds: 300), () {
        _pageController.jumpToPage(pageNo);
        _currentPageNo = pageNo;
      });
    }
  }

  int isChapterTitlePage(int pageNo) {
    int result = 0;

    for (int i = 0; i < _pageIndex.length; i++) {
      if (pageNo == _pageIndex[i]) {
        result = i;
        break;
      }
    }

    return result * -1;
  }

  int getChapterNoByParagraph(int paragraph) {
    int retValue = 12;
    for (int i = 1; i < kStartParagraph.length; i++) {
      if (paragraph < kStartParagraph[i]) {
        retValue = i;
        break;
      }
    }
    return retValue;
  }

  int getPageNoByParagraph(int paragraph) {
    if (paragraph < 0) {
      paragraph = paragraph * -1;
      return _pageIndex[paragraph];
    }

    int chapterNo = getChapterNoByParagraph(paragraph);
    int startPageIndex = _pageIndex[chapterNo];
    List<LineInfo> lineInfoList = getLineInfoList(startPageIndex);
    int maxLines = _settings.getMaxLines(_settings.getFontSize());
    int offset = ((maxLines / 3) * 2).floor();

    // print('getPageNoByParagraph $paragraph');
    // print('chapterNo $chapterNo, startPageIndex, $startPageIndex, maxLines $maxLines, offset $offset');

    int pageOffset = 1;
    int lineCounter = maxLines - offset;

    for (int i = 0; i < lineInfoList.length; i++) {
      if ((kStartParagraph[chapterNo - 1] + lineInfoList[i].paragraph - 1) == paragraph) {
        break;
      }

      lineCounter++;

      if (lineCounter >= maxLines) {
        pageOffset++;
        lineCounter = 0;
      }
    }

    return startPageIndex + pageOffset;
  }

  void _copyToClipboardOnStrongDic(String copyText) {
    FlutterClipboard.copy(copyText).then((value) {
      print('onTap() paragraph copy :$copyText');

      String codeStr = copyText.substring(0, copyText.indexOf(":"));

      Fluttertoast.showToast(
          msg: "  [$codeStr]코드가 복사되었습니다.  ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0x99000000),
          textColor: Colors.white,
          fontSize: 14.0);
    });

    _isCopyMode = false;
    if (mounted) {
      setState(() {});
    }
  }

  Widget getBodyText(int index) {
    // print('_totalHeaderCounter $_totalHeaderCounter');
    // Header Page 가져오기
    if (index < _totalHeaderCounter) {
      return _headerPage.getHeaderPage(index, _headerPageCounter, _contentCounter, _pageIndex, (value) {
        print("onClickPage $value");
        _pageController.animateToPage(
          value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        if (mounted) {
          setState(() {});
        }
      }, () {
        if (_settings.getScrollVertical()) {
          return;
        }
        print('prevPage');
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        if (mounted) {
          setState(() {});
        }
      }, () {
        if (_settings.getScrollVertical()) {
          return;
        }
        print('nextPage');
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        if (mounted) {
          setState(() {});
        }
      });
    }

    // print('_pageIndex[13] ${_pageIndex[13]} _pageIndex[14] ${_pageIndex[14]}');
    // print('totalPageCounter $_totalPageCounter');

    if (index >= _pageIndex[13] && index < _pageIndex[14]) {
      return _headerPage.getStrongDicPage(index, _pageIndex[13], _isCopyMode, _copyToClipboardOnStrongDic);
    }

    if (index >= _pageIndex[14]) {
      return _headerPage.getEndedPage(index, _pageIndex[14], _totalPageCounter);
    }

    List<Widget> lines = [];
    int chapterIndex = getChapterIndex(index);
    int indexOfChapter = getPageIndexCounter(index);
    List<LineInfo> lineInfoList = getLineInfoList(index);

    int maxLines = _settings.getMaxLines(_settings.getFontSize());
    double cellHeight = _settings.getSafeScreenHeight() / maxLines;
    int offset = ((maxLines / 3) * 2).floor();

    int startIndex;
    int endIndex;

    // 각 장의 첫 페이지, 파란 바탕에 제목
    if (indexOfChapter == 0) {
      return buildChapterTitle(chapterIndex);
    }

    // 각 장의 내용 첫 페이지, 상단에 n장 표시
    if (indexOfChapter == 1) {
      lines.add(
        buildChapterInnerTitle(cellHeight, maxLines, offset, chapterIndex),
      );

      startIndex = 0;
      endIndex = offset;
    } else {
      startIndex = ((indexOfChapter - 2) * maxLines) + offset;
      endIndex = startIndex + maxLines;
    }

    _firstParagraph = -1;
    _lastParagraph = -1;

    bool displayBookMark = false;

    for (int i = startIndex; i < endIndex; i++) {
      if (i >= lineInfoList.length) {
        lines.add(
          SizedBox(
            height: cellHeight,
          ),
        );
        continue;
      }

      if (lineInfoList[i].lineText.isEmpty) {
        if (i == startIndex || i == endIndex - 1) {
          continue;
        }
      }

      if (_firstParagraph == -1) {
        if (i == 0 || lineInfoList[i].paragraph != lineInfoList[i - 1].paragraph) {
          _firstParagraph = kStartParagraph[chapterIndex - 1] + lineInfoList[i].paragraph - 1;
        }
      }

      _lastParagraph = kStartParagraph[chapterIndex - 1] + lineInfoList[i].paragraph - 1;

      if (!displayBookMark) {
        if (_settings.isBookMarkPage(kStartParagraph[chapterIndex - 1] + lineInfoList[i].paragraph - 1)) {
          displayBookMark = true;
        }
      }

      double paragraphFontSize = _settings.getFontSize();
      if (paragraphFontSize > 20) {
        paragraphFontSize = 20;
      }

      lines.add(
        Row(
          children: [
            if (i == 0 || lineInfoList[i].paragraph != lineInfoList[i - 1].paragraph)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      int paragraphNo = kStartParagraph[chapterIndex - 1] + lineInfoList[i].paragraph - 1;
                      String copyText = getParagraphStrByNumber(paragraphNo);

                      FlutterClipboard.copy(copyText).then((value) {
                        print('onTap() paragraph copy :$copyText');
                        Fluttertoast.showToast(
                            msg: "  [$paragraphNo]절이 복사되었습니다.  ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0x99000000),
                            textColor: Colors.white,
                            fontSize: 14.0);
                      });

                      _isCopyMode = false;

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: LABEL_WIDTH - 10,
                      height: cellHeight,
                      decoration: BoxDecoration(
                        color: (!_isCopyMode) ? Colors.white : Color(0xFFFCFCD5),
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFFDBB37D),
                            width: 1.0,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getParagraphsStr(kStartParagraph[chapterIndex - 1] + lineInfoList[i].paragraph - 1),
                        style: TextStyle(
                          fontFamily: _settings.getFontName(),
                          fontSize: paragraphFontSize,
                          color: Color(0xFF00AB4E),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.9,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: LABEL_WIDTH - 10,
                height: cellHeight,
              ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                height: cellHeight,
                child: buildLineText(lineInfoList, i),
                // child: buildNormalText(lineInfoList, i, Colors.black),
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: _settings.getHorizontalSpace(),
            vertical: _settings.getVerticalSpace(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: lines,
          ),
        ),
        if (displayBookMark)
          Positioned(
            top: 12,
            right: _settings.getHorizontalSpace(),
            child: Image.asset(
              "assets/images/bookmark.png",
              height: 48,
              fit: BoxFit.fitHeight,
            ),
          ),
      ],
    );
  }

  bool isStrongCodePage() {
    if (_currentPageNo >= _pageIndex[13] && _currentPageNo < _pageIndex[14]) {
      return true;
    }

    return false;
  }

  RichText buildLineText(List<LineInfo> lineInfoList, int i) {
    List<ParaFormat> paraFormats = getRedColorText(lineInfoList[i]);

    Color textColor = Colors.black;

    if (paraFormats.length == 0) {
      return buildNormalText(lineInfoList, i, textColor);
    }

    ParaFormat paraFormat = paraFormats[0];

    if (paraFormat.body.isEmpty) {
      if (paraFormat.body.isEmpty) {
        textColor = FONT_RED_COLOR;
      }
      return buildNormalText(lineInfoList, i, textColor);
    }

    String lineStr = lineInfoList[i].lineText;

    paraFormat.startIndex = paraFormat.body.indexOf(paraFormat.redStr);
    paraFormat.endIndex = paraFormat.startIndex + paraFormat.redStr.length;

    int lineStartIndex = paraFormat.body.indexOf(lineInfoList[i].lineText);

    if (lineStr.length < 5 && i != 0) {
      lineStartIndex = paraFormat.body.indexOf(lineInfoList[i - 1].lineText + lineInfoList[i].lineText) + lineInfoList[i - 1].lineText.length;
    }

    int lineEndIndex = lineStartIndex + lineInfoList[i].lineText.length;

    // print('------------------------------------------------------------------');
    // print('paragraphNo ${paraFormat.paragraph}');
    // print('lineStr $lineStr');
    // print(
    //     "startIndex:${paraFormat.startIndex}, endIndex:${paraFormat.endIndex}," +
    //         "lineStartIndex:$lineStartIndex, lineEndIndex:$lineEndIndex");

    if (paraFormat.startIndex > lineEndIndex || paraFormat.endIndex < lineStartIndex) {
      // print('CASE 0 : All black color');
      if (paraFormats.length == 1) {
        return buildNormalText(lineInfoList, i, Colors.black);
      } else {
        List<TextSpan> textSpans = buildTextSpans(paraFormats[1], lineStr, (i == 0) ? "" : lineInfoList[i - 1].lineText);

        textSpans.add(
          TextSpan(
            text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
            style: _settings.getFontStyle(
              color: Colors.transparent,
            ),
          ),
        );

        return RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: "",
            style: _settings.getFontStyle(
              color: Colors.transparent,
            ),
            children: textSpans.toList(),
          ),
        );
      }
    }

    if (lineStartIndex >= paraFormat.startIndex) {
      if (lineEndIndex <= paraFormat.endIndex) {
        // print('CASE 1 : All red color');
        return buildNormalText(lineInfoList, i, FONT_RED_COLOR);
      } else {
        // print('CASE 2          LLLLLLLLLLL');
        // print('CASE 2     RRRRRRRRRRR');

        if (paraFormats.length == 1) {
          return RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: lineStr.substring(0, paraFormat.endIndex - lineStartIndex),
              style: _settings.getFontStyle(
                color: FONT_RED_COLOR,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: lineStr.substring(paraFormat.endIndex - lineStartIndex,
                      paraFormat.endIndex - lineStartIndex + lineStr.length - (paraFormat.endIndex - lineStartIndex)),
                  style: _settings.getFontStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
                  style: _settings.getFontStyle(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          );
        } else {
          List<TextSpan> textSpans = buildTextSpans(
              paraFormats[1],
              lineStr.substring(paraFormat.endIndex - lineStartIndex,
                  paraFormat.endIndex - lineStartIndex + lineStr.length - (paraFormat.endIndex - lineStartIndex)),
              lineStr.substring(0, paraFormat.endIndex - lineStartIndex));

          textSpans.add(
            TextSpan(
              text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
              style: _settings.getFontStyle(
                color: Colors.transparent,
              ),
            ),
          );

          textSpans.insert(
            0,
            TextSpan(
              text: lineStr.substring(0, paraFormat.endIndex - lineStartIndex),
              style: _settings.getFontStyle(
                color: FONT_RED_COLOR,
              ),
            ),
          );

          return RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: "",
              style: _settings.getFontStyle(
                color: Colors.transparent,
              ),
              children: textSpans.toList(),
            ),
          );
        }
      }
    }

    if (lineStartIndex <= paraFormat.startIndex) {
      if (lineEndIndex <= paraFormat.endIndex) {
        // print('CASE 3          LLLLLLLLLLL');
        // print('CASE 3               RRRRRRRRRRR');
        return RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: lineStr.substring(0, paraFormat.startIndex - lineStartIndex),
            style: _settings.getFontStyle(
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: lineStr.substring(paraFormat.startIndex - lineStartIndex,
                    paraFormat.startIndex - lineStartIndex + lineStr.length - (paraFormat.startIndex - lineStartIndex)),
                style: _settings.getFontStyle(
                  color: FONT_RED_COLOR,
                ),
              ),
              TextSpan(
                text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
                style: _settings.getFontStyle(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        );
      } else {
        // print('CASE 4          LLLLLLLLLLL');
        // print('CASE 4             RRRRR');
        if (paraFormats.length == 1) {
          return RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: lineStr.substring(0, paraFormat.startIndex - lineStartIndex),
              style: _settings.getFontStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      lineStr.substring(paraFormat.startIndex - lineStartIndex, (paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length),
                  style: _settings.getFontStyle(
                    color: FONT_RED_COLOR,
                  ),
                ),
                TextSpan(
                  text: lineStr.substring(
                      (paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length,
                      (paraFormat.startIndex - lineStartIndex) +
                          paraFormat.redStr.length +
                          lineStr.length -
                          ((paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length)),
                  style: _settings.getFontStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
                  style: _settings.getFontStyle(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          );
        } else {
          List<TextSpan> textSpans = buildTextSpans(
              paraFormats[1],
              lineStr.substring(
                  (paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length,
                  (paraFormat.startIndex - lineStartIndex) +
                      paraFormat.redStr.length +
                      lineStr.length -
                      ((paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length)),
              lineStr.substring(0, (paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length));

          textSpans.add(
            TextSpan(
              text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
              style: _settings.getFontStyle(
                color: Colors.transparent,
              ),
            ),
          );

          textSpans.insert(
              0,
              TextSpan(
                text: lineStr.substring(paraFormat.startIndex - lineStartIndex, (paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length),
                style: _settings.getFontStyle(
                  color: FONT_RED_COLOR,
                ),
              ));

          textSpans.insert(
            0,
            TextSpan(
              text: lineStr.substring(0, paraFormat.startIndex - lineStartIndex),
              style: _settings.getFontStyle(
                color: Colors.black,
              ),
            ),
          );

          return RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: "",
              style: _settings.getFontStyle(
                color: Colors.transparent,
              ),
              children: textSpans.toList(),
            ),
          );
        }
      }
    }

    // print('CASE 5 : Not checked');
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        text: lineInfoList[i].lineText,
        style: _settings.getFontStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
            style: _settings.getFontStyle(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> buildTextSpans(ParaFormat paraFormat, String lineText, String beforeLineText) {
    Color textColor = Colors.black;

    if (paraFormat.body.isEmpty) {
      textColor = FONT_RED_COLOR;
      return buildNormalTextSpans(lineText, textColor);
    }

    paraFormat.startIndex = paraFormat.body.indexOf(paraFormat.redStr);
    paraFormat.endIndex = paraFormat.startIndex + paraFormat.redStr.length;

    int lineStartIndex = paraFormat.body.indexOf(lineText);

    if (lineText.length < 5) {
      lineStartIndex = paraFormat.body.indexOf(beforeLineText + lineText) + beforeLineText.length;
    }

    int lineEndIndex = lineStartIndex + lineText.length;

    if (paraFormat.startIndex > lineEndIndex || paraFormat.endIndex < lineStartIndex) {
      return buildNormalTextSpans(lineText, Colors.black);
    }

    if (lineStartIndex >= paraFormat.startIndex) {
      if (lineEndIndex <= paraFormat.endIndex) {
        return buildNormalTextSpans(lineText, FONT_RED_COLOR);
      } else {
        List<TextSpan> result = [];

        result.add(
          TextSpan(
            text: lineText.substring(0, paraFormat.endIndex - lineStartIndex),
            style: _settings.getFontStyle(
              color: FONT_RED_COLOR,
            ),
          ),
        );

        result.add(
          TextSpan(
            text: lineText.substring(paraFormat.endIndex - lineStartIndex,
                paraFormat.endIndex - lineStartIndex + lineText.length - (paraFormat.endIndex - lineStartIndex)),
            style: _settings.getFontStyle(
              color: Colors.black,
            ),
          ),
        );

        return result;
      }
    }

    if (lineStartIndex <= paraFormat.startIndex) {
      if (lineEndIndex <= paraFormat.endIndex) {
        List<TextSpan> result = [];

        result.add(
          TextSpan(
            text: lineText.substring(0, paraFormat.startIndex - lineStartIndex),
            style: _settings.getFontStyle(
              color: Colors.black,
            ),
          ),
        );

        result.add(
          TextSpan(
            text: lineText.substring(paraFormat.startIndex - lineStartIndex,
                paraFormat.startIndex - lineStartIndex + lineText.length - (paraFormat.startIndex - lineStartIndex)),
            style: _settings.getFontStyle(
              color: FONT_RED_COLOR,
            ),
          ),
        );

        return result;
      } else {
        List<TextSpan> result = [];

        result.add(
          TextSpan(
            text: lineText.substring(0, paraFormat.startIndex - lineStartIndex),
            style: _settings.getFontStyle(
              color: Colors.black,
            ),
          ),
        );

        result.add(
          TextSpan(
            text: lineText.substring(paraFormat.startIndex - lineStartIndex, (paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length),
            style: _settings.getFontStyle(
              color: FONT_RED_COLOR,
            ),
          ),
        );

        result.add(
          TextSpan(
            text: lineText.substring(
                (paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length,
                (paraFormat.startIndex - lineStartIndex) +
                    paraFormat.redStr.length +
                    lineText.length -
                    ((paraFormat.startIndex - lineStartIndex) + paraFormat.redStr.length)),
            style: _settings.getFontStyle(
              color: Colors.black,
            ),
          ),
        );

        return result;
      }
    }

    return buildNormalTextSpans(lineText, Colors.black);
  }

  RichText buildNormalText(List<LineInfo> lineInfoList, int i, Color color) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        text: lineInfoList[i].lineText,
        style: _settings.getFontStyle(
          color: color,
        ),
        children: <TextSpan>[
          TextSpan(
            text: (i == (lineInfoList.length - 1)) ? lineInfoList[0].lineText : lineInfoList[i + 1].lineText,
            style: _settings.getFontStyle(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> buildNormalTextSpans(String lineText, Color color) {
    List<TextSpan> result = [];

    result.add(TextSpan(
      text: lineText,
      style: _settings.getFontStyle(
        color: color,
      ),
    ));

    return result;
  }

  List<ParaFormat> getRedColorText(LineInfo lineInfo) {
    List<ParaFormat> result = [];

    int paragraphOfLine = lineInfo.paragraph + kStartParagraph[lineInfo.chapter - 1] - 1;

    List<ParaFormat> redTexts = kRedTexts[lineInfo.chapter - 1];
    for (int i = 0; i < redTexts.length; i++) {
      if (paragraphOfLine == redTexts[i].paragraph) {
        result.add(redTexts[i]);
      }

      if (paragraphOfLine < redTexts[i].paragraph) {
        break;
      }
    }
    return result;
  }

  Container buildChapterInnerTitle(double cellHeight, int maxLines, int offset, int chapterIndex) {
    return Container(
      height: cellHeight * (maxLines - offset),
      width: _settings.getScreenWidth(),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/chapter_sub_title.png',
              height: 157.3,
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 64,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(left: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          chapterIndex.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: 'notoserif',
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF142A4D),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "장",
                          style: TextStyle(
                            fontFamily: 'notoserif',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF142A4D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getParagraphsStr(int index) {
    if (index < 10) {
      return "0$index";
    }

    return index.toString();
  }

  Container buildChapterTitle(int chapterIndex) {
    return Container(
      width: _settings.getSafeScreenWidth(),
      height: _settings.getSafeScreenHeight(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chapter_title_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.centerRight,
      child: Container(
        width: 294,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/chapter_title_$chapterIndex.png',
                  height: 90.7,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(width: 1),
                Text(
                  "장",
                  style: _settings.getCustomFontStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.7),
            Container(
              color: Color(0xFF65CCFF),
              height: 1,
              width: 294,
            ),
            Container(
              height: 34,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    kChapterParagraphs[chapterIndex - 1],
                    style: _settings.getCustomFontStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      kChapterSubPara[chapterIndex - 1],
                      style: _settings.getCustomFontStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFF65CCFF),
              height: 1,
              width: 294,
            ),
            Container(
              height: 34,
              alignment: Alignment.centerLeft,
              child: Text(
                kChapterTitle[chapterIndex - 1],
                style: _settings.getCustomFontStyle(
                  fontSize: 14,
                  color: Color(0xFFDCB27D),
                ),
              ),
            ),
            Container(
              color: Color(0xFF65CCFF),
              height: 1,
              width: 294,
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }

  int getChapterIndex(int index) {
    int tmpIndex = index;

    if (tmpIndex < _totalHeaderCounter) {
      return 0;
    }

    tmpIndex -= _totalHeaderCounter;
    if (tmpIndex < _chapter1PageCounter) {
      return 1;
    }

    tmpIndex -= _chapter1PageCounter;
    if (tmpIndex < _chapter2PageCounter) {
      return 2;
    }

    tmpIndex -= _chapter2PageCounter;
    if (tmpIndex < _chapter3PageCounter) {
      return 3;
    }

    tmpIndex -= _chapter3PageCounter;
    if (tmpIndex < _chapter4PageCounter) {
      return 4;
    }

    tmpIndex -= _chapter4PageCounter;
    if (tmpIndex < _chapter5PageCounter) {
      return 5;
    }

    tmpIndex -= _chapter5PageCounter;
    if (tmpIndex < _chapter6PageCounter) {
      return 6;
    }

    tmpIndex -= _chapter6PageCounter;
    if (tmpIndex < _chapter7PageCounter) {
      return 7;
    }

    tmpIndex -= _chapter7PageCounter;
    if (tmpIndex < _chapter8PageCounter) {
      return 8;
    }

    tmpIndex -= _chapter8PageCounter;
    if (tmpIndex < _chapter9PageCounter) {
      return 9;
    }

    tmpIndex -= _chapter9PageCounter;
    if (tmpIndex < _chapter10PageCounter) {
      return 10;
    }

    tmpIndex -= _chapter10PageCounter;
    if (tmpIndex < _chapter11PageCounter) {
      return 11;
    }

    tmpIndex -= _chapter11PageCounter;
    if (tmpIndex < _chapter12PageCounter) {
      return 12;
    }

    return 13;
  }

  List<LineInfo> getLineInfoList(int index) {
    int tmpIndex = index;

    if (tmpIndex < _totalHeaderCounter) {
      return [];
    }

    tmpIndex -= _totalHeaderCounter;
    if (tmpIndex < _chapter1PageCounter) {
      return _lineInfoChapter1;
    }

    tmpIndex -= _chapter1PageCounter;
    if (tmpIndex < _chapter2PageCounter) {
      return _lineInfoChapter2;
    }

    tmpIndex -= _chapter2PageCounter;
    if (tmpIndex < _chapter3PageCounter) {
      return _lineInfoChapter3;
    }

    tmpIndex -= _chapter3PageCounter;
    if (tmpIndex < _chapter4PageCounter) {
      return _lineInfoChapter4;
    }

    tmpIndex -= _chapter4PageCounter;
    if (tmpIndex < _chapter5PageCounter) {
      return _lineInfoChapter5;
    }

    tmpIndex -= _chapter5PageCounter;
    if (tmpIndex < _chapter6PageCounter) {
      return _lineInfoChapter6;
    }

    tmpIndex -= _chapter6PageCounter;
    if (tmpIndex < _chapter7PageCounter) {
      return _lineInfoChapter7;
    }

    tmpIndex -= _chapter7PageCounter;
    if (tmpIndex < _chapter8PageCounter) {
      return _lineInfoChapter8;
    }

    tmpIndex -= _chapter8PageCounter;
    if (tmpIndex < _chapter9PageCounter) {
      return _lineInfoChapter9;
    }

    tmpIndex -= _chapter9PageCounter;
    if (tmpIndex < _chapter10PageCounter) {
      return _lineInfoChapter10;
    }

    tmpIndex -= _chapter10PageCounter;
    if (tmpIndex < _chapter11PageCounter) {
      return _lineInfoChapter11;
    }

    tmpIndex -= _chapter11PageCounter;
    if (tmpIndex < _chapter12PageCounter) {
      return _lineInfoChapter12;
    }

    tmpIndex -= _chapter12PageCounter;
    if (tmpIndex < _strongDicPageCounter) {
      return _lineInfoEnded;
    }

    return _lineInfoEnded;
  }

  int getPageIndexCounter(int index) {
    int tmpIndex = index;

    if (tmpIndex < _totalHeaderCounter) {
      return _totalHeaderCounter;
    }

    tmpIndex -= _totalHeaderCounter;
    if (tmpIndex < _chapter1PageCounter) {
      return index - _totalHeaderCounter;
    }

    tmpIndex -= _chapter1PageCounter;
    if (tmpIndex < _chapter2PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter2PageCounter;
    if (tmpIndex < _chapter3PageCounter) {
      return tmpIndex;
    }
    tmpIndex -= _chapter3PageCounter;
    if (tmpIndex < _chapter4PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter4PageCounter;
    if (tmpIndex < _chapter5PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter5PageCounter;
    if (tmpIndex < _chapter6PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter6PageCounter;
    if (tmpIndex < _chapter7PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter7PageCounter;
    if (tmpIndex < _chapter8PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter8PageCounter;
    if (tmpIndex < _chapter9PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter9PageCounter;
    if (tmpIndex < _chapter10PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter10PageCounter;
    if (tmpIndex < _chapter11PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter11PageCounter;
    if (tmpIndex < _chapter12PageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _chapter12PageCounter;
    if (tmpIndex < _strongDicPageCounter) {
      return tmpIndex;
    }

    tmpIndex -= _strongDicPageCounter;
    return tmpIndex;
  }
}
