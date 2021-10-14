import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:matthew/dialog/font_set_dialog.dart';
import 'package:matthew/models/bookmark_model.dart';
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
  List<LineInfo> _lineInfoStrongDic = [];

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

    int currentParagraph = Hive.box("matthew").get("currentParagraph") ?? 0;
    print('currentParagraph $currentParagraph');
    jumpToPage(currentParagraph);
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

    print('_lineInfoChapter5.length ${_lineInfoChapter5.length} _chapter5PageCounter $_chapter5PageCounter');

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
        _strongDicPageCounter;

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
          _strongDicPageCounter
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
      _lineInfoStrongDic,
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

    print('_onPageChange() _firstParagraph $_firstParagraph');
    print('_onPageChange() _lastParagraph $_lastParagraph');

    int storeParagraph = isChapterTitlePage(pageNo);
    if (storeParagraph >= 0) {
      storeParagraph = _firstParagraph;
    }

    if (_currentPageNo < _totalHeaderCounter) {
      storeParagraph = (_currentPageNo * -1) - 100;
    }

    Hive.box('matthew').put("currentParagraph", storeParagraph);
    // print(getPageNoByParagraph(storeParagraph));

    // if (_currentPageNo > 2 + _headerPageCounter && _currentPageNo < _totalHeaderCounter) {
    if (mounted) {
      setState(() {});
    }
    // }
  }

  void _onClickMenuSearch() {
    print('onClickMenuSearch()');
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
            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
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
      result.add(
        BookMark(
          paragraph: bookmarks[i],
          pageNo: getPageNoByParagraph(bookmarks[i]),
          paragraphStr: getParagraphStrByNumber(bookmarks[i]),
        ),
      );
    }

    return result;
  }

  String getParagraphStrByNumber(int paragraph) {
    String result = "";
    int chapterNo = getChapterNoByParagraph(paragraph);
    int chapterIndex = kStartParagraph[chapterNo - 1];
    print('chapterNo : $chapterNo, chapterIndex $chapterIndex');
    List<LineInfo> lineInfo = _lineInfoList[chapterNo];

    for (int i = 0; i < lineInfo.length; i++) {
      if (lineInfo[i].paragraph + chapterIndex < paragraph) {
        continue;
      } else if (lineInfo[i].paragraph + chapterIndex > paragraph) {
        break;
      }

      result = result + lineInfo[i].lineText;
    }

    print(result);
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
            buildControlPanel(),
            if (_showFontSetPanel) buildSetFontPanel(),
            if (_showScrollSetPanel) buildSetScrollPanel(),
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
                          if (resultStr != null) {
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

                      int currentParagraph = Hive.box("matthew").get("currentParagraph");
                      jumpToPage(currentParagraph);

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
                    },
                  ),
                ),
        ),
        Container(
          width: 55,
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/icon_search.png",
            height: 24,
            fit: BoxFit.fitHeight,
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

  void jumpToPage(int paragraph) {
    print('jumpToPage paragraph $paragraph');

    int pageNo;

    if (paragraph <= -100) {
      pageNo = (paragraph + 100) * -1;
    } else {
      pageNo = getPageNoByParagraph(paragraph);
      print('jumpToPage pageNo $pageNo');
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
    // print(
    //     'chapterNo $chapterNo, startPageIndex, $startPageIndex, maxLines $maxLines, offset $offset');

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
                  Container(
                    width: LABEL_WIDTH - 10,
                    height: cellHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
              'assets/images/chapter_sub_title_bg.png',
              height: 157.3,
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 122,
                ),
                Image.asset(
                  'assets/images/chapter_sub_title_text.png',
                  height: 25,
                  fit: BoxFit.fitHeight,
                ),
              ],
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

    return _lineInfoStrongDic;
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
    return tmpIndex;
  }

// Widget getText(String text) {
  //   int _maxLines = 10;
  //
  //   return LayoutBuilder(
  //     builder: (context, size) {
  //       // print('size $size');
  //
  //       String text1 = text.substring(0, text.indexOf("<r>"));
  //       String text2 =
  //           text.substring(text.indexOf("<r>") + 3, text.indexOf("</r>"));
  //       String text3 = text.substring(text.lastIndexOf("</r>") + 4);
  //       String pureText = text.replaceAll("<r>", "").replaceAll("</r>", "");
  //
  //       // print(text1);
  //       // print(text2);
  //       // print(text3);
  //
  //       List<TextSpan> texts = [
  //         TextSpan(
  //           text: text1,
  //           style: TextStyle(
  //             fontSize: 30,
  //             color: Colors.black,
  //           ),
  //         ),
  //         TextSpan(
  //           text: text2,
  //           style: TextStyle(
  //             fontSize: 30,
  //             color: Colors.red,
  //           ),
  //         ),
  //         TextSpan(
  //           text: text3,
  //           style: TextStyle(
  //             fontSize: 30,
  //             color: Colors.black,
  //           ),
  //         ),
  //       ];
  //
  //       final span = TextSpan(
  //         text: pureText,
  //         style: TextStyle(
  //           fontSize: 30,
  //           color: Colors.black,
  //         ),
  //       );
  //
  //       final tp = TextPainter(
  //         text: span,
  //         maxLines: _maxLines,
  //         textDirection: TextDirection.ltr,
  //         textAlign: TextAlign.justify,
  //       );
  //       tp.layout(maxWidth: size.maxWidth);
  //
  //       // print(tp.height);
  //       // print(tp.width);
  //       // print(tp.inlinePlaceholderBoxes);
  //       // print(tp.inlinePlaceholderScales);
  //       //print(tp.computeLineMetrics());
  //       // print(tp.maxIntrinsicWidth);
  //       // print(tp.minIntrinsicWidth);
  //       // print(tp.preferredLineHeight);
  //       // print(tp.size);
  //
  //       for (int i = 0; i <= pureText.length;) {
  //         TextRange tr = tp.getLineBoundary(TextPosition(offset: i));
  //         // print(pureText.substring(tr.start, tr.end));
  //         i = tr.end + 1;
  //       }
  //
  //       if (tp.didExceedMaxLines) {
  //         // The text has more than three lines.
  //         // TODO: display the prompt message
  //         //return Container(color: Colors.red);
  //         return RichText(
  //           textAlign: TextAlign.justify,
  //           maxLines: _maxLines,
  //           text: TextSpan(
  //             text: text1,
  //             style: TextStyle(
  //               fontSize: 30,
  //               color: Colors.black,
  //             ),
  //             children: <TextSpan>[
  //               texts[1],
  //               texts[2],
  //             ],
  //           ),
  //         );
  //
  //         return Text(
  //           text,
  //           textAlign: TextAlign.justify,
  //           maxLines: _maxLines,
  //           style: TextStyle(
  //             fontSize: 30,
  //             color: Colors.black,
  //           ),
  //         );
  //       } else {
  //         return RichText(
  //           textAlign: TextAlign.justify,
  //           maxLines: _maxLines,
  //           text: TextSpan(
  //             text: text1,
  //             style: TextStyle(
  //               fontSize: 30,
  //               color: Colors.black,
  //             ),
  //             children: <TextSpan>[
  //               texts[1],
  //               texts[2],
  //             ],
  //           ),
  //         );
  //
  //         return Text(
  //           text,
  //           textAlign: TextAlign.justify,
  //           style: TextStyle(
  //             fontSize: 30,
  //             color: Colors.black,
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
}
