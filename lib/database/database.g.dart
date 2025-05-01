// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updateAtMeta =
      const VerificationMeta('updateAt');
  @override
  late final GeneratedColumn<DateTime> updateAt = GeneratedColumn<DateTime>(
      'update_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, createAt, updateAt, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    }
    if (data.containsKey('update_at')) {
      context.handle(_updateAtMeta,
          updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {key},
      ];
  @override
  SettingsModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at']),
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingsModel extends DataClass implements Insertable<SettingsModel> {
  final int id;
  final DateTime createAt;
  final DateTime? updateAt;
  final String key;
  final String? value;
  const SettingsModel(
      {required this.id,
      required this.createAt,
      this.updateAt,
      required this.key,
      this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['create_at'] = Variable<DateTime>(createAt);
    if (!nullToAbsent || updateAt != null) {
      map['update_at'] = Variable<DateTime>(updateAt);
    }
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      createAt: Value(createAt),
      updateAt: updateAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updateAt),
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsModel(
      id: serializer.fromJson<int>(json['id']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
      updateAt: serializer.fromJson<DateTime?>(json['updateAt']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createAt': serializer.toJson<DateTime>(createAt),
      'updateAt': serializer.toJson<DateTime?>(updateAt),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  SettingsModel copyWith(
          {int? id,
          DateTime? createAt,
          Value<DateTime?> updateAt = const Value.absent(),
          String? key,
          Value<String?> value = const Value.absent()}) =>
      SettingsModel(
        id: id ?? this.id,
        createAt: createAt ?? this.createAt,
        updateAt: updateAt.present ? updateAt.value : this.updateAt,
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
      );
  SettingsModel copyWithCompanion(SettingsCompanion data) {
    return SettingsModel(
      id: data.id.present ? data.id.value : this.id,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      updateAt: data.updateAt.present ? data.updateAt.value : this.updateAt,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsModel(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createAt, updateAt, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsModel &&
          other.id == this.id &&
          other.createAt == this.createAt &&
          other.updateAt == this.updateAt &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingsModel> {
  final Value<int> id;
  final Value<DateTime> createAt;
  final Value<DateTime?> updateAt;
  final Value<String> key;
  final Value<String?> value;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    required String key,
    this.value = const Value.absent(),
  }) : key = Value(key);
  static Insertable<SettingsModel> custom({
    Expression<int>? id,
    Expression<DateTime>? createAt,
    Expression<DateTime>? updateAt,
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createAt != null) 'create_at': createAt,
      if (updateAt != null) 'update_at': updateAt,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createAt,
      Value<DateTime?>? updateAt,
      Value<String>? key,
      Value<String?>? value}) {
    return SettingsCompanion(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<DateTime>(updateAt.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $DownloadTasksTable extends DownloadTasks
    with TableInfo<$DownloadTasksTable, DownloadTasksModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updateAtMeta =
      const VerificationMeta('updateAt');
  @override
  late final GeneratedColumn<DateTime> updateAt = GeneratedColumn<DateTime>(
      'update_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
      'duration', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _thumbnailMeta =
      const VerificationMeta('thumbnail');
  @override
  late final GeneratedColumn<String> thumbnail = GeneratedColumn<String>(
      'thumbnail', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logMeta = const VerificationMeta('log');
  @override
  late final GeneratedColumn<String> log = GeneratedColumn<String>(
      'log', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _filesizeMeta =
      const VerificationMeta('filesize');
  @override
  late final GeneratedColumn<int> filesize = GeneratedColumn<int>(
      'filesize', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _thumbMeta = const VerificationMeta('thumb');
  @override
  late final GeneratedColumn<Uint8List> thumb = GeneratedColumn<Uint8List>(
      'thumb', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createAt,
        updateAt,
        key,
        url,
        duration,
        thumbnail,
        title,
        status,
        log,
        filesize,
        thumb
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadTasksModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    }
    if (data.containsKey('update_at')) {
      context.handle(_updateAtMeta,
          updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('thumbnail')) {
      context.handle(_thumbnailMeta,
          thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('log')) {
      context.handle(
          _logMeta, log.isAcceptableOrUnknown(data['log']!, _logMeta));
    }
    if (data.containsKey('filesize')) {
      context.handle(_filesizeMeta,
          filesize.isAcceptableOrUnknown(data['filesize']!, _filesizeMeta));
    }
    if (data.containsKey('thumb')) {
      context.handle(
          _thumbMeta, thumb.isAcceptableOrUnknown(data['thumb']!, _thumbMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {url},
      ];
  @override
  DownloadTasksModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadTasksModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at']),
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}duration']),
      thumbnail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      log: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}log']),
      filesize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}filesize'])!,
      thumb: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}thumb']),
    );
  }

  @override
  $DownloadTasksTable createAlias(String alias) {
    return $DownloadTasksTable(attachedDatabase, alias);
  }
}

class DownloadTasksModel extends DataClass
    implements Insertable<DownloadTasksModel> {
  final int id;
  final DateTime createAt;
  final DateTime? updateAt;
  final String? key;
  final String url;
  final String? duration;
  final String? thumbnail;
  final String? title;
  final String? status;
  final String? log;
  final int filesize;
  final Uint8List? thumb;
  const DownloadTasksModel(
      {required this.id,
      required this.createAt,
      this.updateAt,
      this.key,
      required this.url,
      this.duration,
      this.thumbnail,
      this.title,
      this.status,
      this.log,
      required this.filesize,
      this.thumb});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['create_at'] = Variable<DateTime>(createAt);
    if (!nullToAbsent || updateAt != null) {
      map['update_at'] = Variable<DateTime>(updateAt);
    }
    if (!nullToAbsent || key != null) {
      map['key'] = Variable<String>(key);
    }
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<String>(duration);
    }
    if (!nullToAbsent || thumbnail != null) {
      map['thumbnail'] = Variable<String>(thumbnail);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || log != null) {
      map['log'] = Variable<String>(log);
    }
    map['filesize'] = Variable<int>(filesize);
    if (!nullToAbsent || thumb != null) {
      map['thumb'] = Variable<Uint8List>(thumb);
    }
    return map;
  }

  DownloadTasksCompanion toCompanion(bool nullToAbsent) {
    return DownloadTasksCompanion(
      id: Value(id),
      createAt: Value(createAt),
      updateAt: updateAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updateAt),
      key: key == null && nullToAbsent ? const Value.absent() : Value(key),
      url: Value(url),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      thumbnail: thumbnail == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnail),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      log: log == null && nullToAbsent ? const Value.absent() : Value(log),
      filesize: Value(filesize),
      thumb:
          thumb == null && nullToAbsent ? const Value.absent() : Value(thumb),
    );
  }

  factory DownloadTasksModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadTasksModel(
      id: serializer.fromJson<int>(json['id']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
      updateAt: serializer.fromJson<DateTime?>(json['updateAt']),
      key: serializer.fromJson<String?>(json['key']),
      url: serializer.fromJson<String>(json['url']),
      duration: serializer.fromJson<String?>(json['duration']),
      thumbnail: serializer.fromJson<String?>(json['thumbnail']),
      title: serializer.fromJson<String?>(json['title']),
      status: serializer.fromJson<String?>(json['status']),
      log: serializer.fromJson<String?>(json['log']),
      filesize: serializer.fromJson<int>(json['filesize']),
      thumb: serializer.fromJson<Uint8List?>(json['thumb']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createAt': serializer.toJson<DateTime>(createAt),
      'updateAt': serializer.toJson<DateTime?>(updateAt),
      'key': serializer.toJson<String?>(key),
      'url': serializer.toJson<String>(url),
      'duration': serializer.toJson<String?>(duration),
      'thumbnail': serializer.toJson<String?>(thumbnail),
      'title': serializer.toJson<String?>(title),
      'status': serializer.toJson<String?>(status),
      'log': serializer.toJson<String?>(log),
      'filesize': serializer.toJson<int>(filesize),
      'thumb': serializer.toJson<Uint8List?>(thumb),
    };
  }

  DownloadTasksModel copyWith(
          {int? id,
          DateTime? createAt,
          Value<DateTime?> updateAt = const Value.absent(),
          Value<String?> key = const Value.absent(),
          String? url,
          Value<String?> duration = const Value.absent(),
          Value<String?> thumbnail = const Value.absent(),
          Value<String?> title = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> log = const Value.absent(),
          int? filesize,
          Value<Uint8List?> thumb = const Value.absent()}) =>
      DownloadTasksModel(
        id: id ?? this.id,
        createAt: createAt ?? this.createAt,
        updateAt: updateAt.present ? updateAt.value : this.updateAt,
        key: key.present ? key.value : this.key,
        url: url ?? this.url,
        duration: duration.present ? duration.value : this.duration,
        thumbnail: thumbnail.present ? thumbnail.value : this.thumbnail,
        title: title.present ? title.value : this.title,
        status: status.present ? status.value : this.status,
        log: log.present ? log.value : this.log,
        filesize: filesize ?? this.filesize,
        thumb: thumb.present ? thumb.value : this.thumb,
      );
  DownloadTasksModel copyWithCompanion(DownloadTasksCompanion data) {
    return DownloadTasksModel(
      id: data.id.present ? data.id.value : this.id,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      updateAt: data.updateAt.present ? data.updateAt.value : this.updateAt,
      key: data.key.present ? data.key.value : this.key,
      url: data.url.present ? data.url.value : this.url,
      duration: data.duration.present ? data.duration.value : this.duration,
      thumbnail: data.thumbnail.present ? data.thumbnail.value : this.thumbnail,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      log: data.log.present ? data.log.value : this.log,
      filesize: data.filesize.present ? data.filesize.value : this.filesize,
      thumb: data.thumb.present ? data.thumb.value : this.thumb,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTasksModel(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('key: $key, ')
          ..write('url: $url, ')
          ..write('duration: $duration, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('log: $log, ')
          ..write('filesize: $filesize, ')
          ..write('thumb: $thumb')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createAt, updateAt, key, url, duration,
      thumbnail, title, status, log, filesize, $driftBlobEquality.hash(thumb));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadTasksModel &&
          other.id == this.id &&
          other.createAt == this.createAt &&
          other.updateAt == this.updateAt &&
          other.key == this.key &&
          other.url == this.url &&
          other.duration == this.duration &&
          other.thumbnail == this.thumbnail &&
          other.title == this.title &&
          other.status == this.status &&
          other.log == this.log &&
          other.filesize == this.filesize &&
          $driftBlobEquality.equals(other.thumb, this.thumb));
}

class DownloadTasksCompanion extends UpdateCompanion<DownloadTasksModel> {
  final Value<int> id;
  final Value<DateTime> createAt;
  final Value<DateTime?> updateAt;
  final Value<String?> key;
  final Value<String> url;
  final Value<String?> duration;
  final Value<String?> thumbnail;
  final Value<String?> title;
  final Value<String?> status;
  final Value<String?> log;
  final Value<int> filesize;
  final Value<Uint8List?> thumb;
  const DownloadTasksCompanion({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.key = const Value.absent(),
    this.url = const Value.absent(),
    this.duration = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.log = const Value.absent(),
    this.filesize = const Value.absent(),
    this.thumb = const Value.absent(),
  });
  DownloadTasksCompanion.insert({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.key = const Value.absent(),
    required String url,
    this.duration = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.log = const Value.absent(),
    this.filesize = const Value.absent(),
    this.thumb = const Value.absent(),
  }) : url = Value(url);
  static Insertable<DownloadTasksModel> custom({
    Expression<int>? id,
    Expression<DateTime>? createAt,
    Expression<DateTime>? updateAt,
    Expression<String>? key,
    Expression<String>? url,
    Expression<String>? duration,
    Expression<String>? thumbnail,
    Expression<String>? title,
    Expression<String>? status,
    Expression<String>? log,
    Expression<int>? filesize,
    Expression<Uint8List>? thumb,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createAt != null) 'create_at': createAt,
      if (updateAt != null) 'update_at': updateAt,
      if (key != null) 'key': key,
      if (url != null) 'url': url,
      if (duration != null) 'duration': duration,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (log != null) 'log': log,
      if (filesize != null) 'filesize': filesize,
      if (thumb != null) 'thumb': thumb,
    });
  }

  DownloadTasksCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createAt,
      Value<DateTime?>? updateAt,
      Value<String?>? key,
      Value<String>? url,
      Value<String?>? duration,
      Value<String?>? thumbnail,
      Value<String?>? title,
      Value<String?>? status,
      Value<String?>? log,
      Value<int>? filesize,
      Value<Uint8List?>? thumb}) {
    return DownloadTasksCompanion(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      key: key ?? this.key,
      url: url ?? this.url,
      duration: duration ?? this.duration,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      status: status ?? this.status,
      log: log ?? this.log,
      filesize: filesize ?? this.filesize,
      thumb: thumb ?? this.thumb,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<DateTime>(updateAt.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (log.present) {
      map['log'] = Variable<String>(log.value);
    }
    if (filesize.present) {
      map['filesize'] = Variable<int>(filesize.value);
    }
    if (thumb.present) {
      map['thumb'] = Variable<Uint8List>(thumb.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTasksCompanion(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('key: $key, ')
          ..write('url: $url, ')
          ..write('duration: $duration, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('log: $log, ')
          ..write('filesize: $filesize, ')
          ..write('thumb: $thumb')
          ..write(')'))
        .toString();
  }
}

class $CookiesTable extends Cookies
    with TableInfo<$CookiesTable, CookiesModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updateAtMeta =
      const VerificationMeta('updateAt');
  @override
  late final GeneratedColumn<DateTime> updateAt = GeneratedColumn<DateTime>(
      'update_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cookiePathMeta =
      const VerificationMeta('cookiePath');
  @override
  late final GeneratedColumn<String> cookiePath = GeneratedColumn<String>(
      'cookie_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiryMeta = const VerificationMeta('expiry');
  @override
  late final GeneratedColumn<int> expiry = GeneratedColumn<int>(
      'expiry', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, createAt, updateAt, name, cookiePath, expiry];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cookies';
  @override
  VerificationContext validateIntegrity(Insertable<CookiesModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    }
    if (data.containsKey('update_at')) {
      context.handle(_updateAtMeta,
          updateAt.isAcceptableOrUnknown(data['update_at']!, _updateAtMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cookie_path')) {
      context.handle(
          _cookiePathMeta,
          cookiePath.isAcceptableOrUnknown(
              data['cookie_path']!, _cookiePathMeta));
    }
    if (data.containsKey('expiry')) {
      context.handle(_expiryMeta,
          expiry.isAcceptableOrUnknown(data['expiry']!, _expiryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {name},
      ];
  @override
  CookiesModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookiesModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
      updateAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_at']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      cookiePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cookie_path']),
      expiry: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expiry'])!,
    );
  }

  @override
  $CookiesTable createAlias(String alias) {
    return $CookiesTable(attachedDatabase, alias);
  }
}

class CookiesModel extends DataClass implements Insertable<CookiesModel> {
  final int id;
  final DateTime createAt;
  final DateTime? updateAt;
  final String name;
  final String? cookiePath;
  final int expiry;
  const CookiesModel(
      {required this.id,
      required this.createAt,
      this.updateAt,
      required this.name,
      this.cookiePath,
      required this.expiry});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['create_at'] = Variable<DateTime>(createAt);
    if (!nullToAbsent || updateAt != null) {
      map['update_at'] = Variable<DateTime>(updateAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || cookiePath != null) {
      map['cookie_path'] = Variable<String>(cookiePath);
    }
    map['expiry'] = Variable<int>(expiry);
    return map;
  }

  CookiesCompanion toCompanion(bool nullToAbsent) {
    return CookiesCompanion(
      id: Value(id),
      createAt: Value(createAt),
      updateAt: updateAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updateAt),
      name: Value(name),
      cookiePath: cookiePath == null && nullToAbsent
          ? const Value.absent()
          : Value(cookiePath),
      expiry: Value(expiry),
    );
  }

  factory CookiesModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookiesModel(
      id: serializer.fromJson<int>(json['id']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
      updateAt: serializer.fromJson<DateTime?>(json['updateAt']),
      name: serializer.fromJson<String>(json['name']),
      cookiePath: serializer.fromJson<String?>(json['cookiePath']),
      expiry: serializer.fromJson<int>(json['expiry']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createAt': serializer.toJson<DateTime>(createAt),
      'updateAt': serializer.toJson<DateTime?>(updateAt),
      'name': serializer.toJson<String>(name),
      'cookiePath': serializer.toJson<String?>(cookiePath),
      'expiry': serializer.toJson<int>(expiry),
    };
  }

  CookiesModel copyWith(
          {int? id,
          DateTime? createAt,
          Value<DateTime?> updateAt = const Value.absent(),
          String? name,
          Value<String?> cookiePath = const Value.absent(),
          int? expiry}) =>
      CookiesModel(
        id: id ?? this.id,
        createAt: createAt ?? this.createAt,
        updateAt: updateAt.present ? updateAt.value : this.updateAt,
        name: name ?? this.name,
        cookiePath: cookiePath.present ? cookiePath.value : this.cookiePath,
        expiry: expiry ?? this.expiry,
      );
  CookiesModel copyWithCompanion(CookiesCompanion data) {
    return CookiesModel(
      id: data.id.present ? data.id.value : this.id,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      updateAt: data.updateAt.present ? data.updateAt.value : this.updateAt,
      name: data.name.present ? data.name.value : this.name,
      cookiePath:
          data.cookiePath.present ? data.cookiePath.value : this.cookiePath,
      expiry: data.expiry.present ? data.expiry.value : this.expiry,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookiesModel(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('name: $name, ')
          ..write('cookiePath: $cookiePath, ')
          ..write('expiry: $expiry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createAt, updateAt, name, cookiePath, expiry);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookiesModel &&
          other.id == this.id &&
          other.createAt == this.createAt &&
          other.updateAt == this.updateAt &&
          other.name == this.name &&
          other.cookiePath == this.cookiePath &&
          other.expiry == this.expiry);
}

class CookiesCompanion extends UpdateCompanion<CookiesModel> {
  final Value<int> id;
  final Value<DateTime> createAt;
  final Value<DateTime?> updateAt;
  final Value<String> name;
  final Value<String?> cookiePath;
  final Value<int> expiry;
  const CookiesCompanion({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    this.name = const Value.absent(),
    this.cookiePath = const Value.absent(),
    this.expiry = const Value.absent(),
  });
  CookiesCompanion.insert({
    this.id = const Value.absent(),
    this.createAt = const Value.absent(),
    this.updateAt = const Value.absent(),
    required String name,
    this.cookiePath = const Value.absent(),
    this.expiry = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CookiesModel> custom({
    Expression<int>? id,
    Expression<DateTime>? createAt,
    Expression<DateTime>? updateAt,
    Expression<String>? name,
    Expression<String>? cookiePath,
    Expression<int>? expiry,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createAt != null) 'create_at': createAt,
      if (updateAt != null) 'update_at': updateAt,
      if (name != null) 'name': name,
      if (cookiePath != null) 'cookie_path': cookiePath,
      if (expiry != null) 'expiry': expiry,
    });
  }

  CookiesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createAt,
      Value<DateTime?>? updateAt,
      Value<String>? name,
      Value<String?>? cookiePath,
      Value<int>? expiry}) {
    return CookiesCompanion(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      name: name ?? this.name,
      cookiePath: cookiePath ?? this.cookiePath,
      expiry: expiry ?? this.expiry,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (updateAt.present) {
      map['update_at'] = Variable<DateTime>(updateAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cookiePath.present) {
      map['cookie_path'] = Variable<String>(cookiePath.value);
    }
    if (expiry.present) {
      map['expiry'] = Variable<int>(expiry.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookiesCompanion(')
          ..write('id: $id, ')
          ..write('createAt: $createAt, ')
          ..write('updateAt: $updateAt, ')
          ..write('name: $name, ')
          ..write('cookiePath: $cookiePath, ')
          ..write('expiry: $expiry')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $DownloadTasksTable downloadTasks = $DownloadTasksTable(this);
  late final $CookiesTable cookies = $CookiesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [settings, downloadTasks, cookies];
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<DateTime> createAt,
  Value<DateTime?> updateAt,
  required String key,
  Value<String?> value,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<DateTime> createAt,
  Value<DateTime?> updateAt,
  Value<String> key,
  Value<String?> value,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updateAt =>
      $composableBuilder(column: $table.updateAt, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    SettingsModel,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (
      SettingsModel,
      BaseReferences<_$AppDatabase, $SettingsTable, SettingsModel>
    ),
    SettingsModel,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<DateTime?> updateAt = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
          }) =>
              SettingsCompanion(
            id: id,
            createAt: createAt,
            updateAt: updateAt,
            key: key,
            value: value,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<DateTime?> updateAt = const Value.absent(),
            required String key,
            Value<String?> value = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            id: id,
            createAt: createAt,
            updateAt: updateAt,
            key: key,
            value: value,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    SettingsModel,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (
      SettingsModel,
      BaseReferences<_$AppDatabase, $SettingsTable, SettingsModel>
    ),
    SettingsModel,
    PrefetchHooks Function()>;
typedef $$DownloadTasksTableCreateCompanionBuilder = DownloadTasksCompanion
    Function({
  Value<int> id,
  Value<DateTime> createAt,
  Value<DateTime?> updateAt,
  Value<String?> key,
  required String url,
  Value<String?> duration,
  Value<String?> thumbnail,
  Value<String?> title,
  Value<String?> status,
  Value<String?> log,
  Value<int> filesize,
  Value<Uint8List?> thumb,
});
typedef $$DownloadTasksTableUpdateCompanionBuilder = DownloadTasksCompanion
    Function({
  Value<int> id,
  Value<DateTime> createAt,
  Value<DateTime?> updateAt,
  Value<String?> key,
  Value<String> url,
  Value<String?> duration,
  Value<String?> thumbnail,
  Value<String?> title,
  Value<String?> status,
  Value<String?> log,
  Value<int> filesize,
  Value<Uint8List?> thumb,
});

class $$DownloadTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnail => $composableBuilder(
      column: $table.thumbnail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get log => $composableBuilder(
      column: $table.log, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get filesize => $composableBuilder(
      column: $table.filesize, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get thumb => $composableBuilder(
      column: $table.thumb, builder: (column) => ColumnFilters(column));
}

class $$DownloadTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnail => $composableBuilder(
      column: $table.thumbnail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get log => $composableBuilder(
      column: $table.log, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get filesize => $composableBuilder(
      column: $table.filesize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get thumb => $composableBuilder(
      column: $table.thumb, builder: (column) => ColumnOrderings(column));
}

class $$DownloadTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updateAt =>
      $composableBuilder(column: $table.updateAt, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get thumbnail =>
      $composableBuilder(column: $table.thumbnail, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get log =>
      $composableBuilder(column: $table.log, builder: (column) => column);

  GeneratedColumn<int> get filesize =>
      $composableBuilder(column: $table.filesize, builder: (column) => column);

  GeneratedColumn<Uint8List> get thumb =>
      $composableBuilder(column: $table.thumb, builder: (column) => column);
}

class $$DownloadTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadTasksTable,
    DownloadTasksModel,
    $$DownloadTasksTableFilterComposer,
    $$DownloadTasksTableOrderingComposer,
    $$DownloadTasksTableAnnotationComposer,
    $$DownloadTasksTableCreateCompanionBuilder,
    $$DownloadTasksTableUpdateCompanionBuilder,
    (
      DownloadTasksModel,
      BaseReferences<_$AppDatabase, $DownloadTasksTable, DownloadTasksModel>
    ),
    DownloadTasksModel,
    PrefetchHooks Function()> {
  $$DownloadTasksTableTableManager(_$AppDatabase db, $DownloadTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<DateTime?> updateAt = const Value.absent(),
            Value<String?> key = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String?> duration = const Value.absent(),
            Value<String?> thumbnail = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> log = const Value.absent(),
            Value<int> filesize = const Value.absent(),
            Value<Uint8List?> thumb = const Value.absent(),
          }) =>
              DownloadTasksCompanion(
            id: id,
            createAt: createAt,
            updateAt: updateAt,
            key: key,
            url: url,
            duration: duration,
            thumbnail: thumbnail,
            title: title,
            status: status,
            log: log,
            filesize: filesize,
            thumb: thumb,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<DateTime?> updateAt = const Value.absent(),
            Value<String?> key = const Value.absent(),
            required String url,
            Value<String?> duration = const Value.absent(),
            Value<String?> thumbnail = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> log = const Value.absent(),
            Value<int> filesize = const Value.absent(),
            Value<Uint8List?> thumb = const Value.absent(),
          }) =>
              DownloadTasksCompanion.insert(
            id: id,
            createAt: createAt,
            updateAt: updateAt,
            key: key,
            url: url,
            duration: duration,
            thumbnail: thumbnail,
            title: title,
            status: status,
            log: log,
            filesize: filesize,
            thumb: thumb,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadTasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadTasksTable,
    DownloadTasksModel,
    $$DownloadTasksTableFilterComposer,
    $$DownloadTasksTableOrderingComposer,
    $$DownloadTasksTableAnnotationComposer,
    $$DownloadTasksTableCreateCompanionBuilder,
    $$DownloadTasksTableUpdateCompanionBuilder,
    (
      DownloadTasksModel,
      BaseReferences<_$AppDatabase, $DownloadTasksTable, DownloadTasksModel>
    ),
    DownloadTasksModel,
    PrefetchHooks Function()>;
typedef $$CookiesTableCreateCompanionBuilder = CookiesCompanion Function({
  Value<int> id,
  Value<DateTime> createAt,
  Value<DateTime?> updateAt,
  required String name,
  Value<String?> cookiePath,
  Value<int> expiry,
});
typedef $$CookiesTableUpdateCompanionBuilder = CookiesCompanion Function({
  Value<int> id,
  Value<DateTime> createAt,
  Value<DateTime?> updateAt,
  Value<String> name,
  Value<String?> cookiePath,
  Value<int> expiry,
});

class $$CookiesTableFilterComposer
    extends Composer<_$AppDatabase, $CookiesTable> {
  $$CookiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cookiePath => $composableBuilder(
      column: $table.cookiePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expiry => $composableBuilder(
      column: $table.expiry, builder: (column) => ColumnFilters(column));
}

class $$CookiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CookiesTable> {
  $$CookiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updateAt => $composableBuilder(
      column: $table.updateAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cookiePath => $composableBuilder(
      column: $table.cookiePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expiry => $composableBuilder(
      column: $table.expiry, builder: (column) => ColumnOrderings(column));
}

class $$CookiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookiesTable> {
  $$CookiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updateAt =>
      $composableBuilder(column: $table.updateAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get cookiePath => $composableBuilder(
      column: $table.cookiePath, builder: (column) => column);

  GeneratedColumn<int> get expiry =>
      $composableBuilder(column: $table.expiry, builder: (column) => column);
}

class $$CookiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CookiesTable,
    CookiesModel,
    $$CookiesTableFilterComposer,
    $$CookiesTableOrderingComposer,
    $$CookiesTableAnnotationComposer,
    $$CookiesTableCreateCompanionBuilder,
    $$CookiesTableUpdateCompanionBuilder,
    (CookiesModel, BaseReferences<_$AppDatabase, $CookiesTable, CookiesModel>),
    CookiesModel,
    PrefetchHooks Function()> {
  $$CookiesTableTableManager(_$AppDatabase db, $CookiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CookiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<DateTime?> updateAt = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> cookiePath = const Value.absent(),
            Value<int> expiry = const Value.absent(),
          }) =>
              CookiesCompanion(
            id: id,
            createAt: createAt,
            updateAt: updateAt,
            name: name,
            cookiePath: cookiePath,
            expiry: expiry,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<DateTime?> updateAt = const Value.absent(),
            required String name,
            Value<String?> cookiePath = const Value.absent(),
            Value<int> expiry = const Value.absent(),
          }) =>
              CookiesCompanion.insert(
            id: id,
            createAt: createAt,
            updateAt: updateAt,
            name: name,
            cookiePath: cookiePath,
            expiry: expiry,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CookiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CookiesTable,
    CookiesModel,
    $$CookiesTableFilterComposer,
    $$CookiesTableOrderingComposer,
    $$CookiesTableAnnotationComposer,
    $$CookiesTableCreateCompanionBuilder,
    $$CookiesTableUpdateCompanionBuilder,
    (CookiesModel, BaseReferences<_$AppDatabase, $CookiesTable, CookiesModel>),
    CookiesModel,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$DownloadTasksTableTableManager get downloadTasks =>
      $$DownloadTasksTableTableManager(_db, _db.downloadTasks);
  $$CookiesTableTableManager get cookies =>
      $$CookiesTableTableManager(_db, _db.cookies);
}
