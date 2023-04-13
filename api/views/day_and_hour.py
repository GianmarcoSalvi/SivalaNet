from rest_framework.decorators import api_view
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
from ..models import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes


# 8) DAY AND HOUR

@extend_schema_view(
    list=extend_schema(
        examples=([
            OpenApiExample(
                name="Example",
                value={
                    "dah_id": 0,
                    "weekday": "mon",
                    "opening_hour": "8:00:00",
                    "closing_hour": "20:00:00",
                    "poh": 0
                }
            )
        ])
    ),
    create=extend_schema(
        examples=([
            OpenApiExample(
                name="Example",
                value={
                    "weekday": "wed",
                    "opening_hour": "8:00:00",
                    "closing_hour": "20:00:00",
                    "poh": 0
                }
            )
        ])
    )
)
class DayAndHourViewSet(viewsets.ModelViewSet):
    queryset = DayAndHour.objects.all()
    serializer_class = DayAndHourSerializer