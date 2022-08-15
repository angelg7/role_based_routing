import 'package:flutter/material.dart';
import 'package:role_based_routing/screen_one.dart';
import 'package:role_based_routing/screen_two.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role based routing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Role based routing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                authenticateRoute(
                    context: context, role: 'super user', route: ScreenOne());
              },
              child: const Text('Require admin role'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ScreenTwo();
                  }),
                );
              },
              child: const Text('Don\'t require role'),
            ),
          ],
        ),
      ),
    );
  }
}

void authenticateRoute(
    {required BuildContext context,
    required String role,
    required Widget route}) {
  var userRole = AuthenticationFake().getUserRole();
  if (userRole == role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const ScreenOne();
      }),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('You don\'t have access'),
    ));
  }
}

class AuthenticationFake {
  String getUserRole() {
    return 'admin';
  }
}
