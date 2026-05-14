import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/bs_gregorian_converter.dart';
import '../../domain/models/converted_date.dart';
import '../../domain/models/age_result.dart';

class DateConverterState {
  final DateTime? selectedGregorianDate;
  final String bsDateInput;
  final ConvertedDate? convertedDate;
  final bool isConvertingToBs;
  final String errorMessage;

  // additional tools
  final DateTime? secondDate;
  final AgeResult? ageResult;
  final int? daysBetween;
  final DateTime? addedDate;
  final DateTime? subtractedDate;
  final int? weekNumber;
  final Duration? countdownDuration;

  const DateConverterState({
    this.selectedGregorianDate,
    this.bsDateInput = '',
    this.convertedDate,
    this.isConvertingToBs = true,
    this.errorMessage = '',

    // new init values
    this.secondDate,
    this.ageResult,
    this.daysBetween,
    this.addedDate,
    this.subtractedDate,
    this.weekNumber,
    this.countdownDuration,
  });

  DateConverterState copyWith({
    DateTime? selectedGregorianDate,
    String? bsDateInput,
    ConvertedDate? convertedDate,
    bool? isConvertingToBs,
    String? errorMessage,

    // additional tools
    DateTime? secondDate,
    AgeResult? ageResult,
    int? daysBetween,
    DateTime? addedDate,
    DateTime? subtractedDate,
    int? weekNumber,
    Duration? countdownDuration,
  }) {
    return DateConverterState(
      selectedGregorianDate:
          selectedGregorianDate ?? this.selectedGregorianDate,
      bsDateInput: bsDateInput ?? this.bsDateInput,
      convertedDate: convertedDate ?? this.convertedDate,
      isConvertingToBs: isConvertingToBs ?? this.isConvertingToBs,
      errorMessage: errorMessage ?? this.errorMessage,
      secondDate: secondDate ?? this.secondDate,
      ageResult: ageResult ?? this.ageResult,
      daysBetween: daysBetween ?? this.daysBetween,
      addedDate: addedDate ?? this.addedDate,
      subtractedDate: subtractedDate ?? this.subtractedDate,
      weekNumber: weekNumber ?? this.weekNumber,
      countdownDuration: countdownDuration ?? this.countdownDuration,
    );
  }
}

class DateConverterController extends StateNotifier<DateConverterState> {
  DateConverterController() : super(const DateConverterState());

  void setGregorianDate(DateTime date) {
    state = state.copyWith(
      selectedGregorianDate: date,
      errorMessage: '',
    );
    _convertDate();
  }

  // NEW - second date for age/difference
  void setSecondDate(DateTime date) {
    state = state.copyWith(secondDate: date);
  }

  void calculateAge() {
    final birth = state.selectedGregorianDate;
    final ref = state.secondDate ?? DateTime.now();
    if (birth == null) return;
    if (ref.isBefore(birth)) {
      state = state.copyWith(
          errorMessage: 'Reference date must be after birth date');
      return;
    }

    int years = ref.year - birth.year;
    int months = ref.month - birth.month;
    int days = ref.day - birth.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(ref.year, ref.month, 0).day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    state = state.copyWith(
        ageResult: AgeResult(
      years: years,
      months: months,
      days: days,
    ));
  }

  void calculateDaysBetween() {
    final a = state.selectedGregorianDate;
    final b = state.secondDate;
    if (a == null || b == null) return;
    state = state.copyWith(daysBetween: b.difference(a).inDays.abs());
  }

  void addDays(int count) {
    final date = state.selectedGregorianDate;
    if (date == null) return;
    state = state.copyWith(addedDate: date.add(Duration(days: count)));
  }

  void subtractDays(int count) {
    final date = state.selectedGregorianDate;
    if (date == null) return;
    state =
        state.copyWith(subtractedDate: date.subtract(Duration(days: count)));
  }

  void calculateWeekNumber() {
    final date = state.selectedGregorianDate;
    if (date == null) return;
    final dayOfYear = int.parse(DateTime(date.year, date.month, date.day)
        .difference(DateTime(date.year, 1, 1))
        .inDays
        .toString());
    final week =
        ((dayOfYear + DateTime(date.year, 1, 1).weekday - 1) / 7).ceil();
    state = state.copyWith(weekNumber: week);
  }

  void startCountdown(DateTime target) {
    final now = DateTime.now();
    if (target.isBefore(now)) {
      state = state.copyWith(errorMessage: 'Target date must be in the future');
      return;
    }
    state = state.copyWith(countdownDuration: target.difference(now));
  }

  void setBsDate(String bsDate) {
    state = state.copyWith(
      bsDateInput: bsDate,
      errorMessage: '',
    );
  }

  void convertBsToAd() {
    if (state.bsDateInput.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a BS date');
      return;
    }

    if (!BSGregorianConverter.isValidBsDate(state.bsDateInput)) {
      state = state.copyWith(
          errorMessage: 'Invalid BS date format. Use YYYY/MM/DD');
      return;
    }

    try {
      final adDate = BSGregorianConverter.bsToAd(state.bsDateInput);
      final convertedDate =
          BSGregorianConverter.adToBs(adDate); // Get full conversion info

      state = state.copyWith(
        selectedGregorianDate: adDate,
        convertedDate: convertedDate,
        isConvertingToBs: false,
        errorMessage: '',
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Conversion failed: $e');
    }
  }

  void toggleConversionDirection() {
    state = state.copyWith(
      isConvertingToBs: !state.isConvertingToBs,
      errorMessage: '',
    );
  }

  void _convertDate() {
    if (state.selectedGregorianDate == null) return;

    try {
      final convertedDate =
          BSGregorianConverter.adToBs(state.selectedGregorianDate!);
      state = state.copyWith(
        convertedDate: convertedDate,
        errorMessage: '',
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Conversion failed: $e');
    }
  }

  void clearAll() {
    state = const DateConverterState();
  }
}

final dateConverterProvider =
    StateNotifierProvider<DateConverterController, DateConverterState>(
  (ref) => DateConverterController(),
);
