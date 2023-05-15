// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

Future<List<dynamic>> fetchFlights(String token) async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/flights/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

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

// Future<String> login(String username, String password) async {
//   final url = Uri.parse('http://localhost:8000/api/login/');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({'username': username, 'password': password});

//   final response = await http.post(url, headers: headers, body: body);

//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = jsonDecode(response.body);
//     return data['token'];
//   } else {
//     throw Exception('Failed to login.');
//   }
// }

Future<String> bookFlight(int flightId, String token) async {
  final url = Uri.parse('http://localhost:8000/api/bookings/');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  final body = jsonEncode({'flight': flightId});

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    return 'Booking successful!';
  } else if (response.statusCode == 400) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String message = responseData['message'];
    throw Exception('Failed to book flight: $message');
  } else {
    throw Exception('Failed to book flight.');
  }
}

Future<List<dynamic>> fetchBookings(BuildContext context) async {
  final token = Provider.of<AuthProvider>(context, listen: false).token;
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/bookings/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
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

Future<void> deleteBooking(int bookingId) async {
  final url = Uri.parse('http://localhost:8000/api/bookings/$bookingId/');

  try {
    final response = await http.delete(url);
    if (response.statusCode == 204) {
      // Booking deleted successfully
      print('Booking deleted');
    } else {
      // Failed to delete booking
      throw Exception('Failed to delete booking');
    }
  } catch (error) {
    // Handle any errors that occurred during the request
    throw Exception('Failed to delete booking: $error');
  }
}
