enum UnitCategory {
  length,
  weight,
  temperature,
  volume,
  area,
  time,
  speed,
  data, // added data units (MB, GB, TB etc.)
}

extension UnitCategoryExtension on UnitCategory {
  String get name {
    switch (this) {
      case UnitCategory.length:
        return 'Length';
      case UnitCategory.weight:
        return 'Weight';
      case UnitCategory.temperature:
        return 'Temperature';
      case UnitCategory.volume:
        return 'Volume';
      case UnitCategory.area:
        return 'Area';
      case UnitCategory.time:
        return 'Time';
      case UnitCategory.speed:
        return 'Speed';
      case UnitCategory.data:
        return 'Data';
    }
  }

  List<String> get units {
    switch (this) {
      case UnitCategory.length:
        return [
          'Meter',
          'Kilometer',
          'Centimeter',
          'Millimeter',
          'Mile',
          'Yard',
          'Foot',
          'Inch',
        ];
      case UnitCategory.weight:
        return [
          'Kilogram',
          'Gram',
          'Milligram',
          'Pound',
          'Ounce',
          'Ton',
        ];
      case UnitCategory.temperature:
        return [
          'Celsius',
          'Fahrenheit',
          'Kelvin',
        ];
      case UnitCategory.volume:
        return [
          'Liter',
          'Milliliter',
          'Gallon',
          'Quart',
          'Pint',
          'Cup',
        ];
      case UnitCategory.area:
        return [
          'Square Meter',
          'Square Kilometer',
          'Square Mile',
          'Square Yard',
          'Square Foot',
          'Hectare',
          'Acre',
        ];
      case UnitCategory.time:
        return [
          'Second',
          'Minute',
          'Hour',
          'Day',
          'Week',
          'Month',
          'Year',
        ];
      case UnitCategory.speed:
        return [
          'Meter/Second',
          'Kilometer/Hour',
          'Mile/Hour',
          'Foot/Second',
          'Knot',
        ];
      case UnitCategory.data:
        return [
          'Byte',
          'Kilobyte',
          'Megabyte',
          'Gigabyte',
          'Terabyte',
        ];
    }
  }
}
