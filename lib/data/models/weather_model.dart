import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.g.dart';
part 'weather_model.freezed.dart';

@freezed
class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    required String city,
    required String country,
    required double? temperature,
    required double? feelsLike,
    required int? humidity,
    required double? windSpeed,
    required String description,
    required String icon,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
}
