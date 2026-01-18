// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_local_data_source.dart';

// ignore_for_file: type=lint
class $StepsTable extends Steps with TableInfo<$StepsTable, Step> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<int> goal = GeneratedColumn<int>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dayNameMeta = const VerificationMeta('dayName');
  @override
  late final GeneratedColumn<String> dayName = GeneratedColumn<String>(
    'day_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, steps, goal, dayName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'steps';
  @override
  VerificationContext validateIntegrity(Insertable<Step> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(_stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(_goalMeta, goal.isAcceptableOrUnknown(data['goal']!, _goalMeta));
    }
    if (data.containsKey('day_name')) {
      context.handle(_dayNameMeta, dayName.isAcceptableOrUnknown(data['day_name']!, _dayNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Step map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Step(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      steps: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}steps'])!,
      goal: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}goal'])!,
      dayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}day_name']),
    );
  }

  @override
  $StepsTable createAlias(String alias) {
    return $StepsTable(attachedDatabase, alias);
  }
}

class Step extends DataClass implements Insertable<Step> {
  final int id;
  final DateTime date;
  final int steps;
  final int goal;
  final String? dayName;
  const Step({required this.id, required this.date, required this.steps, required this.goal, this.dayName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['steps'] = Variable<int>(steps);
    map['goal'] = Variable<int>(goal);
    if (!nullToAbsent || dayName != null) {
      map['day_name'] = Variable<String>(dayName);
    }
    return map;
  }

  StepsCompanion toCompanion(bool nullToAbsent) {
    return StepsCompanion(
      id: Value(id),
      date: Value(date),
      steps: Value(steps),
      goal: Value(goal),
      dayName: dayName == null && nullToAbsent ? const Value.absent() : Value(dayName),
    );
  }

  factory Step.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Step(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      steps: serializer.fromJson<int>(json['steps']),
      goal: serializer.fromJson<int>(json['goal']),
      dayName: serializer.fromJson<String?>(json['dayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'steps': serializer.toJson<int>(steps),
      'goal': serializer.toJson<int>(goal),
      'dayName': serializer.toJson<String?>(dayName),
    };
  }

  Step copyWith({int? id, DateTime? date, int? steps, int? goal, Value<String?> dayName = const Value.absent()}) =>
      Step(
        id: id ?? this.id,
        date: date ?? this.date,
        steps: steps ?? this.steps,
        goal: goal ?? this.goal,
        dayName: dayName.present ? dayName.value : this.dayName,
      );
  Step copyWithCompanion(StepsCompanion data) {
    return Step(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      steps: data.steps.present ? data.steps.value : this.steps,
      goal: data.goal.present ? data.goal.value : this.goal,
      dayName: data.dayName.present ? data.dayName.value : this.dayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Step(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('goal: $goal, ')
          ..write('dayName: $dayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, steps, goal, dayName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Step &&
          other.id == this.id &&
          other.date == this.date &&
          other.steps == this.steps &&
          other.goal == this.goal &&
          other.dayName == this.dayName);
}

class StepsCompanion extends UpdateCompanion<Step> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> steps;
  final Value<int> goal;
  final Value<String?> dayName;
  const StepsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.steps = const Value.absent(),
    this.goal = const Value.absent(),
    this.dayName = const Value.absent(),
  });
  StepsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int steps,
    this.goal = const Value.absent(),
    this.dayName = const Value.absent(),
  }) : date = Value(date),
       steps = Value(steps);
  static Insertable<Step> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? steps,
    Expression<int>? goal,
    Expression<String>? dayName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (steps != null) 'steps': steps,
      if (goal != null) 'goal': goal,
      if (dayName != null) 'day_name': dayName,
    });
  }

  StepsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? steps,
    Value<int>? goal,
    Value<String?>? dayName,
  }) {
    return StepsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      goal: goal ?? this.goal,
      dayName: dayName ?? this.dayName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(goal.value);
    }
    if (dayName.present) {
      map['day_name'] = Variable<String>(dayName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StepsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('steps: $steps, ')
          ..write('goal: $goal, ')
          ..write('dayName: $dayName')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StepsTable steps = $StepsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [steps];
}

typedef $$StepsTableCreateCompanionBuilder =
    StepsCompanion Function({
      Value<int> id,
      required DateTime date,
      required int steps,
      Value<int> goal,
      Value<String?> dayName,
    });
typedef $$StepsTableUpdateCompanionBuilder =
    StepsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> steps,
      Value<int> goal,
      Value<String?> dayName,
    });

class $$StepsTableFilterComposer extends Composer<_$AppDatabase, $StepsTable> {
  $$StepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get goal => $composableBuilder(column: $table.goal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayName =>
      $composableBuilder(column: $table.dayName, builder: (column) => ColumnFilters(column));
}

class $$StepsTableOrderingComposer extends Composer<_$AppDatabase, $StepsTable> {
  $$StepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayName =>
      $composableBuilder(column: $table.dayName, builder: (column) => ColumnOrderings(column));
}

class $$StepsTableAnnotationComposer extends Composer<_$AppDatabase, $StepsTable> {
  $$StepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date => $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get steps => $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get goal => $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get dayName => $composableBuilder(column: $table.dayName, builder: (column) => column);
}

class $$StepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StepsTable,
          Step,
          $$StepsTableFilterComposer,
          $$StepsTableOrderingComposer,
          $$StepsTableAnnotationComposer,
          $$StepsTableCreateCompanionBuilder,
          $$StepsTableUpdateCompanionBuilder,
          (Step, BaseReferences<_$AppDatabase, $StepsTable, Step>),
          Step,
          PrefetchHooks Function()
        > {
  $$StepsTableTableManager(_$AppDatabase db, $StepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<int> goal = const Value.absent(),
                Value<String?> dayName = const Value.absent(),
              }) => StepsCompanion(id: id, date: date, steps: steps, goal: goal, dayName: dayName),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int steps,
                Value<int> goal = const Value.absent(),
                Value<String?> dayName = const Value.absent(),
              }) => StepsCompanion.insert(id: id, date: date, steps: steps, goal: goal, dayName: dayName),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StepsTable,
      Step,
      $$StepsTableFilterComposer,
      $$StepsTableOrderingComposer,
      $$StepsTableAnnotationComposer,
      $$StepsTableCreateCompanionBuilder,
      $$StepsTableUpdateCompanionBuilder,
      (Step, BaseReferences<_$AppDatabase, $StepsTable, Step>),
      Step,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StepsTableTableManager get steps => $$StepsTableTableManager(_db, _db.steps);
}
