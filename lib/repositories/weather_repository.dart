import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRepository {
  final String apiKey =
      'c98f9eab40084c3391d94956240312'; // Укажите ваш ключ API

  Future<WeatherModel> fetchWeather(String city) async {
    final url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Ошибка при загрузке данных: ${response.statusCode}');
    }
  }
}
