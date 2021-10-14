import 'package:flutter/material.dart';
import 'package:matthew/constants/constants.dart';
import 'package:matthew/utils/settings.dart';

class ContentsScreen extends StatefulWidget {
  const ContentsScreen({Key? key, required this.onClickPage, required this.pagesIndex}) : super(key: key);

  final Function onClickPage;
  final List<int> pagesIndex;

  @override
  _ContentsScreenState createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  Settings _settings = Settings();
  List<Widget> _contents = [];
  double _contentsWidth = 410;

  @override
  void initState() {
    super.initState();

    _contents.clear();
    _contents.add(SizedBox(
      height: 30,
    ));
    _contents.add(buildContent(0, 4));
    _contents.add(buildContent(1, widget.pagesIndex[1]));
    _contents.add(buildContent(2, widget.pagesIndex[2]));
    _contents.add(buildContent(3, widget.pagesIndex[3]));
    _contents.add(buildContent(4, widget.pagesIndex[4]));
    _contents.add(buildContent(5, widget.pagesIndex[5]));
    _contents.add(buildContent(6, widget.pagesIndex[6]));
    _contents.add(buildContent(7, widget.pagesIndex[7]));
    _contents.add(buildContent(8, widget.pagesIndex[8]));
    _contents.add(buildContent(9, widget.pagesIndex[9]));
    _contents.add(buildContent(10, widget.pagesIndex[10]));
    _contents.add(buildContent(11, widget.pagesIndex[11]));
    _contents.add(buildContent(12, widget.pagesIndex[12]));
    _contents.add(buildContent(13, widget.pagesIndex[12]));
    _contents.add(buildContent(14, widget.pagesIndex[12]));
    _contents.add(SizedBox(
      height: 30,
    ));

    if (_settings.getScreenWidth() > 420) {
      _contentsWidth = 420;
    } else {
      _contentsWidth = _settings.getScreenWidth();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                height: 70,
                color: Color(0xFF167EC7),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "목차",
                          style: TextStyle(
                            fontFamily: _settings.getFontName(),
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        height: (100 * _contents.length).toDouble(),
                        width: _contentsWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _contents,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(int chapter, int pageNo) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 52),
      alignment: Alignment.topCenter,
      child: Row(
        children: [
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
                      Navigator.pop(context);
                      widget.onClickPage(pageNo);
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
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onClickPage(pageNo);
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
                              Navigator.pop(context);
                              widget.onClickPage(pageNo);
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
                                  Navigator.pop(context);
                                  widget.onClickPage(pageNo);
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
                                  Navigator.pop(context);
                                  widget.onClickPage(pageNo);
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
        ],
      ),
    );
  }
}
