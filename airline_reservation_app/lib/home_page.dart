import 'package:flutter/material.dart';
import 'api.dart';
import 'bookings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> futureFlights;

  @override
  void initState() {
    super.initState();
    futureFlights = fetchFlights();
  }

  void _showFlightDetails(BuildContext context, Map<String, dynamic> flight) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Flight Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                FlightDetailRow(
                  label: 'Flight Number',
                  value: flight['flight_number'],
                ),
                SizedBox(height: 8.0),
                FlightDetailRow(
                  label: 'Origin',
                  value: flight['origin'],
                ),
                SizedBox(height: 8.0),
                FlightDetailRow(
                  label: 'Destination',
                  value: flight['destination'],
                ),
                SizedBox(height: 8.0),
                FlightDetailRow(
                  label: 'Departure Date',
                  value: flight['departure_date'] ?? 'N/A',
                ),
                SizedBox(height: 8.0),
                FlightDetailRow(
                  label: 'Departure Time',
                  value: flight['departure_time'] ?? 'N/A',
                ),
                SizedBox(height: 8.0),
                FlightDetailRow(
                  label: 'Arrival Date',
                  value: flight['arrival_date'] ?? 'N/A',
                ),
                SizedBox(height: 8.0),
                FlightDetailRow(
                  label: 'Arrival Time',
                  value: flight['arrival_time'] ?? 'N/A',
                ),
                SizedBox(height: 8.0),
                FlightDetailRow(
                  label: 'Price',
                  value: '\$${flight['price'] ?? 'N/A'}',
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Explore Flights',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: futureFlights,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _showFlightDetails(context, snapshot.data![index]);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2.0,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Flight ${snapshot.data![index]['flight_number']}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'From ${snapshot.data![index]['origin']} to ${snapshot.data![index]['destination']}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      bookFlight(snapshot.data![index]['id']);
                                    },
                                    child: Text('Book'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingsPage()),
          );
        },
        tooltip: 'My Bookings',
        child: Icon(Icons.list),
      ),
    );
  }
}

class FlightDetailRow extends StatelessWidget {
  final String label;
  final String value;

  FlightDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          flex: 3,
          child: Text(value),
        ),
      ],
    );
  }
}
