import 'package:flutter/material.dart';
import 'api.dart';

class BookingsPage extends StatefulWidget {
  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late Future<List<dynamic>> futureBookings;

  @override
  void initState() {
    super.initState();
    futureBookings = fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: futureBookings,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text(snapshot.data![index]['flight']['flight_number']),
                    subtitle: Text(
                        'From ${snapshot.data![index]['flight']['origin']} to ${snapshot.data![index]['flight']['destination']}'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
