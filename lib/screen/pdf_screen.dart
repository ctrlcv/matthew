import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matthew/constants/constants.dart';
import 'package:matthew/models/matthew_data.dart';
import 'package:matthew/utils/settings.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  Settings _settings = Settings();
  List<bool> _selected = [true, true, true, true, true, true, true, true, true, true, true, true];

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
                          "PDF 변환",
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
                  padding: EdgeInsets.symmetric(vertical: 31, horizontal: 36),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isAllSelected()) {
                            for (int i = 0; i < _selected.length; i++) {
                              _selected[i] = false;
                            }

                            if (mounted) {
                              setState(() {});
                            }
                            return;
                          }

                          for (int i = 0; i < _selected.length; i++) {
                            _selected[i] = true;
                          }

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: 75,
                          color: Color(0xFF142A4D),
                          child: Row(
                            children: [
                              Container(
                                height: 75,
                                width: 60,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  isAllSelected() ? 'assets/images/checkbox_white_selected.png' : 'assets/images/checkbox_white_unselected.png',
                                  height: 24,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Container(
                                height: 75,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "전체선택",
                                  style: TextStyle(
                                    fontFamily: _settings.getFontName(),
                                    fontSize: 20,
                                    color: isAllSelected() ? Color(0xFF65CCFF) : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: 12,
                            itemBuilder: (BuildContext context, int index) {
                              return buildContent(index + 1);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Color(0xFF65CCFF),
                height: 6,
              ),
              GestureDetector(
                onTap: _makePDFDocument,
                child: Container(
                  color: Color(0xFF167EC7),
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    "PDF 변환하기",
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  bool isAllSelected() {
    for (int i = 0; i < _selected.length; i++) {
      if (_selected[i] == false) {
        return false;
      }
    }
    return true;
  }

  bool isAllUnSelected() {
    for (int i = 0; i < _selected.length; i++) {
      if (_selected[i]) {
        return false;
      }
    }
    return true;
  }

  Widget buildContent(int chapter) {
    return GestureDetector(
      onTap: () {
        print('onTap() ${_selected[chapter - 1]}');
        _selected[chapter - 1] = !_selected[chapter - 1];
        if (mounted) {
          setState(() {});
        }
      },
      child: Container(
        height: 75,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: (chapter % 2 == 1) ? Color(0xFFEDEDED) : Colors.white,
          border: Border(
            left: BorderSide(
              color: Color(0xFFEDEDED),
              width: 1.0,
            ),
            right: BorderSide(
              color: Color(0xFFEDEDED),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: (chapter == 12) ? Color(0xFFEDEDED) : Colors.transparent,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 75,
              width: 60,
              alignment: Alignment.center,
              child: Image.asset(
                _selected[chapter - 1] ? 'assets/images/checkbox_selected.png' : 'assets/images/checkbox_unselected.png',
                height: 24,
                fit: BoxFit.fitHeight,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    chapter.toString() + "장 (${kChapterParagraphs[chapter - 1]})",
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 16,
                      color: _selected[chapter - 1] ? Color(0xFF142A4D) : Color(0xFF7B7979),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${kChapterSubPara[chapter - 1]}",
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 12,
                      color: _selected[chapter - 1] ? Color(0xFF142A4D) : Color(0xFF7B7979),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    kChapterTitle[chapter - 1],
                    style: TextStyle(
                      fontFamily: _settings.getFontName(),
                      fontSize: 12,
                      color: Color(0xFF7B7979),
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

  void _makePDFDocument() async {
    print('start _makePDFDocument()');
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    String fontName = "";
    double fontSize = 13;

    switch (_settings.getFontName()) {
      case FONT_GODIC:
        fontName = "assets/fonts/NanumGothic.ttf";
        break;

      case FONT_MYOUNGJO:
        fontName = "assets/fonts/NanumMyeongjo.ttf";
        break;

      case FONT_NSQUARE:
        fontName = "assets/fonts/NanumSquareR.ttf";
        break;

      case FONT_GMARKET:
        fontName = "assets/fonts/GmarketSansTTFMedium.ttf";
        break;

      case FONT_NEXON:
        fontName = "assets/fonts/nexon_regular.ttf";
        break;

      case FONT_TWAY:
        fontName = "assets/fonts/tway_air.ttf";
        break;

      case FONT_GOWUND:
        fontName = "assets/fonts/GowunDodum-Regular.ttf";
        break;

      case FONT_GOWUNB:
        fontName = "assets/fonts/GowunBatang-Regular.ttf";
        break;

      case FONT_KYOBO:
        fontName = "assets/fonts/Kyobo-Handwriting.ttf";
        break;

      case FONT_COOKIE:
        fontName = "assets/fonts/CookieRun-Regular.ttf";
        break;
    }

    if (_settings.getFontSize() == FONT_SIZE_1) {
      fontSize = 10;
    } else if (_settings.getFontSize() == FONT_SIZE_2) {
      fontSize = 12;
    } else if (_settings.getFontSize() == FONT_SIZE_3) {
      fontSize = 14;
    } else if (_settings.getFontSize() == FONT_SIZE_4) {
      fontSize = 16;
    } else if (_settings.getFontSize() == FONT_SIZE_5) {
      fontSize = 18;
    } else if (_settings.getFontSize() == FONT_SIZE_6) {
      fontSize = 20;
    }

    final font1 = pw.Font.ttf(await rootBundle.load("assets/fonts/nexon_regular.ttf"));
    final font2 = pw.Font.ttf(await rootBundle.load(fontName));

    final titleImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/chapter_sub_title.png')).buffer.asUint8List(),
    );

    for (int i = 0; i < _selected.length; i++) {
      if (_selected[i]) {
        doc.addPage(getMultiPages(i + 1, font1, font2, titleImage, fontSize));
      }
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;

    final file = File(appDocPath + '/' + 'new_matthew.pdf');
    await file.writeAsBytes(await doc.save());
    await OpenFile.open(file.path);

    print('End _makePDFDocument()');
  }

  pw.MultiPage getMultiPages(int chapter, pw.Font font1, pw.Font font2, pw.MemoryImage titleImage, double fontSize) {
    List<String> chapters = kChapters[chapter - 1].split("\n\n");
    List<pw.Widget> chapterWidgets = [];

    chapterWidgets.add(
      pw.Stack(
        children: [
          pw.Container(
            height: 400,
            alignment: pw.Alignment.center,
            child: pw.Image(
              titleImage,
              height: 170,
              fit: pw.BoxFit.fitHeight,
            ),
          ),
          pw.Container(
            height: 368,
            alignment: pw.Alignment.center,
            child: pw.Center(
              child: pw.RichText(
                text: pw.TextSpan(
                  style: pw.TextStyle(
                    font: font1,
                    fontSize: 36,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  children: [
                    pw.TextSpan(
                      text: chapter.toString(),
                    ),
                    pw.TextSpan(
                      text: '장',
                      style: pw.TextStyle(
                        font: font1,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    for (int i = 0; i < chapters.length; i++) {
      if (chapters[i].isEmpty) {
        continue;
      }

      List<String> redTexts = getRedTexts(i + kStartParagraph[chapter - 1], chapter);

      chapterWidgets.add(
        MatthewParagraph(
          text: chapters[i],
          hasRed: (redTexts.length == 0) ? false : true,
          paragraphNo: i + kStartParagraph[chapter - 1],
          redTexts: redTexts,
          fontSize: fontSize,
        ),
      );
    }

    return pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: font2,
        bold: font1,
      ),
      pageFormat: PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          child: pw.Text(
            "New 마태복음",
            style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey),
          ),
        );
      },
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.Theme.of(context).defaultTextStyle.copyWith(
                  color: PdfColors.grey,
                ),
          ),
        );
      },
      build: (pw.Context context) {
        return chapterWidgets;
      },
    );
  }

  List<String> getRedTexts(int paragraphNo, int chapterNo) {
    List<String> result = [];

    List<ParaFormat> redTexts = kRedTexts[chapterNo - 1];

    for (int i = 0; i < redTexts.length; i++) {
      if (redTexts[i].paragraph == paragraphNo) {
        result.add(redTexts[i].redStr);
      }

      if (redTexts[i].paragraph > paragraphNo) {
        break;
      }
    }
    return result;
  }
}

class MatthewParagraph extends pw.Paragraph {
  MatthewParagraph({
    text,
    textAlign = pw.TextAlign.justify,
    style,
    margin = const pw.EdgeInsets.only(top: 5.0 * PdfPageFormat.mm, bottom: 5.0 * PdfPageFormat.mm),
    padding,
    this.hasRed = false,
    required this.redTexts,
    this.paragraphNo = 0,
    this.fontSize = 13,
  }) : super(text: text, textAlign: textAlign, style: style, margin: margin, padding: padding);

  final bool hasRed;
  final List<String> redTexts;
  final int paragraphNo;
  final double fontSize;

  @override
  pw.Widget build(pw.Context context) {
    double paragraphFontSize = fontSize - 1;

    if (fontSize > 18) {
      paragraphFontSize = 18;
    }

    if (!hasRed) {
      return pw.Container(
        margin: margin,
        padding: padding,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 30,
            ),
            pw.Column(
              children: [
                pw.Container(
                  height: 1,
                  width: 30,
                  color: PdfColor.fromInt(0xFFDCB27D),
                ),
                pw.Text(
                  paragraphNo.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: paragraphFontSize,
                    color: PdfColor.fromInt(0xFF01AA4E),
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              width: 10,
            ),
            pw.Container(
              width: 390,
              child: pw.Text(
                text!,
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  fontSize: fontSize,
                  height: 1.8,
                  color: PdfColor.fromInt(0xFF000000),
                ),
                overflow: pw.TextOverflow.span,
              ),
            ),
          ],
        ),
      );
    }

    if (hasRed && redTexts[0].isEmpty) {
      return pw.Container(
        margin: margin,
        padding: padding,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 30,
            ),
            pw.Column(
              children: [
                pw.Container(
                  height: 1,
                  width: 30,
                  color: PdfColor.fromInt(0xFFDCB27D),
                ),
                pw.Text(
                  paragraphNo.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: paragraphFontSize,
                    color: PdfColor.fromInt(0xFF01AA4E),
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              width: 10,
            ),
            pw.Container(
              width: 390,
              child: pw.Text(
                text!,
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(
                  fontSize: fontSize,
                  height: 1.8,
                  color: PdfColor.fromInt(0xFFE51D52),
                ),
                overflow: pw.TextOverflow.span,
              ),
            ),
          ],
        ),
      );
    }

    List<pw.TextSpan> textSpans = [];

    String restText = text!;
    for (int i = 0; i < redTexts.length; i++) {
      int index = restText.indexOf(redTexts[i]);

      if (index != 0) {
        textSpans.add(
          pw.TextSpan(
            text: restText.substring(0, index),
            style: pw.TextStyle(
              fontSize: fontSize,
              height: 1.8,
              color: PdfColor.fromInt(0xFF000000),
            ),
          ),
        );
        restText = restText.substring(index, restText.length);
        restText = restText.trim();
      }

      textSpans.add(
        pw.TextSpan(
          text: (restText.substring(0, redTexts[i].length)).trim(),
          style: pw.TextStyle(
            fontSize: fontSize,
            height: 1.8,
            color: PdfColor.fromInt(0xFFE51D52),
          ),
        ),
      );
      restText = restText.substring(redTexts[i].length, restText.length);
    }

    if (restText.isNotEmpty) {
      textSpans.add(
        pw.TextSpan(
          text: restText,
          style: pw.TextStyle(
            fontSize: fontSize,
            height: 1.8,
            color: PdfColor.fromInt(0xFF000000),
          ),
        ),
      );
    }

    return pw.Container(
      margin: margin,
      padding: padding,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 30,
          ),
          pw.Column(
            children: [
              pw.Container(
                height: 1,
                width: 30,
                color: PdfColor.fromInt(0xFFDCB27D),
              ),
              pw.Text(
                paragraphNo.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: paragraphFontSize,
                  color: PdfColor.fromInt(0xFF01AA4E),
                ),
              ),
            ],
          ),
          pw.SizedBox(
            width: 10,
          ),
          pw.Container(
            width: 390,
            child: pw.RichText(
              textAlign: pw.TextAlign.justify,
              overflow: pw.TextOverflow.span,
              text: pw.TextSpan(
                style: pw.TextStyle(
                  fontSize: fontSize,
                  height: 1.8,
                  color: PdfColor.fromInt(0xFF000000),
                ),
                children: textSpans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
