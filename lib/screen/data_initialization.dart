import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matthew/screen/main_screen.dart';
import 'package:matthew/utils/settings.dart';

import '../constants/constants.dart';
import '../models/line_info.dart';
import '../models/matthew_data.dart';

class DataInit extends StatefulWidget {
  const DataInit({Key? key, this.removeThisWidget = false}) : super(key: key);

  final bool removeThisWidget;

  @override
  _DataInitState createState() => _DataInitState();
}

class _DataInitState extends State<DataInit> {
  Settings _settings = Settings();
  Timer _initialTimer = new Timer(Duration(milliseconds: 1000), () {});

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      checkLoaded(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkLoaded(BuildContext context) {
    if (_initialTimer.isActive) {
      _initialTimer.cancel();
    }

    if (_settings.getLineInfo(1).length > 0 &&
        _settings.getLineInfo(2).length > 0 &&
        _settings.getLineInfo(3).length > 0 &&
        _settings.getLineInfo(4).length > 0 &&
        _settings.getLineInfo(5).length > 0 &&
        _settings.getLineInfo(6).length > 0 &&
        _settings.getLineInfo(7).length > 0 &&
        _settings.getLineInfo(8).length > 0 &&
        _settings.getLineInfo(9).length > 0 &&
        _settings.getLineInfo(10).length > 0 &&
        _settings.getLineInfo(11).length > 0 &&
        _settings.getLineInfo(12).length > 0) {
      print('checkLoaded');

      if (widget.removeThisWidget) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
      return;
    }

    _initialTimer = new Timer(Duration(milliseconds: 1000), () {
      checkLoaded(context);

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (_settings.getScreenWidth() == 0 ||
        size.width != _settings.getScreenWidth()) {
      _settings.setScreenWidth(size.width);
      _settings.setScreenHeight(size.height);

      double verticalSpace = (size.height / 13);
      double horizontalSpace = (size.width / 11);

      if (verticalSpace > 64) {
        verticalSpace = 64;
      }

      if (horizontalSpace > 36) {
        horizontalSpace = 36;
      }

      print('horizontalSpace $horizontalSpace');
      print('verticalSpace $verticalSpace');

      _settings.setHorizontalSpace(horizontalSpace);
      _settings.setVerticalSpace(verticalSpace);
    }

    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _settings.getHorizontalSpace(),
                  vertical: _settings.getVerticalSpace(),
                ),
                color: Colors.white,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        width: LABEL_WIDTH,
                      ),
                      Expanded(
                        child: Container(
                          child: Stack(
                            children: [
                              if (_settings.getMaxLines(FONT_SIZE_1) == 0)
                                setMaxLines(FONT_SIZE_1),
                              if (_settings.getMaxLines(FONT_SIZE_2) == 0)
                                setMaxLines(FONT_SIZE_2),
                              if (_settings.getMaxLines(FONT_SIZE_3) == 0)
                                setMaxLines(FONT_SIZE_3),
                              if (_settings.getMaxLines(FONT_SIZE_4) == 0)
                                setMaxLines(FONT_SIZE_4),
                              if (_settings.getMaxLines(FONT_SIZE_5) == 0)
                                setMaxLines(FONT_SIZE_5),
                              if (_settings.getMaxLines(FONT_SIZE_6) == 0)
                                setMaxLines(FONT_SIZE_6),
                              if (_settings.getLineInfo(1).length == 0)
                                getPageLines(1, kChapter1All),
                              if (_settings.getLineInfo(2).length == 0)
                                getPageLines(2, kChapter2All),
                              if (_settings.getLineInfo(3).length == 0)
                                getPageLines(3, kChapter3All),
                              if (_settings.getLineInfo(4).length == 0)
                                getPageLines(4, kChapter4All),
                              if (_settings.getLineInfo(5).length == 0)
                                getPageLines(5, kChapter5All),
                              if (_settings.getLineInfo(6).length == 0)
                                getPageLines(6, kChapter6All),
                              if (_settings.getLineInfo(7).length == 0)
                                getPageLines(7, kChapter7All),
                              if (_settings.getLineInfo(8).length == 0)
                                getPageLines(8, kChapter8All),
                              if (_settings.getLineInfo(9).length == 0)
                                getPageLines(9, kChapter9All),
                              if (_settings.getLineInfo(10).length == 0)
                                getPageLines(10, kChapter10All),
                              if (_settings.getLineInfo(11).length == 0)
                                getPageLines(11, kChapter11All),
                              if (_settings.getLineInfo(12).length == 0)
                                getPageLines(12, kChapter12All),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: HEADER_HORIZONTAL_SPACE),
                child: Column(
                  children: [
                    SizedBox(
                      height: 170,
                    ),
                    Expanded(
                      child: Container(
                        child: Stack(
                          children: [
                            if (_settings.getHeaderMaxLines(FONT_SIZE_1) == 0)
                              setHeaderMaxLines(FONT_SIZE_1),
                            if (_settings.getHeaderMaxLines(FONT_SIZE_2) == 0)
                              setHeaderMaxLines(FONT_SIZE_2),
                            if (_settings.getHeaderMaxLines(FONT_SIZE_3) == 0)
                              setHeaderMaxLines(FONT_SIZE_3),
                            if (_settings.getHeaderMaxLines(FONT_SIZE_4) == 0)
                              setHeaderMaxLines(FONT_SIZE_4),
                            if (_settings.getHeaderMaxLines(FONT_SIZE_5) == 0)
                              setHeaderMaxLines(FONT_SIZE_5),
                            if (_settings.getHeaderMaxLines(FONT_SIZE_6) == 0)
                              setHeaderMaxLines(FONT_SIZE_6),
                            if (_settings.getLineInfo(0).length == 0)
                              getHeaderPageLines(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeaderPageLines() {
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(
          text: kHeaderChapter,
          style: _settings.getFontStyle(
            color: Colors.transparent,
          ),
        );

        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.justify,
        );
        tp.layout(maxWidth: size.maxWidth);

        if (_settings.getHeaderScreenWidth() == 0) {
          _settings.setHeaderScreenWidth(size.maxWidth);
        }

        if (_settings.getHeaderScreenHeight() == 0) {
          _settings.setHeaderScreenHeight(size.maxHeight);
        }

        int index = 0;
        int paraIndex = 1;
        List<LineInfo> lineInfoList = [];

        for (int i = 0; i <= kHeaderChapter.length;) {
          TextRange tr = tp.getLineBoundary(TextPosition(offset: i));
          String subStr = kHeaderChapter.substring(tr.start, tr.end);

          // print(subStr);
          lineInfoList.add(LineInfo(
              chapter: 0,
              index: index,
              paragraph: paraIndex,
              lineText: subStr));

          if (subStr.isEmpty) {
            paraIndex++;
          }

          i = tr.end + 1;
          index++;
        }
        _settings.setLineInfo(0, lineInfoList);

        return Container();
      },
    );
  }

  Widget getPageLines(int chapter, String chapterBody) {
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(
          text: chapterBody,
          style: _settings.getFontStyle(
            color: Colors.transparent,
          ),
        );

        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.justify,
        );
        tp.layout(maxWidth: size.maxWidth);

        if (_settings.getSafeScreenWidth() == 0) {
          _settings.setSafeScreenWidth(size.maxWidth);
        }

        if (_settings.getSafeScreenHeight() == 0) {
          _settings.setSafeScreenHeight(size.maxHeight);
        }

        int index = 0;
        int paraIndex = 1;
        List<LineInfo> lineInfoList = [];

        for (int i = 0; i <= chapterBody.length;) {
          TextRange tr = tp.getLineBoundary(TextPosition(offset: i));
          String subStr = chapterBody.substring(tr.start, tr.end);

          // print(subStr);
          lineInfoList.add(LineInfo(
              chapter: chapter,
              index: index,
              paragraph: paraIndex,
              lineText: subStr));

          if (subStr.isEmpty) {
            paraIndex++;
          }

          i = tr.end + 1;
          index++;
        }

        _settings.setLineInfo(chapter, lineInfoList);
        return Container();
      },
    );
  }

  Widget setMaxLines(double fontSize) {
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(
          text: "아멘",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.transparent,
            height: LINE_HEIGHT,
          ),
        );

        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.justify,
        );
        tp.layout(maxWidth: size.maxWidth);

        // print('setMaxLines(fontName ${_settings.getFontName()} fontSize $fontSize, tp.height ${tp.height})');

        int maxLines = (size.maxHeight / tp.height).floor();

        _settings.setMaxLines(fontSize, maxLines);
        print('setMaxLines($fontSize, $maxLines)');

        return Container();
      },
    );
  }

  Widget setHeaderMaxLines(double fontSize) {
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(
          text: "아멘",
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.transparent,
            height: LINE_HEIGHT,
          ),
        );

        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.justify,
        );
        tp.layout(maxWidth: size.maxWidth);

        // print('setMaxLines(fontName ${_settings.getFontName()} fontSize $fontSize, tp.height ${tp.height})');

        int maxLines = (size.maxHeight / tp.height).floor();

        _settings.setHeaderMaxLines(fontSize, maxLines);
        print('setHeaderMaxLines($fontSize, $maxLines)');

        return Container();
      },
    );
  }
}
