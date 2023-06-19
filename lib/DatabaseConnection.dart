import 'package:mysql1/mysql1.dart';

class DatabaseConnection {
  static final _host = '104.197.162.49';
  static final _port = 3306;
  static final _user = 'root';
  static final _password = 'uhjnedcqweqwe38';
  static final _databaseName = 'ommerhotel';

  late MySqlConnection _connection;

  Future<MySqlConnection> connect() async {
    final settings = ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      password: _password,
      db: _databaseName,
    );
    _connection = await MySqlConnection.connect(settings);
    await Future.delayed(Duration(milliseconds: 1000));
    return _connection;
  }

  Future<void> close() async {
    await _connection.close();
  }
}
