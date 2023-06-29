from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
from ..models import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes

""" @extend_schema(
    # operation_id='getRegions',
    tags=['region'],
    examples=[OpenApiExample(
        name='Region object example',
        value={
            "region_id": 1,
            "name": "Lazio",
            "min_lat": 40.7849283,
            "min_lon": 11.4491695,
            "max_lat": 42.8402690,
            "max_lon": 14.0276445,
        })
    ]
) """


# 1) REGION
class RegionViewSet(viewsets.ModelViewSet):
    queryset = Region.objects.all().order_by('region_id')
    serializer_class = RegionSerializer
    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticatedOrReadOnly]
