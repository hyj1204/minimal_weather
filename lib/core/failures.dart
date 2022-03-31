class Failure implements Exception {
  /// Exception thrown when locationSearch fails.
  Failure.locationIdRequestFailure();

  /// Exception thrown when the provided location is not found.
  Failure.locationNotFoundFailure();

  /// Exception thrown when getWeather fails.
  Failure.weatherRequestFailure();

  /// Exception thrown when weather for provided location is not found.
  Failure.weatherNotFoundFailure();

  Failure.unexpectedError();
}
