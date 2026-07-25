import 'package:intl/intl.dart';

class CurrencyUtils {
  static final Map<String, String> currencySymbols = {
    'INR': '₹',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'AED': 'AED ',
  };

  static String getSymbol(String currencyCode) {
    return currencySymbols[currencyCode.toUpperCase()] ?? '$currencyCode ';
  }

  static String format(double amount, {String currency = 'INR', bool showSymbol = true}) {
    final symbol = getSymbol(currency);
    final formatter = NumberFormat.currency(
      symbol: showSymbol ? symbol : '',
      decimalDigits: amount.truncateToDouble() == amount ? 0 : 2,
    );
    return formatter.format(amount).trim();
  }
}
