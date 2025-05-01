// 定义设置表
import 'package:drift/drift.dart';

// Tables can mix-in common definitions if needed
mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();

  // create_at 字段，日期时间类型
  DateTimeColumn get createAt => dateTime().withDefault(currentDateAndTime)();

  // update_at 字段，日期时间类型
  DateTimeColumn get updateAt => dateTime().nullable()();
}

@DataClassName('SettingsModel')
class Settings extends Table with AutoIncrementingPrimaryKey {
  TextColumn get key => text().withLength(min: 1, max: 100)();
  TextColumn get value => text().nullable()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
        {key}
      ];
}

// 定义下载任务表
@DataClassName('DownloadTasksModel')
class DownloadTasks extends Table with AutoIncrementingPrimaryKey {
  TextColumn get key => text().nullable()();
  TextColumn get url => text()();
  TextColumn get duration => text().nullable()();
  TextColumn get thumbnail => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get log => text().nullable()();
  IntColumn get filesize => integer().withDefault(const Constant(0))();
  BlobColumn get thumb => blob().nullable()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
        {url}
      ];
}

@DataClassName('CookiesModel')
class Cookies extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();

  // cookie_path 字段，字符串类型
  TextColumn get cookiePath => text().nullable()();

  IntColumn get expiry => integer().withDefault(const Constant(0))();

  List<Index> get indexs => [Index('idx_name', 'name')];

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
        {name}
      ];
}
