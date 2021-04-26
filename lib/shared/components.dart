import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTab,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
  onTap: onTab,
  enabled: isClickable,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? Icon(suffix) : null,
    border: OutlineInputBorder(),
  ),
);



Widget buildTaskItem(Map<String,dynamic> model,BuildContext context) => Dismissible(
  key: Key(model['id'].toString()),
  child: ListTile(
    leading: CircleAvatar(
      radius: 35,
      child: Text(
        '${model['time']}',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    ),
    title: Text(
      '${model['title']}',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Text(
        '${model['date']}'
    ),
     trailing: Row(
       mainAxisSize: MainAxisSize.min,
         children: [
           IconButton(icon: Icon(Icons.check_box,color: Colors.green,), onPressed: (){
             AppCubit.get(context).updateData(status: 'done', id: model['id']);
           },),
           SizedBox(width: 15,),
           IconButton(icon: Icon(Icons.archive,color: Colors.black45,),onPressed: (){
             AppCubit.get(context).updateData(status: 'archive', id: model['id']);
           },),
         ],
       ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget tasksBuilder({
  @required List<Map<String,dynamic>> tasks,
}) => ConditionalBuilder(
  builder: (context) => ListView.separated(
    separatorBuilder: (context,index) => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    ),
    itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
    itemCount: tasks.length,
  ),
  condition: tasks.length > 0,
  fallback: (context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.menu,size: 80,color: Colors.grey,),
      Text('No tasks yet, Please add some tasks',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ],
  ),
);