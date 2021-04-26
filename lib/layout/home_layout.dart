import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'file:///D:/new/NanodegreeProjects/flutter_projects/todo_app/lib/shared/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';


class HomeLayout extends StatelessWidget
{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    print('create');
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatebase(),
      child: BlocConsumer<AppCubit,AppStates>(
        builder: (context,state) {
        AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.appBarTitles[cubit.selectedIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState.validate()){
                    cubit.insertToDatabase(title: titleController.text, date: dateController.text, time: timeController.text)
                        .then((value) {
                      Navigator.of(context).pop();
                        cubit.changeBottomSheetShown(false);
                        });
                  }
                } else {
                  scaffoldKey.currentState.showBottomSheet((context) {
                    return Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (String value){
                                if(value.isEmpty){
                                  return 'title must not be empty';
                                }
                                return null;
                              },
                              label: 'Title',
                              prefix: Icons.title,
                            ),
                            SizedBox(height: 15,),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTab: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value.format(context).toString();
                                });
                              },
                              validate: (String value){
                                if(value.isEmpty){
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              label: 'Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            SizedBox(height: 15,),
                            defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTab: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2030-01-01'),
                                ).then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value);
                                });
                              },
                              validate: (String value){
                                if(value.isEmpty){
                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              label: 'Date',
                              prefix: Icons.watch_later_outlined,
                            ),
                          ],
                        ),
                      ),
                    );
                  },elevation: 20).closed.then((value) {
                    cubit.changeBottomSheetShown(false);
                  });
                  cubit.changeBottomSheetShown(true);
                }
              },
              child: Icon(
                cubit.isBottomSheetShown ? Icons.add : Icons.edit,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).selectedIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: true,
              builder:(context) => cubit.widgets[cubit.selectedIndex],
              fallback: (context) => Center(child: CircularProgressIndicator(),),
            ),
          );
        },
        listener: (context,state){},
      ),
    );
  }
}

