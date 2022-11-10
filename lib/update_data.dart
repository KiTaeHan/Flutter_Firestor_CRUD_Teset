import 'package:flutter/material.dart';
import 'package:test_firestore/write_data.dart';
import 'package:date_field/date_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUser extends StatelessWidget {
  User user;
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  String? docID;
  DateTime? birthday;

  UpdateUser({required this.user, super.key}) {
    controllerName.text = user.name;
    controllerAge.text = user.age.toString();
    docID = user.id;
    birthday = user.birthday;
  }

  InputDecoration decoration(String value) {
    return InputDecoration(
      labelText: value,
      hintText: 'Enter your $value',
      labelStyle: TextStyle(color: Colors.redAccent),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 1, color: Colors.redAccent),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 1, color: Colors.redAccent),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  Future updateUser(User user) async {
    if (docID == null) return null;

    final docUser =
        FirebaseFirestore.instance.collection('tempUsers').doc(docID);

    final json = user.toJson();
    print(json);
    // Create document and write data to Firebase
    await docUser.update(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: controllerName,
            decoration: decoration('Name'),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: controllerAge,
            decoration: decoration('Age'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 24,
          ),
          DateTimeFormField(
            decoration: decoration('Birthday'),
            initialValue: birthday,
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            onDateSelected: (DateTime value) {
              print(value);
              birthday = value;
            },
          ),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            child: const Text('Update'),
            onPressed: () {
              final user = User(
                name: controllerName.text,
                age: int.parse(controllerAge.text),
                birthday: birthday!,
              );
              updateUser(user);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
