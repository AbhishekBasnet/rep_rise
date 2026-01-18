import 'package:drift/drift.dart';
import 'package:rep_rise/data/model/steps/step_model.dart';
part 'step_local_data_source.g.dart';

class Steps extends Table {
  int get schemaVersion => 2;
  // changing mode/entity will conflict with existing db so update accordingly

  DateTimeColumn get date => dateTime()();

  IntColumn get steps => integer()();

  IntColumn get goal => integer().withDefault(const Constant(0))();

  TextColumn get dayName => text().nullable()();

  // Composite Key (Optional):  to ensure only one entry per date exists
  @override
  Set<Column> get primaryKey => {date};
  @override
  List<Set<Column>> get uniqueKeys => [
    {date},
  ];



}

// Defining the Database
@DriftDatabase(tables: [Steps])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

abstract class StepLocalDataSource {
  Future<List<Step>> getCachedSteps();
  Future<void> cacheSteps(List<StepModel> steps);
  Future<void> deleteAllSteps();
}

class StepLocalDataSourceImpl implements StepLocalDataSource {
  final AppDatabase db;

  StepLocalDataSourceImpl({required this.db});

  @override
  Future<List<Step>> getCachedSteps() {
    return db.select(db.steps).get();
  }

  @override
  Future<void> cacheSteps(List<StepModel> steps) async {
    await db.batch((batch) {
      batch.insertAll(
        db.steps,
        steps
            .map(
              (s) =>
                  StepsCompanion.insert(date: s.date, steps: s.steps, goal: Value(s.goal), dayName: Value(s.dayName)),
            )
            .toList(),
        mode: InsertMode.insertOrReplace,
      );
    });

  }

  @override
  Future<void> deleteAllSteps() {
    return db.delete(db.steps).go();
  }
}
