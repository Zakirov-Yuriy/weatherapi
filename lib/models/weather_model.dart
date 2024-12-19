class WeatherModel {
  final String city;
  final double temperature;
  final String condition;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['name'],
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
    );
  }
}
