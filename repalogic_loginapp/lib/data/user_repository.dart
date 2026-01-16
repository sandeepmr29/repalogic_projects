import '../model/user.dart';

import 'db_helper.dart';

class UserRepository {
  Future<void> register(User user) async {
    final db = await DBHelper.instance.database;
    await db.insert('users', user.toMap());
  }

  Future<bool> login(String email, String password) async {
    final db = await DBHelper.instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}
