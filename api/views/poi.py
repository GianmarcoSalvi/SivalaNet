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
    queryset = Poi.objects.all().order_by('poi_id')
    serializer_class = PoiSerializer(many=True)

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
        lat = request.GET.get('lat')
        lon = request.GET.get('lon')
        poi_id = request.GET.get('poi_id')
        limit = int(request.GET.get('limit', 3))
        radius = int(request.GET.get('radius', 500))

        if (poi_id and (lat or lon)) or (not poi_id and not (lat and lon)):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="Request parameters must contain either poi_id or (lat,lon)")

        if poi_id:
            poi = Poi.objects.filter(pk=poi_id).first()
            if not poi:
                return Response(status=status.HTTP_404_NOT_FOUND,
                                data="POI with the specified poi_id does not exist.")
            lat = poi.lat
            lon = poi.lon

        point = Point(float(lat), float(lon), srid=4326)
        queryset = Poi.objects.annotate(
            distance=Distance('location', point)
        ).exclude(pk=poi_id).filter(distance__lte=radius).order_by('distance')[:limit]

        serializer = PoiSerializer(instance=queryset, many=True, context={'request':request})
        return Response(serializer.data)
