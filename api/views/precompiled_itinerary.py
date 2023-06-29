from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, action
from rest_framework import views, viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
import json

from django.http import JsonResponse

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes
from ..algorithm import generator as gen
from ..models import *


class PrecompiledItineraryViewSet(viewsets.ModelViewSet):
    queryset = PrecompiledItinerary.objects.all().order_by('itinerary_id')
    serializer_class = PrecompiledItinerarySerializer
    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticatedOrReadOnly]

    # serializer_class = ItinerarySerializer

    # serializer_class = PoiSerializer(many=True)
