import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:matthew/models/bookmark_model.dart';
import 'package:matthew/utils/settings.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key, required this.onClickPage, required this.bookMarks}) : super(key: key);
  final Function onClickPage;
  final List<BookMark> bookMarks;

  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  Settings _settings = Settings();
  List<Widget> _contents = [];

  @override
  void initState() {
    super.initState();

    _contents.clear();
    _contents.add(SizedBox(
      height: 30,
    ));

    for (int i = 0; i < widget.bookMarks.length; i++) {
      _contents.add(buildBookMark(widget.bookMarks[i], i));
    }

    _contents.add(SizedBox(
      height: 30,
    ));
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
                          "북마크",
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
                  child: (widget.bookMarks.length == 0)
                      ? Container(
                          height: _settings.getSafeScreenHeight(),
                          alignment: Alignment.center,
                          child: Text(
                            "북마크된 항목이 없습니다",
                            style: TextStyle(
                              fontFamily: _settings.getFontName(),
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          height: (86 * (_contents.length - 2)).toDouble() + 60.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _contents,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookMark(BookMark bookmark, int index) {
    if (bookmark.paragraph != -1) {
      return Container(
        height: 86,
        padding: EdgeInsets.symmetric(horizontal: 36),
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              width: 67,
              height: 86,
              color: (index % 2 == 0) ? Color(0xFF142A4D) : Color(0xFF167EC7),
              alignment: Alignment.center,
              child: Text(
                bookmark.paragraph.toString() + "\n절",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: _settings.getFontName(),
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.onClickPage(bookmark.pageNo);
                },
                child: Container(
                  height: 86,
                  color: (index % 2 == 0) ? Color(0xFFEDEDED) : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 19),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    bookmark.paragraphStr,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 86,
      padding: EdgeInsets.symmetric(horizontal: 36),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 67,
            height: 86,
            color: (index % 2 == 0) ? Color(0xFF142A4D) : Color(0xFF167EC7),
            alignment: Alignment.center,
            child: AutoSizeText(
              bookmark.strongCode,
              textAlign: TextAlign.center,
              maxLines: 5,
              style: TextStyle(
                fontFamily: _settings.getFontName(),
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                widget.onClickPage(bookmark.pageNo);
              },
              child: Container(
                height: 86,
                color: (index % 2 == 0) ? Color(0xFFEDEDED) : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 19),
                alignment: Alignment.centerLeft,
                child: Text(
                  bookmark.paragraphStr,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: _settings.getFontName(),
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
