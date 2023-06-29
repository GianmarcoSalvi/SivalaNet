from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view
from rest_framework import viewsets, views
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
from ..models import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes


# 10) SOCIAL MEDIA
class SocialMediaViewSet(viewsets.ModelViewSet):
    queryset = SocialMedia.objects.all().order_by('sm_id')
    serializer_class = SocialMediaSerializer
    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticatedOrReadOnly]
