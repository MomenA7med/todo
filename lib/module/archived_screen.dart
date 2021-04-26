import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(builder: (context,state){
      var tasks = AppCubit.get(context).archivedTasks;
      print('tasks : $tasks');
      return tasksBuilder(
        tasks: tasks,
      );
      },
      listener: (context,state){},
    );
  }
}