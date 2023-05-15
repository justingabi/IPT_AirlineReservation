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
    futureBookings = fetchBookings(context);
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
                  final booking = snapshot.data![index];
                  final flight = booking['flight'];

                  return Dismissible(
                    key: Key(booking['id'].toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      deleteBooking(booking['id']);
                    },
                    child: ListTile(
                      title: Text(flight['flight_number']),
                      subtitle: Text(
                        'From ${flight['origin']} to ${flight['destination']}',
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
