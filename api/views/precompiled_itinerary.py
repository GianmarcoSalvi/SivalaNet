from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, action
from rest_framework import views, viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
import json

from django.http import JsonResponse

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view, inline_serializer
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
    
    @extend_schema(
            request=inline_serializer(
            name="InlineFormSerializer",
            fields={
                "description": serializers.CharField(),
                "poi": serializers.ListField(child=serializers.IntegerField()),
            },
        ),
    )
    def create(self, request, *args, **kwargs):
        description = request.data.get('description')
        poi_ids = request.data.get('poi', [])  # Assuming the list of poi IDs is provided in the request
        
        # Retrieve POIs from database based on the provided IDs
        #pois = Poi.objects.filter(pk__in=poi_ids)
        
        # Create the PrecompiledItinerary instance with the retrieved POIs
        precompiled_itinerary = PrecompiledItinerary(description=description)
        precompiled_itinerary.save()
        #precompiled_itinerary.poi.set(pois)
        for order, poi_id in enumerate(poi_ids, start=1):
            poi_instance = Poi.objects.get(pk=poi_id)  # Retrieve the Poi instance
            precompiled_itinerary.poi.add(poi_instance, through_defaults={'order': order})
        
        serializer = self.get_serializer(precompiled_itinerary)
        
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    @extend_schema(
            request=inline_serializer(
            name="InlineFormSerializer",
            fields={
                "description": serializers.CharField(),
                "poi": serializers.ListField(child=serializers.IntegerField()),
            },
        ),
    )
    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        description = request.data.get('description')
        poi_ids = request.data.get('poi', [])  # Assuming the list of poi IDs is provided in the request
        
        # Retrieve POIs from database based on the provided IDs
        # pois = Poi.objects.filter(pk__in=poi_ids)
        
        # Update the PrecompiledItinerary instance with the provided data
        instance.description = description
        instance.save()
        
        instance.poi.clear()
        for order, poi_id in enumerate(poi_ids, start=1):
            poi_instance = Poi.objects.get(pk=poi_id)  # Retrieve the Poi instance
            instance.poi.add(poi_instance, through_defaults={'order': order})
        # instance.poi.set(pois)
        
        serializer = self.get_serializer(instance)
        
        return Response(serializer.data, status=status.HTTP_200_OK)
        