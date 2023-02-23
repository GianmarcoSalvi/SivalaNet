from rest_framework import serializers
from .models import *


# 1) REGION
class RegionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Region
        #fields = '__all__'
        exclude = ['is_active']

# 2) PROVINCE
class ProvinceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Province
        #fields = '__all__'
        exclude = ['is_active']

# 3) CITY
class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = City
        #fields = '__all__'
        exclude = ['is_active']

# 4) USER ACCOUNT
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        #fields = '__all__'
        exclude = ['is_active']

# 5) POI
class PoiSerializer(serializers.ModelSerializer):
    class Meta:
        model = Poi
        #fields = '__all__'
        exclude = ['is_active']
        # depth = 2

# 6) TAG
class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        #fields = '__all__'
        exclude = ['is_active', 'si']

# 8) IMAGE
class ImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Image
        #fields = '__all__'
        exclude = ['is_active']

# 9) SOCIAL MEDIA
class SocialMediaSerializer(serializers.ModelSerializer):
    class Meta:
        model = SocialMedia
        #fields = '__all__'
        exclude = ['is_active']


# 10) DAY AND HOUR
class DayAndHourSerializer(serializers.ModelSerializer):
    class Meta:
        model = DayAndHour
        #fields = '__all__'
        exclude = ['is_active']   
        # depth = 1 

