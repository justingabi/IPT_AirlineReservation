// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchFlights() async {
  final response =
      await http.get(Uri.parse('http://localhost:8000/api/flights/'));

  if (response.statusCode == 200) {
    final List<dynamic> flights = jsonDecode(response.body);
    return flights.map((flight) {
      final Map<String, dynamic> flightDetails = flight;
      flightDetails['departure_date'] =
          flight['departure_time'].toString().split('T')[0];
      flightDetails['departure_time'] =
          flight['departure_time'].toString().split('T')[1];
      flightDetails['arrival_date'] =
          flight['arrival_time'].toString().split('T')[0];
      flightDetails['arrival_time'] =
          flight['arrival_time'].toString().split('T')[1];
      flightDetails['price'] = flight['price'];
      return flightDetails;
    }).toList();
  } else {
    throw Exception('Failed to load flights');
  }
}

Future<void> bookFlight(int flightId) async {
  print('Booking flight with ID: $flightId');
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/bookings/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'flight': flightId,
    }),
  );

  print('Response status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 201) {
    throw Exception('Failed to book flight');
  }
}

Future<List<dynamic>> fetchBookings() async {
  final response =
      await http.get(Uri.parse('http://localhost:8000/api/bookings/'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Failed to load bookings with status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load bookings');
  }
}

Future<String> register(String username, String password, String email) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/auth/register/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'email': email,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 201) {
    return jsonDecode(response.body)['token'];
  } else {
    throw Exception('Failed to register.');
  }
}

Future<String> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/auth/login/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['token'];
  } else {
    throw Exception('Failed to login.');
  }
}

Future<Map<String, dynamic>> fetchUserData(String token) async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/auth/user/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load user data.');
  }
}

Future<String?> fetchUsername(String? token) async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/auth/user/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );

  print('Token: $token');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['username'];
  } else {
    throw Exception('Failed to fetch username');
  }
}
