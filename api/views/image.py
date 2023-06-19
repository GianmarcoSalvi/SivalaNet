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


# 9) IMAGE
class ImageViewSet(viewsets.ModelViewSet):
    queryset = Image.objects.all().order_by('image_id')
    serializer_class = ImageSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticatedOrReadOnly]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        instance = serializer.save()

        placeholder = Image.objects.filter(file__exact='images/placeholder.png').first()

        for poi in instance.poi.all():
            placeholder.poi.remove(poi)
            # poi.images.remove(placeholder)

        return Response(serializer.data)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=False)
        serializer.is_valid(raise_exception=True)

        # Custom logic here
        # For example, modify the validated data or perform additional operations
        # before saving the instance

        poi_to_check = instance.poi.all() # poi list before image update

        instance = serializer.save()
        # You can access the updated instance via `instance` variable

        placeholder = Image.objects.filter(file__exact='images/placeholder.png').first()

        for poi in instance.poi.all():
            placeholder.poi.remove(poi)

        updated_poi = instance.poi.all()
        for poi in poi_to_check:
            if poi not in updated_poi and poi.images.count() == 0:
                poi.images.add(placeholder)

        return Response(serializer.data)

    def partial_update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)

        # Custom logic here
        # For example, modify the validated data or perform additional operations
        # before saving the instance

        poi_to_check = instance.poi.all()

        instance = serializer.save()
        # You can access the updated instance via `instance` variable

        placeholder = Image.objects.filter(file__exact='images/placeholder.png').first()

        for poi in instance.poi.all():
            placeholder.poi.remove(poi)

        updated_poi = instance.poi.all()
        for poi in poi_to_check:
            if poi not in updated_poi and poi.images.count() == 0:
                poi.images.add(placeholder)

        return Response(serializer.data)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()

        # Custom logic here
        # For example, perform additional operations before deleting the instance

        placeholder = Image.objects.filter(file__exact='images/placeholder.png').first()

        if instance == placeholder:
            return Response(status=status.HTTP_403_FORBIDDEN, data='Cannot delete placeholder image')

        poi_to_check = instance.poi.all()

        for poi in poi_to_check:
            if poi.images.count() == 1:
                poi.images.add(placeholder)

        self.perform_destroy(instance)

        return Response(status=status.HTTP_204_NO_CONTENT)
