import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/ui/screens/todos_ui_viewmodel.dart';


class TodosScreenView extends StatelessWidget {
  const TodosScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TodosScreenViewModel>.reactive(
      viewModelBuilder: () => TodosScreenViewModel(),
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(title: const Text('My Todos')),
        body: StickyGroupedListView<Todo, DateTime>(
          elements: model.todos,
          order: StickyGroupedListOrder.ASC,
          groupBy: (Todo element) => DateTime(
              DateTime.parse(element.createdAt).year ?? DateTime.now().year,
            DateTime.parse(element.createdAt).month ?? DateTime.now().month,
              DateTime.parse(element.createdAt).day ?? DateTime.now().day,
          ),
          groupComparator: (DateTime value1, DateTime value2) =>
              value2.compareTo(value1),
          itemComparator: (Todo element1, Todo element2) =>
              DateTime.parse(element1.createdAt).compareTo(DateTime.parse(element2.createdAt)),
          floatingHeader: true,
          groupSeparatorBuilder: _getGroupSeparator,
          itemBuilder: (BuildContext ctx, Todo todo,) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: SizedBox(
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      todo.completed ? Icons.task_alt : Icons.circle_outlined,
                    ),
                    onPressed: () => model.toggleStatus(todo.id),
                  ),
                  title: TextField(
                    textInputAction: TextInputAction.done,
                    controller: TextEditingController(text: todo.content),
                    decoration: null,
                    focusNode: model.getFocusNode(todo.id),
                    maxLines: null,
                    onChanged: (text) {
                      model.updateTodoContent(todo.id, text);
                      model.addDate(todo.id);
                    },
                    style: TextStyle(
                      fontSize: 20,
                      decoration:
                      todo.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.horizontal_rule),
                    onPressed: () => model.removeTodo(todo.id),
                  ),
                ),
              ),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: model.newTodo,
        child: const Icon(Icons.add),
      ),
      ),


    );
  }

  Widget _getGroupSeparator(Todo element) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(
              color: Colors.blue[300]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${DateTime.parse(element.createdAt).day}-${DateTime.parse(element.createdAt).month}-${DateTime.parse(element.createdAt).year}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

}
