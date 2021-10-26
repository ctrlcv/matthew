import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:matthew/models/line_info.dart';
import 'package:matthew/models/strong_dic_data.dart';
import 'package:matthew/utils/settings.dart';

import '../constants/constants.dart';

class HeaderPage {
  Widget getHeaderPage(
      int index, int headerPageCounter, int contentPageCounter, List<int> pagesIndex, Function onClickPage, Function prevPage, Function nextPage) {
    Settings _settings = Settings();

    // 표지
    if (index == 0) {
      double topSpace = _settings.getScreenHeight() * 0.09;
      double bottomSpace = _settings.getScreenHeight() * 0.1149;

      return Container(
        color: Color(0xFF142A4D),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/book_cover_01.png',
              height: 223,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: topSpace,
            ),
            Image.asset(
              'assets/images/book_cover_02.png',
              height: 146,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: bottomSpace,
            ),
            Image.asset(
              'assets/images/book_cover_03.png',
              height: 86,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      );
    }

    // 속표지
    if (index == 1) {
      double topSpace = _settings.getScreenHeight() * 0.09;
      double bottomSpace = _settings.getScreenHeight() * 0.1149;

      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/inner_cover_01.png',
              height: 223,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: topSpace,
            ),
            Image.asset(
              'assets/images/inner_cover_02.png',
              height: 146,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: bottomSpace,
            ),
            Image.asset(
              'assets/images/inner_cover_03.png',
              height: 86,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      );
    }

