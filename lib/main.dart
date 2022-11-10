import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_firestore/update_data.dart';
import 'package:test_firestore/write_data.dart';

const bool kIsWeb = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase emulator host code
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          /* Firebase Options */
          ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter firestore CRUD Teset'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('tempUsers')
      .snapshots()
      .map((snapshots) =>
          snapshots.docs.map((doc) => User.fromJson(doc.data())).toList());

  Future<User?> readUser() async {
    // Get single document by ID
    final docUser =
        FirebaseFirestore.instance.collection('tempUsers').doc('TempID');
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!);
    }
  }

  Widget buildUser(User user) => ListTile(
        leading: GestureDetector(
          onTap: () {
            print(user.id);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UpdateUser(user: user);
            }));
          },
          child: CircleAvatar(child: Text('${user.age}')),
        ),
        title: Text(user.name),
        subtitle: Text(user.birthday.toIso8601String()),
        trailing: IconButton(
          onPressed: () {
            final docUser =
                FirebaseFirestore.instance.collection('tempUsers').doc(user.id);
            docUser.delete();
            setState(() {});
          },
          icon: const Icon(Icons.delete),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return WriteUser();
            }),
          );
        },
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}
