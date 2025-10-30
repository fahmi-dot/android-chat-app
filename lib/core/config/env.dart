class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://localhost:8080/ws',
  );

  static const bool isProduction = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev'
  ) == 'prod';
}
