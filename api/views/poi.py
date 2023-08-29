from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view
from rest_framework import viewsets, views
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status

import api.pagination
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

