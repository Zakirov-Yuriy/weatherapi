import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/weather_bloc.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<WeatherBloc>()
        .add(const FetchWeather("Omsk")); // Город по умолчанию
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Введите город',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          context.read<WeatherBloc>().add(FetchWeather(value));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context
                            .read<WeatherBloc>()
                            .add(FetchWeather(_controller.text));
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          'Введите город, чтобы узнать погоду.',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
                    );
                  } else if (state is WeatherLoading) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is WeatherLoaded) {
                    final weather = state.weather;
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Верхняя часть с температурой и иконкой
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    '${weather.temperature.toStringAsFixed(1)}°C',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    weather.condition,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            // Информация о городе
                            Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Город: ${weather.city}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Температура: ${weather.temperature}°C',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  } else if (state is WeatherError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'Ошибка: ${state.message}',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
