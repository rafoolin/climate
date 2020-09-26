import 'package:intl/intl.dart';

class ConsolidatedWeather {
  int id;
  String weatherStateName;
  String weatherStateAbbr;
  String windDirectionCompass;
  DateTime created;
  DateTime applicableDate;
  double minTemp;
  double maxTemp;
  double theTemp;
  double windSpeed;
  double windDirection;
  double airPressure;
  int humidity;
  double visibility;
  int predictability;

  ConsolidatedWeather({
    this.id,
    this.weatherStateName,
    this.weatherStateAbbr,
    this.windDirectionCompass,
    this.created,
    this.applicableDate,
    this.minTemp,
    this.maxTemp,
    this.theTemp,
    this.windSpeed,
    this.windDirection,
    this.airPressure,
    this.humidity,
    this.visibility,
    this.predictability,
  });

  ConsolidatedWeather.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weatherStateName = json['weather_state_name'];
    weatherStateAbbr = json['weather_state_abbr'];
    windDirectionCompass = json['wind_direction_compass'];
    created = DateTime.parse(json['created']);
    // Date in UTC
    applicableDate = DateTime.parse('${json['applicable_date']}T00:00:00.000Z');
    minTemp = json['min_temp'];
    maxTemp = json['max_temp'];
    theTemp = json['the_temp'];
    windSpeed = json['wind_speed'];
    windDirection = json['wind_direction'];
    airPressure = json['air_pressure'];
    humidity = json['humidity'];
    visibility = json['visibility'];
    predictability = json['predictability'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'weather_state_name': this.weatherStateName,
        'weather_state_abbr': this.weatherStateAbbr,
        'wind_direction_compass': this.windDirectionCompass,
        'created': this.created.toIso8601String(),
        'applicable_date': DateFormat('y-MM-dd').format(this.applicableDate),
        'min_temp': this.minTemp,
        'max_temp': this.maxTemp,
        'the_temp': this.theTemp,
        'wind_speed': this.windSpeed,
        'wind_direction': this.windDirection,
        'air_pressure': this.airPressure,
        'humidity': this.humidity,
        'visibility': this.visibility,
        'predictability': this.predictability
      };
}
