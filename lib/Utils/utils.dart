import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locales/currency_codes.dart';
import 'package:locales/locales.dart';

class utils{

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
  static final locale = Locale.en_US;
  static final currencycode = CurrencyCode.usd;

  // Locale locale = Localizations.localeOf(context);

  //  String country = locale.countryCode;
  static var format = NumberFormat.simpleCurrency(
    locale: '$locale', name: '$currencycode',);

  static String localcurrency(value) => format.format(value);


}