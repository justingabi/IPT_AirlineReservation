import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api.dart';
import 'auth_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String token = Provider.of<AuthProvider>(context).token!;
    final String username = Provider.of<AuthProvider>(context).username ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(token),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final Map<String, dynamic> userData = snapshot.data ?? {};

            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Username: $username'),
                  Text('Email: ${userData['email']}'),
                  // Display other user data here...
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
