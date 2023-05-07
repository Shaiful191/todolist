import 'package:flutter/material.dart';

class SingleTodo extends StatelessWidget {
  const SingleTodo({
    Key? key,
    required this.todo,
    required this.id,
    required this.deletefunction,
    required this.editfunction,
  }) : super(key: key);

  final String todo;
  final String id;
  final Function deletefunction;
  final Function editfunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                todo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  editfunction(id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {
                  deletefunction(id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
