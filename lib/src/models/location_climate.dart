import 'package:climate/src/models/models.dart';

class LocationClimate extends Object {
  List<ConsolidatedWeather> consolidatedWeather;
  DateTime time;
  String timeStr;
  DateTime sunRise;
  DateTime sunSet;
  String timezoneName;
  Parent parent;
  List<Source> sources;
  String title;
  String locationType;
  int woeid;
  String lattLong;
  String timezone;
  Duration _offset = Duration();
  LocationClimate({
    this.consolidatedWeather,
    this.timeStr,
    this.time,
    this.sunRise,
    this.sunSet,
    this.timezoneName,
    this.parent,
    this.sources,
    this.title,
    this.locationType,
    this.woeid,
    this.lattLong,
    this.timezone,
  });
  LocationClimate.fromJson(Map<String, dynamic> json) {
    if (json['consolidated_weather'] != null) {
      consolidatedWeather = List<ConsolidatedWeather>();
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      json['consolidated_weather'].forEach(
        (forecast) {
          ConsolidatedWeather weather = ConsolidatedWeather.fromJson(forecast);
          // if (weather.applicableDate.isAfter(today) ||
          //     (weather.applicableDate.isAtSameMomentAs(today)))
          consolidatedWeather.add(weather);
        },
      );
    }
    timeStr = json.containsKey('time_str')
        ?
        // Data comes from database, it has "time_str" key
        json['time_str']
        :
        // Data comes from API and doesn't have "time_str" key
        json['time'];

    time = DateTime.parse(json['time']).toUtc();
    // Config Offset
    _offsetConfig();
    sunRise = DateTime.parse(json['sun_rise']).toUtc();
    sunSet = DateTime.parse(json['sun_set']).toUtc();
    timezoneName = json['timezone_name'];
    parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
    if (json['sources'] != null) {
      sources = List<Source>();
      json['sources'].forEach((v) {
        sources.add(Source.fromJson(v));
      });
    }
    title = json['title'];
    locationType = json['location_type'];
    woeid = json['woeid'];
    lattLong = json['latt_long'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.consolidatedWeather != null) {
      data['consolidated_weather'] = this
          .consolidatedWeather
          .map((forecast) => forecast.toJson())
          .toList();
    }
    data['time_str'] = this.timeStr;
    data['time'] = this.time.toIso8601String();
    data['sun_rise'] = this.sunRise.toIso8601String();
    data['sun_set'] = this.sunSet.toIso8601String();
    data['timezone_name'] = this.timezoneName;
    if (this.parent != null) {
      data['parent'] = this.parent.toJson();
    }
    if (this.sources != null)
      data['sources'] = this.sources.map((source) => source.toJson()).toList();
    data['title'] = this.title;
    data['location_type'] = this.locationType;
    data['woeid'] = this.woeid;
    data['latt_long'] = this.lattLong;
    data['timezone'] = this.timezone;
    return data;
  }

  Duration get offset => _offset;
  void _offsetConfig() {
    RegExp regExp = RegExp(r'[+-]\d\d:\d\d');
    // Extract offset from time
    String extractedTime = regExp.firstMatch(timeStr).group(0);
    String sign = extractedTime.substring(0, 1);
    // split 'HH:MM' to have HH and MM
    List<String> hm = extractedTime.substring(1).split(':');
    _offset = Duration(
      hours: int.parse('$sign${hm.first}'),
      minutes: int.parse('$sign${hm.last}'),
    );
  }
}
