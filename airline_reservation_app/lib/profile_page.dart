import 'package:flutter/material.dart';
import 'api.dart';

class ProfilePage extends StatelessWidget {
  final String token;

  ProfilePage(this.token);

  @override
  Widget build(BuildContext context) {
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
            // Ensure the data is not null
            final Map<String, dynamic> userData = snapshot.data ?? {};
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Username: ${userData['username']}'),
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
