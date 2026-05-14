import 'package:intl/intl.dart';
import '../domain/models/converted_date.dart';

class BSGregorianConverter {
  // Accurate Nepali calendar data mapping BS years to Gregorian dates
  // Reference date: 2000 BS starts at April 14, 1943 AD
  static const int _referenceADYear = 1943;
  static const int _referenceADMonth = 4;
  static const int _referenceADDay = 14;
  static const int _referenceBSYear = 2000;
  static const int _referenceBSMonth = 1;
  static const int _referenceBSDay = 1;

  // Days in each month for BS years (2000-2100)
  static final Map<int, List<int>> _bsMonthDays = {
    2000: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2001: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2002: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2003: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2004: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2005: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2006: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2007: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2008: [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
    2009: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2010: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2011: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2012: [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    2013: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2014: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2015: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2016: [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    2017: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2018: [31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2019: [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2020: [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    2021: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2022: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    2023: [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2024: [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    2025: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2026: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2027: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2028: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2029: [31, 31, 32, 31, 32, 30, 30, 29, 30, 29, 30, 30],
    2030: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2031: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2032: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2033: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2034: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2035: [30, 32, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
    2036: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2037: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2038: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2039: [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    2040: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2041: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2042: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2043: [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    2044: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2045: [31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2046: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2047: [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    2048: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2049: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    2050: [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2051: [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    2052: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2053: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    2054: [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2055: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2056: [31, 31, 32, 31, 32, 30, 30, 29, 30, 29, 30, 30],
    2057: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2058: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2059: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2060: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2061: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2062: [30, 32, 31, 32, 31, 31, 29, 30, 29, 30, 29, 31],
    2063: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2064: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2065: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2066: [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 29, 31],
    2067: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2068: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2069: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2070: [31, 31, 31, 32, 31, 31, 29, 30, 30, 29, 30, 30],
    2071: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2072: [31, 32, 31, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2073: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31],
    2074: [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    2075: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2076: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    2077: [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31],
    2078: [31, 31, 31, 32, 31, 31, 30, 29, 30, 29, 30, 30],
    2079: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30],
    2080: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 30],
    2081: [31, 31, 32, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2082: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2083: [31, 31, 32, 31, 31, 30, 30, 30, 29, 30, 30, 30],
    2084: [31, 31, 32, 31, 31, 30, 30, 30, 29, 30, 30, 30],
    2085: [31, 32, 31, 32, 30, 31, 30, 30, 29, 30, 30, 30],
    2086: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2087: [31, 31, 32, 31, 31, 31, 30, 30, 29, 30, 30, 30],
    2088: [30, 31, 32, 32, 30, 31, 30, 30, 29, 30, 30, 30],
    2089: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2090: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2091: [31, 31, 32, 31, 31, 31, 30, 30, 29, 30, 30, 30],
    2092: [30, 31, 32, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2093: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2094: [31, 31, 32, 31, 31, 30, 30, 30, 29, 30, 30, 30],
    2095: [31, 31, 32, 31, 31, 31, 30, 29, 30, 30, 30, 30],
    2096: [30, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30],
    2097: [31, 32, 31, 32, 31, 30, 30, 30, 29, 30, 30, 30],
    2098: [31, 31, 32, 31, 31, 31, 29, 30, 29, 30, 29, 31],
    2099: [31, 31, 32, 31, 31, 31, 30, 29, 29, 30, 30, 30],
    2100: [31, 32, 31, 32, 30, 31, 30, 29, 30, 29, 30, 30],
  };

  static ConvertedDate adToBs(DateTime gregorianDate) {
    // Use UTC to avoid timezone issues, keeping only date part
    final dateOnly = DateTime.utc(
        gregorianDate.year, gregorianDate.month, gregorianDate.day);
    final referenceDate =
        DateTime.utc(_referenceADYear, _referenceADMonth, _referenceADDay);
    final daysDifference = dateOnly.difference(referenceDate).inDays;

    int bsYear = _referenceBSYear;
    int bsMonth = _referenceBSMonth;
    int bsDay = _referenceBSDay + daysDifference;

    // Adjust BS date by adding days
    while (bsDay > 0) {
      final monthDays = _getMonthDays(bsYear, bsMonth);
      if (bsDay > monthDays) {
        bsDay -= monthDays;
        bsMonth++;
        if (bsMonth > 12) {
          bsMonth = 1;
          bsYear++;
        }
      } else {
        break;
      }
    }

    // Handle negative days (dates before reference)
    while (bsDay <= 0) {
      bsMonth--;
      if (bsMonth < 1) {
        bsMonth = 12;
        bsYear--;
      }
      bsDay += _getMonthDays(bsYear, bsMonth);
    }

    final bsDate =
        '$bsYear/${bsMonth.toString().padLeft(2, '0')}/${bsDay.toString().padLeft(2, '0')}';

    return ConvertedDate(
      gregorianDate: gregorianDate,
      bsDate: bsDate,
      dayOfWeek: DateFormat('EEEE').format(gregorianDate),
      difference: _calculateDifference(gregorianDate, DateTime.now()),
    );
  }

  static DateTime bsToAd(String bsDate) {
    final parts = bsDate.split('/');
    if (parts.length != 3) {
      throw const FormatException('Invalid BS date format');
    }

    final bsYear = int.parse(parts[0]);
    final bsMonth = int.parse(parts[1]);
    final bsDay = int.parse(parts[2]);

    if (!isValidBsDate(bsDate)) {
      throw const FormatException('Invalid BS date');
    }

    // Calculate total days from reference BS date
    int totalDays = 0;

    // Add days for complete years
    for (int year = _referenceBSYear; year < bsYear; year++) {
      for (int month = 1; month <= 12; month++) {
        totalDays += _getMonthDays(year, month);
      }
    }

    // Add days for complete months in target year
    for (int month = 1; month < bsMonth; month++) {
      totalDays += _getMonthDays(bsYear, month);
    }

    // Add remaining days
    totalDays += bsDay - 1; // -1 because reference day is day 1

    // Calculate AD date using UTC to avoid timezone issues
    final referenceDate =
        DateTime.utc(_referenceADYear, _referenceADMonth, _referenceADDay);
    final resultDate = referenceDate.add(Duration(days: totalDays));

    // Convert back to local date (without time component)
    return DateTime(resultDate.year, resultDate.month, resultDate.day);
  }

  static int _getMonthDays(int year, int month) {
    if (_bsMonthDays.containsKey(year)) {
      return _bsMonthDays[year]![month - 1];
    }
    // Default fallback (should not happen with proper data)
    return month == 12 ? 30 : 31;
  }

  static String _calculateDifference(DateTime date1, DateTime date2) {
    final difference = date1.difference(date2).abs();
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    final days = (difference.inDays % 365) % 30;

    if (years > 0) {
      return '$years year${years > 1 ? 's' : ''}, $months month${months > 1 ? 's' : ''}, $days day${days > 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months month${months > 1 ? 's' : ''}, $days day${days > 1 ? 's' : ''}';
    } else {
      return '$days day${days > 1 ? 's' : ''}';
    }
  }

  static bool isValidBsDate(String bsDate) {
    try {
      final parts = bsDate.split('/');
      if (parts.length != 3) return false;

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      if (!_bsMonthDays.containsKey(year)) return false;
      if (month < 1 || month > 12) return false;
      if (day < 1) return false;

      final maxDays = _getMonthDays(year, month);
      return day <= maxDays;
    } catch (e) {
      return false;
    }
  }
}
