
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/module/archived_screen.dart';
import 'package:todo_app/module/done_screen.dart';
import 'package:todo_app/module/task_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database database;

  bool isBottomSheetShown = false;

  List<Map<String , dynamic>> tasks = [];
  List<Map<String , dynamic>> doneTasks = [];
  List<Map<String , dynamic>> archivedTasks = [];


  int selectedIndex = 0;

  List<String> appBarTitles = [
    'Tasks',
    'Done',
    'Archived'
  ];
  List<Widget> widgets = [
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  void changeIndex(int index){
    selectedIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Future insertToDatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    return await database.transaction((txn)  {
      txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
            print('$value inserted successfully');
            emit(AppInsertDatabseState());
            getDataFromDatabase(database);
          });
      return null;
    });
  }

  void getDataFromDatabase(Database database)
  {
    tasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new'){
          tasks.add(element);
        }else if(element['status'] == 'done'){
          doneTasks.add(element);
        }else{
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabseState());
    }).catchError((onError) {
      print(onError);
    });
  }

  void changeBottomSheetShown(bool isBottomSheetShownn){
    isBottomSheetShown = isBottomSheetShownn;
    emit(AppChangeBottomSheetShownState());
  }

  void createDatebase()  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version) {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((onError){
          });
        },
        onOpen: (database){
          getDataFromDatabase(database);
        }
    ).then((value) {
      database = value;
      emit(AppCreateDatabseState());
    });
  }

  void updateData({
  @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateDatabseState());
      getDataFromDatabase(database);
    });
  }

  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?' , [id]).then((value) {
      emit(AppDeleteDatabseState());
      getDataFromDatabase(database);
    });
  }
}