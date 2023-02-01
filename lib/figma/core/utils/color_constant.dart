import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color annual = fromHex('#b6efb6');
  static Color hostpital = fromHex('#fdd7ad');
  static Color medical = fromHex('#fab2ac');
  static Color materinity = fromHex('#f2f595');
  static Color unpaid = fromHex('#c7f7f2');

  /*
  static Color annual = fromHex('#56b856');
  static Color hostpital = fromHex('#f3753a');
  static Color medical = fromHex('#dc3f32');
  static Color materinity = fromHex('#f4fa5b');
  static Color unpaid = fromHex('#45f6e4');
   */

  static Color orangeA100 = fromHex('#e6cf89');
  static Color bluegray200 = fromHex('#bcc1cd');
  static Color gray700 = fromHex('#565656');

  static Color black900 = fromHex('#000000');
  static Color red50 = fromHex('#fff1ec');
  static Color black90087 = fromHex('#87000000');
  static Color indigo700 = fromHex('#473f97');


  static Color pink900 = fromHex('#69025d');

  static Color black9003f = fromHex('#3f000000');

  static Color whiteA700 = fromHex('#ffffff');

  static Color purple600 = fromHex('#9d078b');

  static Color black9007e = fromHex('#7e000000');

  static Color gray800 = fromHex('#5c2525');
  static Color gray900 = fromHex('#202525');

  static Color whiteA70090 = fromHex('#90ffffff');

  static Color lightBlue50 = fromHex('#d4f5ff');

  static Color teal50 = fromHex('#d4ffea');

  static Color gray200 = fromHex('#e8eaec');

  static Color blue50 = fromHex('#ebf0ff');

  static Color red100 = fromHex('#ffd4d4');

  static Color gray100 = fromHex('#f5f5f5');

  static Color deepOrangeA700 = fromHex('#eb1818');

  static Color redA700 = fromHex('#ff0000');

  static Color pink400 = fromHex('#fd3667');

  //extra
  static Color purple900 =fromHex('#69025D');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
