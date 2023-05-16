from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from rest_framework.permissions import IsAuthenticated
from .models import Flight, Booking
from .serializers import FlightSerializer, BookingSerializer

class FlightViewSet(viewsets.ModelViewSet):
    queryset = Flight.objects.all()
    serializer_class = FlightSerializer

class BookingViewSet(viewsets.ModelViewSet):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    # permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

@api_view(['GET'])
@csrf_exempt
def get_flights(request):
    flights = Flight.objects.all()
    serializer = FlightSerializer(flights, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@csrf_exempt
def getBookedFlights(request):
    booked_flights = Booking.objects.all()
    serializer = BookingSerializer(booked_flights, many=True)
    return Response(serializer.data)
