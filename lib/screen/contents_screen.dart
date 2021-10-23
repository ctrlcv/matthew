import 'package:auto_size_text/auto_size_text.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF6FAEE),
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
                child: Container(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return buildContent(context, index, (index == 0) ? 4 : widget.pagesIndex[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context, int chapter, int pageNo) {
    double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = 280;
    double horizontalSpace = (screenWidth - contentWidth) / 2;

    print('screenWidth $screenWidth, horizontalSpace $horizontalSpace');

    return Container(
      height: 100,
      width: contentWidth,
      padding: EdgeInsets.symmetric(horizontal: horizontalSpace),
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 84,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 38,
                  width: 50,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(bottom: (chapter == 0 || chapter == 13 || chapter == 14) ? 0 : 3),
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
                Expanded(child: Container()),
              ],
            ),
          ),
          SizedBox(width: 2),
          Expanded(
            child: Container(
              height: 84,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 38,
                    alignment: Alignment.bottomLeft,
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
                            child: AutoSizeText(
                              "(${kChapterParagraphs[chapter - 1]})${kChapterSubPara[chapter - 1]}",
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: _settings.getFontName(),
                                fontSize: 12,
                                color: Colors.black,
                              ),
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
