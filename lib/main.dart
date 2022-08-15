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

/// If the user has the required role, navigate to the route. Otherwise, show a snackbar
///
/// Args:
///   context (BuildContext): The context of the current screen.
///   role (String): The role that the user must have to access the route.
///   route (Widget): The route you want to navigate to.
///
/// Returns:
///   A function that takes a context, a role, and a route.
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

/// If the user role is the same as the role passed in, then return the widget passed in, otherwise
/// return an empty box
///
/// Args:
///   context (BuildContext): The context of the widget.
///   role (String): The role that the user must have to see the widget.
///   widget (Widget): The widget to be displayed if the user has the correct role.
///
/// Returns:
///   A widget.
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

/// If the user's role matches the role passed in, the child widget is displayed. Otherwise, nothing is
/// displayed
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
