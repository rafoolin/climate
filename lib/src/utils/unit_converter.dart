enum WindUnit { MPH, FPH, KPH }
enum TempUnit { C, F, K }
enum PressureUnit { MBAR, PA, PSI }
enum DistanceUnit { MILES, KM, FOOT, INCH }
enum TimezoneChoice { UTC, USER, LOCATION }

class UnitConverter {
  static String strUnit(Object unit) =>
      unit == null ? null : unit.toString().split('.')[1].toLowerCase();

  /// Convert [amount] from centigrade to [unit].
  /// centigrade is the API default unit.
  static double tempConverter({TempUnit unit, double amount}) {
    switch (unit) {
      //  (x°C × 9/5) + 32 = y°F
      case TempUnit.F:
        return (amount * 9) / 5 + 32.0;
        break;
      //0°C + 273.15 = 273.15K
      case TempUnit.K:
        return amount * 5280;
        break;
      default:
        return amount;
    }
  }

  /// Convert [amount] from mph to [unit].
  /// mph is the API default unit.
  static double windConverter({WindUnit unit, double amount}) {
    switch (unit) {
      case WindUnit.KPH:
        return amount * 1.609;
        break;
      case WindUnit.FPH:
        return amount * 5280;
        break;
      default:
        return amount;
    }
  }

  /// Convert [amount] from mbar to [unit].
  /// mbar is the API default unit.
  static double pressureConverter({PressureUnit unit, double amount}) {
    switch (unit) {
      case PressureUnit.PA:
        return amount * 100;
        break;
      case PressureUnit.PSI:
        return amount / 68.948;
        break;
      default:
        return amount;
    }
  }

  /// Convert [amount] from miles to [unit].
  /// miles is the API default unit.
  static double distanceConverter({DistanceUnit unit, double amount}) {
    switch (unit) {
      case DistanceUnit.FOOT:
        return amount * 5280;
        break;
      case DistanceUnit.KM:
        return amount * 1.60934;
        break;
      case DistanceUnit.FOOT:
        return amount * 63360;
        break;
      default:
        return amount;
    }
  }

  /// Convert [time] from UTC to [timezone] Timezone.
  /// [offset] is the location timezone offset.
  static DateTime timezoneConverter({
    TimezoneChoice timezone,
    DateTime time,
    Duration offset,
  }) {
    // Local timezone
    switch (timezone) {
      case TimezoneChoice.USER:
        return time.toLocal();
        break;
      case TimezoneChoice.LOCATION:
        return time.add(offset);
        break;
      default:
        return time;
    }
  }

  /// Return timezone name
  static String timezoneName({
    TimezoneChoice timezone,
    String climateTimezoneName,
  }) {
    // If unit is location, it needs the timezone name.
    assert(
        (timezone == TimezoneChoice.LOCATION && climateTimezoneName != null) ||
            timezone != TimezoneChoice.LOCATION);
    switch (timezone) {
      // User local timezone
      case TimezoneChoice.USER:
        return DateTime.now().timeZoneName;
        break;
      case TimezoneChoice.LOCATION:
        return climateTimezoneName;
        break;
      case TimezoneChoice.UTC:
      default:
        return 'UTC';
    }
  }
}
