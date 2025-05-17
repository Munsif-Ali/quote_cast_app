// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherModelImpl _$$WeatherModelImplFromJson(Map<String, dynamic> json) =>
    _$WeatherModelImpl(
      city: json['city'] as String,
      country: json['country'] as String,
      temperature: (json['temperature'] as num?)?.toDouble(),
      feelsLike: (json['feelsLike'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toInt(),
      windSpeed: (json['windSpeed'] as num?)?.toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$$WeatherModelImplToJson(_$WeatherModelImpl instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'description': instance.description,
      'icon': instance.icon,
    };
