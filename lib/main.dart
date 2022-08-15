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
                authorizeRoute(
                    context: context, role: 'admin', route: ScreenOne());
              },
              child: const Text('Require admin role'),
            ),
            authorizeWidget(
              context: context,
              role: 'admin',
              widget: ElevatedButton(
                onPressed: () {
                  authorizeRoute(
                      context: context, role: 'admin', route: ScreenOne());
                },
                child: const Text('Require admin role'),
              ),
            ),
            RoleBasedWidget(role: 'admin', child: Text('You are an admin!')),
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

void authorizeRoute(
    {required BuildContext context,
    required String role,
    required Widget route}) {
  var userRole = AuthenticationFake().getUserRole();
  if (userRole == role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return route;
      }),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('You don\'t have access'),
    ));
  }
}

Widget authorizeWidget(
    {required BuildContext context,
    required String role,
    required Widget widget}) {
  var userRole = AuthenticationFake().getUserRole();
  if (userRole == role) {
    return widget;
  } else {
    return const SizedBox();
  }
}

class RoleBasedWidget extends StatelessWidget {
  const RoleBasedWidget({Key? key, required this.role, required this.child})
      : super(key: key);

  final String role;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var userRole = AuthenticationFake().getUserRole();
    if (userRole == role) {
      return child;
    } else {
      return const SizedBox();
    }
  }
}

class AuthenticationFake {
  String getUserRole() {
    return 'admin';
  }
}
