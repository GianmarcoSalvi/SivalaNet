
from rest_framework import viewsets
from ..serializers import *
from ..models import *
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticatedOrReadOnly


# 3) CITY
class CityViewSet(viewsets.ModelViewSet):
    queryset = City.objects.all().order_by('city_id')
    serializer_class = CitySerializer
    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticatedOrReadOnly]

