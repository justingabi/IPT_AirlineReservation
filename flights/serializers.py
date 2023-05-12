from rest_framework import serializers
from .models import Flight, Booking

class FlightSerializer(serializers.ModelSerializer):
    class Meta:
        model = Flight
        fields = ['flight_number', 'origin', 'destination', 'departure_time', 'arrival_time', 'price']

class BookingSerializer(serializers.ModelSerializer):
    flight = FlightSerializer(read_only=True)
    class Meta:
        model = Booking
        fields = ['user', 'flight', 'date_of_booking']

