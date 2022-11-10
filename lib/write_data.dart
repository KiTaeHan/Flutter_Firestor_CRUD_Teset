import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';

class User {
  String? id;
  final String name;
  final int age;
  final DateTime birthday;

  User(
      {this.id, required this.name, required this.age, required this.birthday});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthday': birthday,
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      birthday: (json['birthday'] as Timestamp).toDate());
}

class WriteUser extends StatefulWidget {
  const WriteUser({super.key});

  @override
  State<WriteUser> createState() => _WriteUserState();
}

class _WriteUserState extends State<WriteUser> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  DateTime? birthday;

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
            child: const Text('Create'),
            onPressed: () {
              final user = User(
                name: controllerName.text,
                age: int.parse(controllerAge.text),
                birthday: birthday!,
              );
              createUser(user);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

/*
  Future createUser({required String name}) async {
    // Reference to document

    // Manually document id
    final m_docUser =
        FirebaseFirestore.instance.collection('tempUsers').doc('my-id');
    final json = {
      'name': name,
      'ape': 21,
      'birthday': DateTime(2000, 1, 1),
    };
    // Create document and write data to Firebase
    await m_docUser.set(json);
  }
*/

  Future createUser(User user) async {
    // Auto document id
    final docUser = FirebaseFirestore.instance.collection('tempUsers').doc();
    user.id = docUser.id;

    final json = user.toJson();
    print(json);
    // Create document and write data to Firebase
    await docUser.set(json);
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
}
