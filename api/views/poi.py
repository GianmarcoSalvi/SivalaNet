from rest_framework.decorators import api_view
from rest_framework import viewsets, views
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
from ..models import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes
from django.contrib.gis.geos import Point
from django.contrib.gis.db.models.functions import Distance

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
            OpenApiParameter(name="quantity", type=OpenApiTypes.INT, default=3),
            OpenApiParameter(name="radius", type=OpenApiTypes.INT, 
                            description="Radius in meters")
        ]),
        description="Retrieve POI nearby a given poi_id or a generic (lat,lon) point.",
        responses=PoiSerializer(many=True)
    )
    def get(self, request):
        query_dict = request.GET
        if('poi_id' not in query_dict) and not ('lat' in query_dict and 'lon' in query_dict):
            return Response(status=status.HTTP_400_BAD_REQUEST, data="Request parameters must contain exactly one between poi_id and (lat,lon)")
        elif('poi_id' in query_dict and 'lat' in query_dict and 'lon' in query_dict):
            return Response(status=status.HTTP_400_BAD_REQUEST, data="Request parameters must contain exactly one between poi_id and (lat,lon)")

        if('poi_id' in query_dict):
            poi = Poi.objects.get(pk=int(query_dict.get('poi_id')))
            queryset = Poi.objects.annotate(distance=Distance(Point('lat','lon'),
            Point(poi.lat, poi.lon))
            ).order_by('distance')[0:query_dict.get('quantity')]
            return PoiSerializer(data=queryset, many=True)

        return Response(status=status.HTTP_200_OK)