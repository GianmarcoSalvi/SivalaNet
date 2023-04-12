from rest_framework.decorators import api_view
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
from ..models import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes


# 8) DAY AND HOUR

""" @extend_schema(
        parameters=([
            OpenApiParameter(name="dah_id", type=OpenApiTypes.INT, required=True),
            OpenApiParameter(name="weekday", type=OpenApiTypes.INT, required=False, enum=("mon","tue","wed","thu","fri","sat","sun"))
            # responses=JsonResponse,
        ]),
        examples=[
                {
                    "dah_id": 0,
                    "weekday": "mon",
                    "opening_hour": "08:00:00",
                    "closing_hour": "20:00:00",
                    "poh": 0
                }
            ],
) """
class DayAndHourViewSet(viewsets.ModelViewSet):
    queryset = DayAndHour.objects.all()
    serializer_class = DayAndHourSerializer