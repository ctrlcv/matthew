import 'package:flutter/material.dart';
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
                Navigator.pop(context, "");
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "시스템폰트",
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF7B7979),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "notosans");
              },
              child: Container(
                height: 45,
                color: Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/font_godic.png",
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "notoserif");
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/font_myoungjo.png",
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "gmarket");
              },
              child: Container(
                height: 45,
                color: Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/font_gmarket.png",
                  height: 24,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "nexon");
              },
              child: Container(
                height: 45,
                color: Colors.white,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/font_nexon.png",
                  height: 26,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "gowun");
              },
              child: Container(
                height: 45,
                color: Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/font_gowun.png",
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, "kyobo");
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/font_kyobo.png",
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
