from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import FlightViewSet, BookingViewSet

router = DefaultRouter()
router.register('flights', FlightViewSet)
router.register('bookings', BookingViewSet)

urlpatterns = [
    path('', include(router.urls)),
]