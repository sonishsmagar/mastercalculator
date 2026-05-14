class UnitConverter {
  static double convert(
    String category,
    String fromUnit,
    String toUnit,
    double value,
  ) {
    if (fromUnit == toUnit) return value;

    switch (category) {
      case 'Length':
        return _convertLength(fromUnit, toUnit, value);
      case 'Weight':
        return _convertWeight(fromUnit, toUnit, value);
      case 'Temperature':
        return _convertTemperature(fromUnit, toUnit, value);
      case 'Volume':
        return _convertVolume(fromUnit, toUnit, value);
      case 'Area':
        return _convertArea(fromUnit, toUnit, value);
      case 'Time':
        return _convertTime(fromUnit, toUnit, value);
      case 'Speed':
        return _convertSpeed(fromUnit, toUnit, value);
      case 'Data':
        return _convertData(fromUnit, toUnit, value);
      default:
        return value;
    }
  }

  static double _convertLength(String from, String to, double value) {
    // Convert to meters first
    double meters;
    switch (from) {
      case 'Meter':
        meters = value;
        break;
      case 'Kilometer':
        meters = value * 1000;
        break;
      case 'Centimeter':
        meters = value / 100;
        break;
      case 'Millimeter':
        meters = value / 1000;
        break;
      case 'Mile':
        meters = value * 1609.344;
        break;
      case 'Yard':
        meters = value * 0.9144;
        break;
      case 'Foot':
        meters = value * 0.3048;
        break;
      case 'Inch':
        meters = value * 0.0254;
        break;
      default:
        meters = value;
    }

    // Convert from meters to target
    switch (to) {
      case 'Meter':
        return meters;
      case 'Kilometer':
        return meters / 1000;
      case 'Centimeter':
        return meters * 100;
      case 'Millimeter':
        return meters * 1000;
      case 'Mile':
        return meters / 1609.344;
      case 'Yard':
        return meters / 0.9144;
      case 'Foot':
        return meters / 0.3048;
      case 'Inch':
        return meters / 0.0254;
      default:
        return meters;
    }
  }

  static double _convertWeight(String from, String to, double value) {
    // Convert to kilograms first
    double kg;
    switch (from) {
      case 'Kilogram':
        kg = value;
        break;
      case 'Gram':
        kg = value / 1000;
        break;
      case 'Milligram':
        kg = value / 1000000;
        break;
      case 'Pound':
        kg = value * 0.453592;
        break;
      case 'Ounce':
        kg = value * 0.0283495;
        break;
      case 'Ton':
        kg = value * 1000;
        break;
      default:
        kg = value;
    }

    // Convert from kg to target
    switch (to) {
      case 'Kilogram':
        return kg;
      case 'Gram':
        return kg * 1000;
      case 'Milligram':
        return kg * 1000000;
      case 'Pound':
        return kg / 0.453592;
      case 'Ounce':
        return kg / 0.0283495;
      case 'Ton':
        return kg / 1000;
      default:
        return kg;
    }
  }

  static double _convertTemperature(String from, String to, double value) {
    // Convert to Celsius first
    double celsius;
    switch (from) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Convert from Celsius to target
    switch (to) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  static double _convertVolume(String from, String to, double value) {
    // Convert to liters first
    double liters;
    switch (from) {
      case 'Liter':
        liters = value;
        break;
      case 'Milliliter':
        liters = value / 1000;
        break;
      case 'Gallon':
        liters = value * 3.78541;
        break;
      case 'Quart':
        liters = value * 0.946353;
        break;
      case 'Pint':
        liters = value * 0.473176;
        break;
      case 'Cup':
        liters = value * 0.236588;
        break;
      default:
        liters = value;
    }

    // Convert from liters to target
    switch (to) {
      case 'Liter':
        return liters;
      case 'Milliliter':
        return liters * 1000;
      case 'Gallon':
        return liters / 3.78541;
      case 'Quart':
        return liters / 0.946353;
      case 'Pint':
        return liters / 0.473176;
      case 'Cup':
        return liters / 0.236588;
      default:
        return liters;
    }
  }

  static double _convertArea(String from, String to, double value) {
    // Convert to square meters first
    double sqMeters;
    switch (from) {
      case 'Square Meter':
        sqMeters = value;
        break;
      case 'Square Kilometer':
        sqMeters = value * 1000000;
        break;
      case 'Square Mile':
        sqMeters = value * 2589988.11;
        break;
      case 'Square Yard':
        sqMeters = value * 0.836127;
        break;
      case 'Square Foot':
        sqMeters = value * 0.092903;
        break;
      case 'Hectare':
        sqMeters = value * 10000;
        break;
      case 'Acre':
        sqMeters = value * 4046.86;
        break;
      default:
        sqMeters = value;
    }

    // Convert from square meters to target
    switch (to) {
      case 'Square Meter':
        return sqMeters;
      case 'Square Kilometer':
        return sqMeters / 1000000;
      case 'Square Mile':
        return sqMeters / 2589988.11;
      case 'Square Yard':
        return sqMeters / 0.836127;
      case 'Square Foot':
        return sqMeters / 0.092903;
      case 'Hectare':
        return sqMeters / 10000;
      case 'Acre':
        return sqMeters / 4046.86;
      default:
        return sqMeters;
    }
  }

  static double _convertTime(String from, String to, double value) {
    // Convert to seconds first
    double seconds;
    switch (from) {
      case 'Second':
        seconds = value;
        break;
      case 'Minute':
        seconds = value * 60;
        break;
      case 'Hour':
        seconds = value * 3600;
        break;
      case 'Day':
        seconds = value * 86400;
        break;
      case 'Week':
        seconds = value * 604800;
        break;
      case 'Month':
        seconds = value * 2628000; // 30.44 days average
        break;
      case 'Year':
        seconds = value * 31536000; // 365 days
        break;
      default:
        seconds = value;
    }

    // Convert from seconds to target
    switch (to) {
      case 'Second':
        return seconds;
      case 'Minute':
        return seconds / 60;
      case 'Hour':
        return seconds / 3600;
      case 'Day':
        return seconds / 86400;
      case 'Week':
        return seconds / 604800;
      case 'Month':
        return seconds / 2628000;
      case 'Year':
        return seconds / 31536000;
      default:
        return seconds;
    }
  }

  static double _convertSpeed(String from, String to, double value) {
    // Convert to m/s first
    double mps;
    switch (from) {
      case 'Meter/Second':
        mps = value;
        break;
      case 'Kilometer/Hour':
        mps = value / 3.6;
        break;
      case 'Mile/Hour':
        mps = value * 0.44704;
        break;
      case 'Foot/Second':
        mps = value * 0.3048;
        break;
      case 'Knot':
        mps = value * 0.514444;
        break;
      default:
        mps = value;
    }

    // Convert from m/s to target
    switch (to) {
      case 'Meter/Second':
        return mps;
      case 'Kilometer/Hour':
        return mps * 3.6;
      case 'Mile/Hour':
        return mps / 0.44704;
      case 'Foot/Second':
        return mps / 0.3048;
      case 'Knot':
        return mps / 0.514444;
      default:
        return mps;
    }
  }

  // Data conversion (bytes-based units)
  static double _convertData(String from, String to, double value) {
    double bytes;
    switch (from) {
      case 'Byte':
        bytes = value;
        break;
      case 'Kilobyte':
        bytes = value * 1024;
        break;
      case 'Megabyte':
        bytes = value * 1024 * 1024;
        break;
      case 'Gigabyte':
        bytes = value * 1024 * 1024 * 1024;
        break;
      case 'Terabyte':
        bytes = value * 1024 * 1024 * 1024 * 1024;
        break;
      default:
        bytes = value;
    }

    switch (to) {
      case 'Byte':
        return bytes;
      case 'Kilobyte':
        return bytes / 1024;
      case 'Megabyte':
        return bytes / (1024 * 1024);
      case 'Gigabyte':
        return bytes / (1024 * 1024 * 1024);
      case 'Terabyte':
        return bytes / (1024 * 1024 * 1024 * 1024);
      default:
        return bytes;
    }
  }
}
