import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:matthew/constants/constants.dart';
import 'package:matthew/models/matthew_data.dart';
import 'package:matthew/models/search_result.dart';
import 'package:matthew/models/strong_dic_data.dart';
import 'package:matthew/utils/settings.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.onClickParagraph, required this.onClickStrongCode}) : super(key: key);

  final Function onClickParagraph;
  final Function onClickStrongCode;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Settings _settings = Settings();
  List<SearchResult> _searchResult = [];

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
                          "검색",
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
              Container(
                height: 64,
                color: Color(0xFFD0D0D0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xFF167EC7),
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          Center(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.search_outlined,
                                  size: 23,
                                  color: Color(0xFF167EC7),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      autocorrect: false,
                                      controller: _searchController,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: "검색어를 입력하세요",
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 11),
                    GestureDetector(
                      onTap: () {
                        onSearch();
                      },
                      child: Container(
                        width: 75,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Color(0xFF142A4D),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "검색",
                          style: TextStyle(
                            fontFamily: _settings.getFontName(),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: (_searchResult.length == 0)
                    ? Container()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        itemCount: _searchResult.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildSearchResult(_searchResult[index], index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchResult(SearchResult sResult, int index) {
    if (sResult.paragraph != -1) {
      String resultStr = sResult.paragraphStr;
      int indexOf = resultStr.indexOf(_searchController.text);
      int charsOfLine = 18;

      if (resultStr.length > charsOfLine * 3) {
        while (indexOf > charsOfLine * 3) {
          resultStr = resultStr.substring(9, resultStr.length);
          indexOf = resultStr.indexOf(_searchController.text);
        }
        resultStr = "…" + resultStr;
      }

      indexOf = resultStr.indexOf(_searchController.text);

      Widget textWidget = RichText(
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        text: TextSpan(
          text: resultStr.substring(0, indexOf),
          style: TextStyle(
            fontFamily: _settings.getFontName(),
            fontSize: 16,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: _searchController.text,
              style: TextStyle(
                fontFamily: _settings.getFontName(),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            TextSpan(
              text: resultStr.substring(indexOf + _searchController.text.length, resultStr.length),
              style: TextStyle(
                fontFamily: _settings.getFontName(),
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );

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
                sResult.paragraph.toString() + "\n절",
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
                  widget.onClickParagraph(sResult.paragraph);
                },
                child: Container(
                  height: 86,
                  color: (index % 2 == 0) ? Color(0xFFEDEDED) : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 19),
                  alignment: Alignment.centerLeft,
                  child: textWidget,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // String codeStr = sResult.paragraphStr;
    // int codeIndexOf = codeStr.indexOf(_searchController.text);
    //
    // Widget codeWidget = RichText(
    //   textAlign: TextAlign.justify,
    //   overflow: TextOverflow.ellipsis,
    //   maxLines: 3,
    //   text: TextSpan(
    //     text: codeStr.substring(0, codeIndexOf),
    //     style: TextStyle(
    //       fontFamily: _settings.getFontName(),
    //       fontSize: 16,
    //       color: Colors.black,
    //     ),
    //     children: <TextSpan>[
    //       TextSpan(
    //         text: _searchController.text,
    //         style: TextStyle(
    //           fontFamily: _settings.getFontName(),
    //           fontSize: 16,
    //           fontWeight: FontWeight.bold,
    //           color: Colors.red,
    //         ),
    //       ),
    //       TextSpan(
    //         text: codeStr.substring(codeIndexOf + _searchController.text.length, codeStr.length),
    //         style: TextStyle(
    //           fontFamily: _settings.getFontName(),
    //           fontSize: 16,
    //           color: Colors.black,
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    String resultStr = sResult.paragraphStr;
    int indexOf = resultStr.indexOf(_searchController.text);

    Widget textWidget = RichText(
      textAlign: TextAlign.justify,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      text: TextSpan(
        text: resultStr.substring(0, indexOf),
        style: TextStyle(
          fontFamily: _settings.getFontName(),
          fontSize: 16,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: _searchController.text,
            style: TextStyle(
              fontFamily: _settings.getFontName(),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: resultStr.substring(indexOf + _searchController.text.length, resultStr.length),
            style: TextStyle(
              fontFamily: _settings.getFontName(),
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );

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
              sResult.strongCode,
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
                widget.onClickStrongCode(sResult.strongCode);
              },
              child: Container(
                height: 86,
                color: (index % 2 == 0) ? Color(0xFFEDEDED) : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 19),
                alignment: Alignment.centerLeft,
                child: textWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSearch() {
    if (_searchController.text.isEmpty) {
      return;
    }

    _searchResult.clear();

    for (int i = 0; i < kChapters.length; i++) {
      List<String> paras = kChapters[i].split("\n\n");

      for (int j = 0; j < paras.length; j++) {
        if (paras[j].isEmpty) {
          continue;
        }

        if (paras[j].contains(_searchController.text)) {
          _searchResult.add(
            SearchResult(paragraph: kStartParagraph[i] + j, paragraphStr: paras[j]),
          );
        }
      }
    }

    for (int i = 0; i < kStrongDic.length; i++) {
      if (kStrongDic[i].code.contains(_searchController.text) || kStrongDic[i].mean.contains(_searchController.text)) {
        _searchResult.add(
          SearchResult(paragraph: -1, paragraphStr: kStrongDic[i].mean, strongCode: kStrongDic[i].code),
        );
      }
    }

    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();

    if (mounted) {
      setState(() {});
    }
  }
}
