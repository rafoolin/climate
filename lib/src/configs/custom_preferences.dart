import 'package:climate/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPreferences {
  // ================================================================================
  // =                                     KEYS                                     =
  // ================================================================================
  static const String themeKey = 'selectedTheme';
  static const String locationKey = 'SelectedLocation';
  static const String languageKey = 'SelectedLang';
  static const String hourFormatKey = 'SelectedHourFormat';
  static const String updateKey = 'SelectedUpdatePeriod';
  static const String tempKey = 'SelectedTemp';
  static const String windKey = 'SelectedWind';
  static const String pressureKey = 'SelectedPressure';
  static const String distanceKey = 'SelectedDistance';
  static const String precipitationKey = 'SelectedPrecipitation';
  static const String placesKey = 'SelectedPlaces';
  static const String timezoneKey = 'Timezone';

  // ================================================================================
  // =                                  SAVE/FETCH                                  =
  // ================================================================================

  // ------------------------------------- THEME -------------------------------------
  /// save Theme Preference
  Future<bool> saveThemePreference({bool isDark = false}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(themeKey, isDark);
  }

  /// fetch Theme Preference
  Future<bool> fetchThemePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(themeKey) ?? false;
  }

  // ------------------------------------ LOCATION ------------------------------------
  /// save Location Preference
  Future<bool> saveLocationPreference({String location}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(locationKey, location);
  }

  /// fetch Location Preference
  Future<String> fetchLocationPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(locationKey) ?? '';
  }

  // ---------------------------------- TEMPERATURE ----------------------------------
  /// save temperature Preference
  Future<bool> saveTempPreference({TempUnit unit}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(tempKey, unit.index);
  }

  /// fetch temperature Preference
  Future<TempUnit> fetchTempPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return TempUnit.values[pref.getInt(tempKey) ?? 0];
  }

  // ----------------------------------- WIND SPEED -----------------------------------
  /// save Wind Speed Preference
  Future<bool> saveWindPreference({WindUnit unit}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(windKey, unit.index);
  }

  /// fetch Wind Speed Preference
  Future<WindUnit> fetchWindPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return WindUnit.values[pref.getInt(windKey) ?? 0];
  }

  // ------------------------------------ PRESSURE ------------------------------------
  /// save Pressure Preference
  Future<bool> savePressurePreference({PressureUnit unit}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(pressureKey, unit.index);
  }

  /// fetch Pressure Preference
  Future<PressureUnit> fetchPressurePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return PressureUnit.values[pref.getInt(pressureKey) ?? 0];
  }

  // ------------------------------------ DISTANCE ------------------------------------

  /// save Distance Preference
  Future<bool> saveDistancePreference({DistanceUnit unit}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(distanceKey, unit.index);
  }

  /// fetch Distance Preference
  Future<DistanceUnit> fetchDistancePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return DistanceUnit.values[pref.getInt(distanceKey) ?? 0];
  }

// ------------------------------------- PLACES -------------------------------------
  /// save places Preference
  Future<bool> savePlacesPreference({List<String> names}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setStringList(placesKey, names.toSet().toList());
  }

  /// fetch Places Preference
  Future<List<String>> fetchPlacesPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(placesKey) ?? [];
  }

  // ---------------------------------- Timezone -------------------------------------
  /// save Timezone Preference
  Future<bool> saveTimezonePreference({TimezoneChoice timezone}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt(timezoneKey, timezone?.index ?? 0);
  }

  /// fetch Timezone Preference
  Future<TimezoneChoice> fetchTimezonePreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return TimezoneChoice.values[pref.getInt(timezoneKey) ?? 0];
  }
}
