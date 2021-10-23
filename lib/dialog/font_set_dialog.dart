import 'package:flutter/material.dart';
import 'package:matthew/constants/constants.dart';
import 'package:matthew/utils/settings.dart';

class FontSetDialog extends StatefulWidget {
  const FontSetDialog({Key? key}) : super(key: key);

  @override
  _FontSetDialogState createState() => _FontSetDialogState();
}

class _FontSetDialogState extends State<FontSetDialog> {
  Settings _settings = Settings();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color(0xFF167EC7),
            width: 1.0,
          ),
        ),
        width: 252,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFF167EC7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "폰트선택",
                style: TextStyle(
                  fontFamily: _settings.getFontName(),
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_GODIC);
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "나눔고딕",
                  style: TextStyle(
                    fontFamily: FONT_GODIC,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_MYOUNGJO);
              },
              child: Container(
                height: 45,
                color: Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: Text(
                  "나눔명조",
                  style: TextStyle(
                    fontFamily: FONT_MYOUNGJO,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_NSQUARE);
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "나눔스퀘어",
                  style: TextStyle(
                    fontFamily: FONT_NSQUARE,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_GMARKET);
              },
              child: Container(
                height: 45,
                color: Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: Text(
                  "지마켓산스",
                  style: TextStyle(
                    fontFamily: FONT_GMARKET,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_NEXON);
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "넥슨 Lv.1 고딕",
                  style: TextStyle(
                    fontFamily: FONT_NEXON,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_GOWUND);
              },
              child: Container(
                height: 45,
                color: Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: Text(
                  "고운돋움",
                  style: TextStyle(
                    fontFamily: FONT_GOWUND,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_GOWUNB);
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "고운바탕",
                  style: TextStyle(
                    fontFamily: FONT_GOWUNB,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_TWAY);
              },
              child: Container(
                height: 45,
                color: Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: Text(
                  "티웨이항공",
                  style: TextStyle(
                    fontFamily: FONT_TWAY,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_COOKIE);
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "쿠키런",
                  style: TextStyle(
                    fontFamily: FONT_COOKIE,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, FONT_KYOBO);
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "교보손글씨",
                  style: TextStyle(
                    fontFamily: FONT_KYOBO,
                    fontSize: 20,
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
}
