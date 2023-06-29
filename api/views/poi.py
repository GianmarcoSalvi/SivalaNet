from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view
from rest_framework import viewsets, views
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
from ..models import *
import random
from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view, \
    extend_schema_serializer
from drf_spectacular.types import OpenApiTypes
from django.contrib.gis.geos import Point, fromstr
from django.contrib.gis.db.models.functions import Distance
from django.contrib.gis.measure import D
from django_project.settings import *


# 6) POI


class PoiViewSet(viewsets.ModelViewSet):
    queryset = Poi.objects.all().order_by('poi_id')
    serializer_class = PoiSerializer  # PoiReadOnlySerializer

    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticatedOrReadOnly]

    # case 1: poi doesn't have any associated image -> set placeholder
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Custom logic here
        # For example, modify the validated data or perform additional operations
        # before saving the instance

        instance = serializer.save()
        placeholder = Image.objects.filter(file__exact='images/placeholder.png').first()
        instance.images.add(placeholder)
        # You can access the created instance via `instance` variable

        # Perform any additional operations or modifications to the instance if needed

        # Return a custom response if desired
        return Response(serializer.data)


class nearbyPoi(viewsets.ViewSet):

    @extend_schema(
        parameters=([
            OpenApiParameter(name="lat", type=OpenApiTypes.DOUBLE),
            OpenApiParameter(name="lon", type=OpenApiTypes.DOUBLE),
            OpenApiParameter(name="poi_id", type=OpenApiTypes.INT),
            OpenApiParameter(name="limit", type=OpenApiTypes.INT, default=3, required=True,
                             description="Limit number of retrieved POI"),
            OpenApiParameter(name="radius", type=OpenApiTypes.INT, default=500, required=True,
                             description="Radius in meters")
        ]),
        description="Retrieve POI nearby a given poi_id or a generic (lat,lon) point.",
        request=None
    )
    def list(self, request):
        query_dict = request.GET
        if not query_dict.get('limit') or not query_dict.get('radius'):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="Request parameters 'limit' and/or 'radius' not inserted.")

        if ('poi_id' not in query_dict) and not ('lat' in query_dict and 'lon' in query_dict):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="Request parameters must contain either poi_id or (lat,lon)")
        elif 'poi_id' in query_dict and 'lat' in query_dict and 'lon' in query_dict:
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="Request parameters must contain either poi_id or (lat,lon)")

        limit = int(query_dict.get('limit'))
        radius = int(query_dict.get('radius'))

        if 'poi_id' in query_dict:
            poi_id = int(query_dict.get('poi_id'))
            poi = Poi.objects.get(pk=poi_id)
            current_location = poi.location
            # queryset = Poi.objects.filter(location__distance_lte=(point, D(m=radius))).exclude(pk=poi_id)
            queryset = Poi.objects.annotate(
                distance=Distance(current_location, 'location')
            ).exclude(pk=poi_id).filter(distance__lte=radius).order_by('distance')
            # queryset = Poi.objects.annotate(distance=Distance(fromstr('location', srid=4326), point)
            # ).order_by('distance')[0:query_dict.get('quantity')]

            if queryset.count() > limit:
                queryset = random.sample(list(queryset), limit)

            serializer = PoiSerializer(instance=queryset, many=True)
            return Response(serializer.data)

        elif 'lat' in query_dict and 'lon' in query_dict:
            point = Point(float(query_dict.get('lat')),
                          float(query_dict.get('lon')),
                          srid=4326)
            # distance_lte means "less than equal"
            """queryset = Poi.objects.filter(
                location__distance_lte=(point, D(m=radius)))"""

            queryset = Poi.objects.annotate(
                distance=Distance(point, 'location')
            ).filter(distance__lte=radius).order_by('distance')

            if queryset.count() > limit:
                queryset = random.sample(list(queryset), limit)

        serializer = PoiSerializer(instance=queryset, many=True)
        return Response(serializer.data)