    // 역자
    if (index == 2) {
      double topSpace = _settings.getSafeScreenHeight() * 0.190;
      double bottomSpace = _settings.getSafeScreenHeight() * 0.11;

      return Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: topSpace,
            ),
            Image.asset(
              'assets/images/trans_01.png',
              height: 392,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: bottomSpace,
            ),
            Image.asset(
              'assets/images/trans_02.png',
              height: 109,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      );
    }

    // 속표지 "마태복음"
    if (index == 3) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/matthew_inner_cover.png',
          height: 382,
          fit: BoxFit.fitHeight,
        ),
      );
    }

    if (index > 3 && index <= headerPageCounter + 3) {
      int indexOfChapter = index - 4;
      int maxLines = _settings.getHeaderMaxLines(_settings.getFontSize());
      List<LineInfo> lineInfoList = _settings.getLineInfo(0);

      int startIndex = indexOfChapter * maxLines;
      int endIndex = startIndex + maxLines;
      List<Widget> lines = [];
      double cellHeight = _settings.getHeaderScreenHeight() / maxLines;

      // print('index $index, headerPageCounter $headerPageCounter, indexOfChapter $indexOfChapter, maxLines $maxLines, startIndex $startIndex, $endIndex');

      for (int i = startIndex; i < endIndex; i++) {
        if (i >= lineInfoList.length) {
          lines.add(
            SizedBox(
              height: _settings.getHeaderScreenHeight() / maxLines,
            ),
          );
          continue;
        }

        if (lineInfoList[i].lineText.isEmpty) {
          if (i == startIndex || i == endIndex - 1) {
            continue;
          }
        }

        String lineStr = lineInfoList[i].lineText;
        if (lineStr.isNotEmpty) {
          lineStr = lineStr.replaceAll("\n", "");
        }

        // if (i == lineInfoList.length - 1) print(lineStr);

        lines.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: HEADER_HORIZONTAL_SPACE),
            height: cellHeight,
            child: getHeaderRichText(i, lineInfoList, lineStr, _settings),
          ),
        );
      }

      return Container(
        color: Color(0xFFF9F2E6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (indexOfChapter == 0)
                  Container(
                    height: 170,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/header_deco.png',
                          height: 32,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          height: 35,
                          alignment: Alignment.center,
                          child: Text(
                            "머리말",
                            style: _settings.getCustomFontStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF142A4D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 160,
                  ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: lines,
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
            if (indexOfChapter == headerPageCounter - 1)
              Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    height: 120,
                    child: Center(
                      child: Image.asset(
                        'assets/images/header_sign.png',
                        height: 115.1,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              ),
          ],
        ),
      );
    }

    // 목차 1
    if (index >= headerPageCounter + 4 && index < headerPageCounter + contentPageCounter + 4) {
      List<Widget> contents = [];
      contents.add(buildContent(_settings, 0, 4, onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 1, pagesIndex[1], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 2, pagesIndex[2], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 3, pagesIndex[3], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 4, pagesIndex[4], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 5, pagesIndex[5], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 6, pagesIndex[6], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 7, pagesIndex[7], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 8, pagesIndex[8], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 9, pagesIndex[9], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 10, pagesIndex[10], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 11, pagesIndex[11], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 12, pagesIndex[12], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 13, pagesIndex[13], onClickPage, prevPage, nextPage));
      contents.add(buildContent(_settings, 14, pagesIndex[14], onClickPage, prevPage, nextPage));

      int indexOfChapter = index - 4 - headerPageCounter;

      double screenHeight = _settings.getHeaderScreenHeight();
      int maxLines = (screenHeight / HEADER_CONTENT_HEIGHT).floor();

      int startIndex = indexOfChapter * maxLines;
      int endIndex = startIndex + maxLines;
      List<Widget> lines = [];

      print('_settings.getScreenWidth() ${_settings.getScreenWidth()}');
      double contentsWidth;

      if (_settings.getScreenWidth() > 420) {
        contentsWidth = 420;
      } else {
        contentsWidth = _settings.getScreenWidth();
      }

      for (int i = startIndex; i < endIndex; i++) {
        if (i >= contents.length) {
          lines.add(
            Container(
              height: HEADER_CONTENT_HEIGHT,
              child: Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: GestureDetector(
                      onTap: () {
                        prevPage();
                      },
                      child: Container(
                        height: HEADER_CONTENT_HEIGHT,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 12,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 10,
                    child: GestureDetector(
                      onTap: () {
                        nextPage();
                      },
                      child: Container(
                        height: HEADER_CONTENT_HEIGHT,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          continue;
        }

        lines.add(contents[i]);
      }

      return Container(
        color: Color(0xFFF6FAEE),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (indexOfChapter == 0)
                  Container(
                    height: 170,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () {
                              prevPage();
                            },
                            child: Container(
                              height: 170,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/header_deco.png',
                                height: 32,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                height: 35,
                                alignment: Alignment.center,
                                child: Text(
                                  "목  차",
                                  style: _settings.getCustomFontStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF142A4D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () {
                              nextPage();
                            },
                            child: Container(
                              height: 170,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 170,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () {
                              prevPage();
                            },
                            child: Container(
                              height: 170,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 12,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () {
                              nextPage();
                            },
                            child: Container(
                              height: 170,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              prevPage();
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Container(
                          width: contentsWidth,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: lines,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              nextPage();
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 10,
                        child: GestureDetector(
                          onTap: () {
                            prevPage();
                          },
                          child: Container(
                            height: 70,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 12,
                        child: Container(),
                      ),
                      Flexible(
                        flex: 10,
                        child: GestureDetector(
                          onTap: () {
                            nextPage();
                          },
                          child: Container(
                            height: 70,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 마지막 표지
    if (index == headerPageCounter + 7) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/chapter_title_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            Flexible(
              flex: 100,
              child: Container(),
            ),
            Image.asset(
              'assets/images/book_cover_last.png',
              height: 166,
              fit: BoxFit.fitHeight,
            ),
            Flexible(
              flex: 147,
              child: Container(),
            ),
          ],
        ),
      );
    }

    return SizedBox.expand(child: Container(color: Colors.red));
  }

  Widget getHeaderRichText(int i, List<LineInfo> lineInfoList, String lineStr, Settings _settings) {
    List<String> blueStrList = [
      "[수천 번의 노력]",
      "[ONE-STORY]",
      "[50년]",
      "[전무후무한 성경]",
    ];

    for (int j = 0; j < blueStrList.length; j++) {
      if (lineStr.contains(blueStrList[j])) {
        return Container(
          padding: EdgeInsets.only(top: 2),
          alignment: Alignment.bottomLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                blueStrList[j],
                style: TextStyle(
                  fontFamily: _settings.getFontName(),
                  fontSize: _settings.getFontSize() + 1,
                  color: Color(0xFF167EC7),
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                lineStr.substring(blueStrList[j].length, lineStr.length),
                style: TextStyle(
                  fontFamily: _settings.getFontName(),
                  fontSize: _settings.getFontSize(),
                  color: Colors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }
    }

    String blueStr = "KJV 및 개역개정의 수 만개의 오번역이 수정된 이 책은,";

    if (i > lineInfoList.length - 6) {
      if (blueStr.contains(lineStr)) {
        return RichText(
          textAlign: (i != lineInfoList.length - 1) ? TextAlign.justify : TextAlign.start,
          maxLines: 2,
          text: TextSpan(
            text: lineStr,
            style: TextStyle(
              fontFamily: _settings.getFontName(),
              fontSize: _settings.getFontSize() + 1,
              color: Color(0xFF167EC7),
              fontWeight: FontWeight.w600,
            ),
            children: <TextSpan>[
              if (i != lineInfoList.length - 1)
                TextSpan(
                  text: lineInfoList[i + 1].lineText,
                  style: _settings.getFontStyle(
                    color: Colors.transparent,
                  ),
                ),
            ],
          ),
        );
      }
    }

    if (lineStr.contains("예수님의 작품")) {
      return Container(
        padding: EdgeInsets.only(top: 2),
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              lineStr.substring(0, lineStr.indexOf("예수님의 작품")),
              style: TextStyle(
                fontFamily: _settings.getFontName(),
                fontSize: _settings.getFontSize(),
                color: Colors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              lineStr.substring(lineStr.indexOf("예수님의 작품"), lineStr.indexOf("예수님의 작품") + "예수님의 작품".length),
              style: TextStyle(
                fontFamily: _settings.getFontName(),
                fontSize: _settings.getFontSize() + 1,
                color: FONT_RED_COLOR,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              lineStr.substring(lineStr.indexOf("예수님의 작품") + "예수님의 작품".length, lineStr.length),
              style: TextStyle(
                fontFamily: _settings.getFontName(),
                fontSize: _settings.getFontSize(),
                color: Colors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return RichText(
      textAlign: (i != lineInfoList.length - 1) ? TextAlign.justify : TextAlign.start,
      maxLines: 2,
      text: TextSpan(
        text: lineStr,
        style: _settings.getFontStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          if (i != lineInfoList.length - 1)
            TextSpan(
              text: lineInfoList[i + 1].lineText,
              style: _settings.getFontStyle(
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildContent(Settings _settings, int chapter, int pageNo, Function onClickPage, Function prevPage, Function nextPage) {
    return Expanded(
      child: Container(
        height: 77,
        // padding: EdgeInsets.symmetric(horizontal: 52),
        alignment: Alignment.center,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                prevPage();
              },
              child: Container(
                width: 52,
                color: Colors.transparent,
              ),
            ),
            Container(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 34,
                    width: 50,
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      onTap: () {
                        onClickPage(pageNo);
                      },
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: pageNo.toString(),
                          style: _settings.getCustomFontStyle(
                            fontSize: 16,
                            color: Color(0xFF01AB4F),
                            fontWeight: FontWeight.w700,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "P",
                              style: _settings.getCustomFontStyle(
                                fontSize: 12,
                                color: Color(0xFF01AB4F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            SizedBox(width: 2),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 34,
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        onTap: () {
                          onClickPage(pageNo);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: (chapter == 0)
                                ? "머리말"
                                : (chapter == 13)
                                    ? "박경호헬라어스트롱사전"
                                    : (chapter == 14)
                                        ? "마침말"
                                        : "마태복음 ",
                            style: _settings.getCustomFontStyle(
                              fontSize: 16,
                              color: Color(0xFF142A4D),
                              fontWeight: FontWeight.w700,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: (chapter == 0 || chapter == 13 || chapter == 14) ? "" : chapter.toString(),
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFF142A4D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: (chapter == 0 || chapter == 13 || chapter == 14) ? "" : "장",
                                style: _settings.getCustomFontStyle(
                                  fontSize: 14,
                                  color: Color(0xFF142A4D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 26,
                      alignment: Alignment.centerLeft,
                      child: (chapter == 0 || chapter == 13 || chapter == 14)
                          ? Container()
                          : InkWell(
                              onTap: () {
                                onClickPage(pageNo);
                              },
                              child: Text(
                                "(${kChapterParagraphs[chapter - 1]})${kChapterSubPara[chapter - 1]}",
                                style: TextStyle(fontFamily: _settings.getFontName(), fontSize: 12, color: Colors.black),
                              ),
                            ),
                    ),
                    Container(
                      height: 20,
                      alignment: Alignment.centerLeft,
                      child: (chapter == 0 || chapter == 13 || chapter == 14)
                          ? Container()
                          : Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    onClickPage(pageNo);
                                  },
                                  child: Image.asset(
                                    'assets/images/content.png',
                                    height: 6,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    onClickPage(pageNo);
                                  },
                                  child: Text(
                                    kChapterTitle[chapter - 1],
                                    style: TextStyle(
                                      fontFamily: _settings.getFontName(),
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                nextPage();
              },
              child: Container(
                width: 52,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getStrongDicPage(int index, int strongDicStartPage, bool isCopyMode, Function onCopyToClipboard) {
    Settings _settings = Settings();

    int indexOfChapter = index - strongDicStartPage;

    //print('getStrongDicPage() indexOfChapter $indexOfChapter');

    if (indexOfChapter == 0) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/chapter_title_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/strong_title.png',
          height: 285,
          fit: BoxFit.fitHeight,
        ),
      );
    }

    List<Widget> items = [];

    int startIndex;
    int endIndex;
    int maxLines = (_settings.getStrongDicScreenHeight() / STRONG_DIC_ITEM_HEIGHT).floor();
    // print('getStrongDicPage() maxLines $maxLines, kStrongDic.length ${kStrongDic.length}');
    // print('getStrongDicPage() indexOfChapter $indexOfChapter');
    bool displayBookMark = false;

    if (indexOfChapter == 1) {
      startIndex = 0;
      endIndex = startIndex + maxLines - 1;

      items.add(
        Container(
          height: STRONG_DIC_ITEM_HEIGHT - 15,
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: STRONG_DIC_COLUMN_WIDTH,
                alignment: Alignment.center,
                color: Color(0xFF7E858B),
                child: Text(
                  "스트롱코드",
                  style: TextStyle(
                    fontFamily: _settings.getFontName(),
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: STRONG_DIC_ITEM_HEIGHT - 15,
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Color(0xFF7E858B),
                  child: Text(
                    "뜻",
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      items.add(
        Container(height: 1, color: Colors.black),
      );
      startIndex = (maxLines * (indexOfChapter - 1)) - 1;
      endIndex = startIndex + maxLines;
    }

    for (int i = startIndex; i < endIndex; i++) {
      if (i > kStrongDic.length - 1) {
        items.add(
          SizedBox(
            height: STRONG_DIC_ITEM_HEIGHT,
          ),
        );
        continue;
      }

      if (!displayBookMark) {
        if (_settings.isBookMarkPage(kStrongDic[i].code)) {
          displayBookMark = true;
        }
      }

      items.add(
        Container(
          height: STRONG_DIC_ITEM_HEIGHT,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  String copyText = kStrongDic[i].code + ":" + kStrongDic[i].mean;
                  onCopyToClipboard(copyText);
                },
                child: Container(
                  width: STRONG_DIC_COLUMN_WIDTH,
                  alignment: Alignment.center,
                  color: isCopyMode ? Color(0xFF167EC7) : Color(0xFFDFE4F2),
                  child: AutoSizeText(
                    kStrongDic[i].code,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: STRONG_DIC_ITEM_HEIGHT,
                color: Colors.black,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 8),
                  color: Color(0xFFFEF9E7),
                  child: AutoSizeText(
                    kStrongDic[i].mean,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: STRONG_DIC_VERTICAL_SPACE,
            horizontal: STRONG_DIC_HORIZONTAL_SPACE,
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: items,
            ),
          ),
        ),
        if (displayBookMark)
          Positioned(
            top: 8,
            right: STRONG_DIC_HORIZONTAL_SPACE,
            child: Image.asset(
              "assets/images/bookmark.png",
              height: 48,
              fit: BoxFit.fitHeight,
            ),
          ),
      ],
    );
  }

  Widget getEndedPage(int index, int endedStartPage, int totalPageCounter) {
    Settings _settings = Settings();

    int indexOfChapter = index - endedStartPage;
    int maxLines = _settings.getHeaderMaxLines(_settings.getFontSize());
    List<LineInfo> lineInfoList = _settings.getLineInfo(13);

    int startIndex = indexOfChapter * maxLines;
    int endIndex = startIndex + maxLines;
    List<Widget> lines = [];
    double cellHeight = _settings.getHeaderScreenHeight() / maxLines;

    for (int i = startIndex; i < endIndex; i++) {
      if (i >= lineInfoList.length) {
        lines.add(
          SizedBox(
            height: _settings.getHeaderScreenHeight() / maxLines,
          ),
        );
        continue;
      }

      if (lineInfoList[i].lineText.isEmpty) {
        if (i == startIndex || i == endIndex - 1) {
          continue;
        }
      }

      String lineStr = lineInfoList[i].lineText;
      if (lineStr.isNotEmpty) {
        lineStr = lineStr.replaceAll("\n", "");
      }

      // if (i == lineInfoList.length - 1) print(lineStr);

      lines.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: HEADER_HORIZONTAL_SPACE),
          height: cellHeight,
          alignment: Alignment.bottomLeft,
          child: getEndedRichText(i, lineInfoList, lineStr, _settings),
        ),
      );
    }

    return Container(
      color: Color(0xFFF9F2E6),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (indexOfChapter == 0)
                Container(
                  height: 170,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/header_deco.png',
                        height: 32,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 35,
                        alignment: Alignment.center,
                        child: Text(
                          "마침말",
                          style: _settings.getCustomFontStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF142A4D),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 160,
                ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: lines,
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
          if (index == totalPageCounter - 1)
            Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Container(
                  height: 120,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 36),
                  child: Image.asset(
                    'assets/images/ended_sign.png',
                    height: 91,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                SizedBox(
                  height: 53,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget getEndedRichText(int i, List<LineInfo> lineInfoList, String lineStr, Settings _settings) {
    List<String> redStrList = [
      "“아브라함의 아들이며, 다윗의 아들이신,",
      "예수 그리스도의 낳으심의 성경책입니다.”가",
      "새롭게 번역된 내용입니다.",
      "결국,",
      "완전한 1:1대응은,",
      "완전한 번역으로의 완전성의 열매를 맺게 된 것입니다.",
    ];

    for (int j = 0; j < redStrList.length; j++) {
      if (lineStr.isNotEmpty && redStrList[j].contains(lineStr)) {
        if (lineStr.length < 10) {
          String beforeLineStr = lineInfoList[i - 1].lineText;
          // print(beforeLineStr);
          if (beforeLineStr.isNotEmpty && !redStrList[j].contains(beforeLineStr)) {
            break;
          }
        }

        return RichText(
          textAlign: (i != lineInfoList.length - 1) ? TextAlign.justify : TextAlign.start,
          maxLines: 2,
          text: TextSpan(
            text: lineStr,
            style: TextStyle(
              fontFamily: _settings.getFontName(),
              fontSize: _settings.getFontSize() + 1,
              color: FONT_RED_COLOR,
              fontWeight: FontWeight.w600,
              height: 1.7,
            ),
            children: <TextSpan>[
              if (i != lineInfoList.length - 1)
                TextSpan(
                  text: lineInfoList[i + 1].lineText,
                  style: TextStyle(
                    fontFamily: _settings.getFontName(),
                    fontSize: _settings.getFontSize() + 1,
                    color: Colors.transparent,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
            ],
          ),
        );
      }
    }

    return RichText(
      textAlign: (i != lineInfoList.length - 1) ? TextAlign.justify : TextAlign.start,
      maxLines: 2,
      text: TextSpan(
        text: lineStr,
        style: _settings.getFontStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          if (i != lineInfoList.length - 1)
            TextSpan(
              text: lineInfoList[i + 1].lineText,
              style: _settings.getFontStyle(
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
