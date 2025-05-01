import 'package:drift/drift.dart';
import 'package:drift/native.dart'; // 使用 drift 的本地支持
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import '../download_task_list.dart';
import './table.dart';

part 'database.g.dart'; // 生成的代码

@DriftDatabase(tables: [Settings, DownloadTasks, Cookies])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // 增加版本号

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // if (from == 1) {
          //   await m.addColumn(downloadTasks, downloadTasks.filesize);
          //   await m.addColumn(downloadTasks, downloadTasks.thumb);
          // }
        },
      );

  // 增加设置
  Future<void> updateOrInsertSettinng(String key, String val) async {
    final data = SettingsCompanion.insert(
        key: key, value: Value(val), updateAt: Value(DateTime.now()));
    await into(settings).insert(data,
        onConflict: DoUpdate((old) => data, target: [settings.key]));
  }

  Future<String?> getSetting(String key) async {
    final result = await (select(settings)..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  Future<Map<String, String?>> getSettingsList(List<String> key) async {
    final result =
        await (select(settings)..where((tbl) => tbl.key.isIn(key))).get();
    return result
        .asMap()
        .map((index, element) => MapEntry(element.key, element.value));
  }

  Future<void> deleteSetting(String key) {
    return (delete(settings)..where((tbl) => tbl.key.equals(key))).go();
  }

  // 增加下载任务
  Future<int> updateOrInsertTask(DownloadTaskList task) async {
    final data = DownloadTasksCompanion.insert(
        key: Value(task.key),
        url: task.url,
        duration: Value(task.duration),
        thumbnail: Value(task.thumbnail),
        title: Value(task.title),
        status: Value(task.status),
        log: Value(task.log),
        filesize: Value(task.filesize),
        thumb: Value(task.thumb),
        updateAt: Value(DateTime.now()));
    return await into(downloadTasks).insert(data,
        onConflict: DoUpdate((old) => data, target: [downloadTasks.url]));
  }

  Future<List<DownloadTasksModel>> getDownloadTasks({
    int offset = 0,
    int limit = 20,
  }) async {
    return await (select(downloadTasks)
          ..limit(limit, offset: offset)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.id,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
  }

  Future<void> clearDownloadTasks() {
    return delete(downloadTasks).go();
  }

  // 添加删除单个任务的方法
  Future<void> deleteTaskByUrl(String url) async {
    await (delete(downloadTasks)..where((tbl) => tbl.url.equals(url))).go();
  }

  Future<void> deleteTaskById(int id) async {
    await (delete(downloadTasks)..where((tbl) => tbl.id.equals(id))).go();
  }

  // 插入或更新 Cookie
  Future<void> updateOrInsertCookie(
    String name,
    String cookiePath,
    int expiry,
  ) async {
    final data = CookiesCompanion.insert(
        name: name,
        cookiePath: Value(cookiePath),
        expiry: Value(expiry),
        updateAt: Value(DateTime.now()));
    await into(cookies).insert(data,
        onConflict: DoUpdate((old) => data, target: [cookies.name]));
  }

  // 查询所有 Cookie
  Future<List<CookiesModel>> getAllCookies() async {
    return await select(cookies).get();
  }

  // 根据 name 查询 Cookie
  Future<CookiesModel?> getValidCookies(String name) async {
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return await (select(cookies)
          ..where((tbl) =>
              tbl.name.equals(name) &
              tbl.expiry.isBiggerThanValue(currentTimestamp)))
        .getSingleOrNull();
  }

  // 删除 Cookie
  Future<int> deleteCookie(String name, String path) async {
    return await (delete(cookies)
          ..where((tbl) => tbl.name.equals(name) & tbl.cookiePath.equals(path)))
        .go();
  }
}

// 打开数据库连接
QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    try {
      Directory directory;
      if (Platform.isMacOS) {
        directory = await getLibraryDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final dbFolder = Directory(p.join(directory.path, 'Databases'));
      if (!await dbFolder.exists()) {
        await dbFolder.create(recursive: true);
      }

      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      print('Database path: ${file.path}');
      print('Database directory exists: ${await file.parent.exists()}');
      print(
          'Database directory is writable: ${await file.parent.stat().then((stat) => stat.mode)}');

      return NativeDatabase.createInBackground(file, logStatements: true);
    } catch (e, stackTrace) {
      print('Database initialization error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  });
}
