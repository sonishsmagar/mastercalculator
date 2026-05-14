import 'package:equatable/equatable.dart';

class ConvertedDate extends Equatable {
  final DateTime gregorianDate;
  final String bsDate;
  final String dayOfWeek;
  final String difference;

  const ConvertedDate({
    required this.gregorianDate,
    required this.bsDate,
    required this.dayOfWeek,
    required this.difference,
  });

  @override
  List<Object> get props => [gregorianDate, bsDate];
}
