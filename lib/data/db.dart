import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/db_model.dart';

class DbUtils {
  Database database;

  _init() async {
    print(" dbutils created");
    database = await openDatabase(
        join(await getDatabasesPath(), 'tomato_work.db'),
        version: 1, onCreate: (db, version) async {
      await db.execute('''
          create table TaskInfo(
	               `id` INTEGER primary key,
                 `name` varchar(100) not null,
                 `status` integer default 0 ,
                 `estimatedDuration` integer not null ,
                 `realDuration` integer ,
                 `startTime` integer ,
                 `createTime` integer  not null   
          )
          ''');

      await db.execute('''
          create table TomatoInfo(
	               `id` INTEGER primary key,
                 `status` integer default 0 ,
                 `duration` integer not null ,
                 `createTime` integer  not null   
          )
          ''');
    });
  }

  Future<void> check() async {
    if (database == null) {
      await _init();
    }
  }

  ///增加一条任务记录
  Future<int> addTaskInfo(TaskInfo taskInfo) async {
    await check();
    final Database db = database;
    return db.insert('TaskInfo', taskInfo.toMap());
  }

  /// 更新任务信息
  Future<int> updateTaskInfo(TaskInfo taskInfo) async {
    await check();
    final Database db = database;
    return db.update('TaskInfo', taskInfo.toMapWithoutId(),
        where: 'id = ?', whereArgs: [taskInfo.id]);
  }

  ///查询某个时间段内的所有任务记录[startTime]是时间段起始时间，[endTime]是时间段截止时间，
  ///两者都是时间戳形式
  Future<List<TaskInfo>> queryTasks(int startTime, int endTime) async {
    await check();
    List<Map<String, dynamic>> maps = await database.query('TaskInfo',
        where: 'createTime > ? and createTime < ?',
        whereArgs: [startTime, endTime],
        orderBy: 'createTime');
    return List.generate(maps.length, (i) {
      return TaskInfo.fromMap(maps[i]);
    });
  }

  /// 查询今天的所有任务
  Future<List<TaskInfo>> queryPresentTasks() async {
    DateTime now = DateTime.now();
    //取到今天开始凌晨的时间
    DateTime todayStart = now.add(
        Duration(hours: -now.hour, minutes: -now.minute, seconds: -now.second));
    //计算今天23:59:59的时间
    DateTime todayEnd = now.add(Duration(
        hours: 23 - now.hour,
        minutes: 59 - now.minute,
        seconds: 59 - now.second));
    return queryTasks(
        todayStart.millisecondsSinceEpoch, todayEnd.millisecondsSinceEpoch);
  }
}
