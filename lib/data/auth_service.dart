import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  late SharedPreferences _prefs;
  final _dbHelper = DatabaseHelper();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _hashPassword(String password) {
    return sha256.convert(password.codeUnits).toString();
  }

  Future<bool> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    if (!_isValidEmail(email)) {
      return false;
    }

    if (password.length < 4) {
      return false;
    }

    try {
      final db = await _dbHelper.database;
      final passwordHash = _hashPassword(password);

      await db.insert(
        'users',
        {'email': email, 'password_hash': passwordHash},
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    try {
      final db = await _dbHelper.database;
      final passwordHash = _hashPassword(password);

      final result = await db.query(
        'users',
        where: 'email = ? AND password_hash = ?',
        whereArgs: [email, passwordHash],
      );

      if (result.isNotEmpty) {
        await _prefs.setBool(_isLoggedInKey, true);
        await _prefs.setString(_userEmailKey, email);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_userEmailKey);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}

