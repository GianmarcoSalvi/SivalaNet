from rest_framework.decorators import api_view
from rest_framework import viewsets, views
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
from ..models import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes
from django.contrib.gis.geos import Point, fromstr
from django.contrib.gis.db.models.functions import Distance
from django.contrib.gis.measure import D

# 6) POI
class PoiViewSet(viewsets.ModelViewSet):
    queryset = Poi.objects.all()
    serializer_class = PoiSerializer


class nearbyPoi(views.APIView):

    @extend_schema(
        parameters=([
            OpenApiParameter(name="lat", type=OpenApiTypes.DOUBLE),
            OpenApiParameter(name="lon", type=OpenApiTypes.DOUBLE),
            OpenApiParameter(name="poi_id", type=OpenApiTypes.INT),
            OpenApiParameter(name="limit", type=OpenApiTypes.INT, default=3, required=True),
            OpenApiParameter(name="radius", type=OpenApiTypes.INT, default=500, required=True,
                            description="Radius in meters")
        ]),
        description="Retrieve POI nearby a given poi_id or a generic (lat,lon) point.",
        #responses=PoiSerializer(many=True)
    )
    def get(self, request):
        query_dict = request.GET
        limit = int(query_dict.get('limit'))
        radius = int(query_dict.get('radius'))

        if('poi_id' not in query_dict) and not ('lat' in query_dict and 'lon' in query_dict):
            return Response(status=status.HTTP_400_BAD_REQUEST, data="Request parameters must contain exactly one between poi_id and (lat,lon)")
        elif('poi_id' in query_dict and 'lat' in query_dict and 'lon' in query_dict):
            return Response(status=status.HTTP_400_BAD_REQUEST, data="Request parameters must contain exactly one between poi_id and (lat,lon)")

        if('poi_id' in query_dict):
            poi = Poi.objects.get(pk=int(query_dict.get('poi_id')))
            point = Point(float(poi.lon), float(poi.lat), srid=4326)
            queryset = Poi.objects.filter(location__distance_lte=(point, D(m=radius)))
            #queryset = Poi.objects.annotate(distance=Distance(fromstr('location', srid=4326), point)
            #).order_by('distance')[0:query_dict.get('quantity')]

            if len(queryset) > limit:
                queryset = queryset[0:limit]

            serializer = PoiSerializer(instance=queryset, many=True)
            return Response(serializer.data)

        elif('lat' in query_dict and 'lon' in query_dict):
            point(float(query_dict.get('lon')),
                  float(query_dict.get('lat')),
                  srid=4326)
            # distance_lte means "less than equal"
            queryset = Poi.objects.filter(
                location__distance_lte=(point, D(m=radius)))
            
            if len(queryset) > limit:
                queryset = queryset[0:limit]

        serializer = PoiSerializer(instance=queryset, many=True)
        return Response(serializer.data)