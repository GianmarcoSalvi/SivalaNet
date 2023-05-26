from rest_framework import viewsets
from ..serializers import *
from ..models import *
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view


# 8) DAY AND HOUR
class DayAndHourViewSet(viewsets.ModelViewSet):
    queryset = DayAndHour.objects.all()
    serializer_class = DayAndHourSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]