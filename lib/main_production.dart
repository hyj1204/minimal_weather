import 'package:minimal_weather/app/app.dart';
import 'package:minimal_weather/bootstrap.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  bootstrap(() => WeatherApp(weatherRepository: WeatherRepository()));
}
