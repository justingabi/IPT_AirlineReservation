import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api.dart';
import 'auth_provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  final String username = usernameController.text;
                  final String password = passwordController.text;

                  try {
                    final String token = await login(username, password);

                    // Save the token securely.
                    Provider.of<AuthProvider>(context, listen: false)
                        .setToken(token);
                    Provider.of<AuthProvider>(context, listen: false)
                        .setUsername(username);

                    // Navigate to the main page.
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/main', (route) => false);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Login failed'),
                          content: Text('Would you like to register?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Register'),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
