import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'single_todo.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final _textField = TextEditingController();
  final _textUpdate = TextEditingController();

  //Step-2:Adding Documents
  Future<void> _addtodo() async {
    if (_textField.text.length <= 0) return;

    CollectionReference user = FirebaseFirestore.instance.collection('todo');
    // final collection=FirebaseFirestore.instance.collection('todo');
    await user
        .add({
          "title": _textField.text,
        })

        //nicer ai 2 line na dile o hoy dele valo.
        .then((value) => Fluttertoast.showToast(msg: 'User Added'))
        .catchError((error) => Fluttertoast.showToast(msg: "Failed to add user: $error"));

    _textField.text = '';
    Navigator.of(context).pop();
  } //step-2 end;

  //Step-3: delete a document
  Future<void> deleteTodo(String id) async {
    try {
      final user = FirebaseFirestore.instance.collection('todo').doc(id);
      await user
          .delete()
          //nicer ai 2 line na dile o hoy dele valo.
          .then((value) => Fluttertoast.showToast(msg: 'User Deleted'))
          .catchError((error) => Fluttertoast.showToast(msg: "Failed to delete user: $error"));
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }
  //step-3 end; //Amra caile pura docuemnt delete na kore akta specific properties delete korte pare oi document theke saita aikhane add kori nai pore dakhbo firestore document a ase.

  //Update:
  Future<void> _updateTodo(String id) async {
    String updateData = _textUpdate.text;
    try {
      DocumentReference documentReference = FirebaseFirestore.instance.collection('todo').doc(id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.get(documentReference);
        transaction.update(documentReference, {
          'title': updateData,
        });
      });
      Navigator.of(context).pop();
      _textUpdate.text = '';
    } catch (e) {}
  }

  Future<void> editButton(String id) async {
    final user = FirebaseFirestore.instance.collection('todo').doc(id);
    await user.get().then((value) {
      //  Map<String, dynamic> data = value.data()! as Map<String, dynamic>;
      _textUpdate.text = value.data()!['title'];
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Update Todo'),
              content: TextField(
                controller: _textUpdate,
                decoration: InputDecoration(
                  hintText: "Update a Todo",
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cencel')),
                ElevatedButton(
                    onPressed: () {
                      _updateTodo(id);
                    },
                    child: Text('Update')),
              ],
            ));
  } //end update

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
      ),
      body: dataRead(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Add Todo'),
                    content: TextField(
                      controller: _textField,
                      decoration: InputDecoration(
                        hintText: "Add a Todo",
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cencel')),
                      ElevatedButton(
                          onPressed: () {
                            _addtodo();
                          },
                          child: Text('Add')),
                    ],
                  ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //step-1:Read Data(Realtime changes)
  StreamBuilder<QuerySnapshot<Object>> dataRead() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('todo').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('No Data Found!'),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

            return SingleTodo(
              todo: data['title'],
              id: document.id,
              deletefunction: deleteTodo,
              editfunction: editButton,
            );
          }).toList(),
        );
      },
    );
  } //step-1 end;

}
