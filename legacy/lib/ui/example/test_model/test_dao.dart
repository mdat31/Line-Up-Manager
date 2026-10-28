import 'package:marozi/model/player/player.dart';
import 'package:marozi/ui/example/test_model/test_model.dart';
import 'package:marozi/utils/database_helpers.dart';
import 'package:sqflite/sqflite.dart';

class TestDao {
  final helper = DatabaseHelper.instance;

  Future<int> createTest(TestObj testObj) async {
    final db = await helper.database;
    int result = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) from $tablePlayer WHERE id = \'${testObj.id}\''));
    if (result < 1) {
      result = await db.insert(tablePlayer, testObj.toMap());
    }
    return result;
  }
}
