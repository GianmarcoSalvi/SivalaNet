from rest_framework import serializers
from .models import *
from .utils import special_classes as sc


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

class PoiOpeningHourSerializer(serializers.ModelSerializer):
    #opening_hour = DayAndHourSerializer(many=True, read_only=True)
    class Meta:
        model = PoiOpeningHour
        exclude = ['is_active']


# 5) POI
class PoiSerializer(serializers.ModelSerializer):
    utility_score = serializers.FloatField(required=False, default=None)
    # extra_kwargs = {'utility_score': {}}
    class Meta:
        model = Poi
        #fields = '__all__'
        exclude = ['is_active','location']
        # depth = 1


class PoiSerializerFake(serializers.Serializer):
    poi_id = serializers.IntegerField(read_only=True)
    city = serializers.IntegerField(read_only=True)
    name = serializers.CharField(max_length=256)
    lat = serializers.FloatField(read_only=True)
    lon = serializers.FloatField(read_only=True)
    address = serializers.CharField(max_length=256)
    type = serializers.CharField(max_length=128)
    poh_id = serializers.IntegerField(read_only=True)
    phone = serializers.CharField(max_length=64)
    email = serializers.CharField(max_length=128)
    average_visiting_time = serializers.IntegerField(read_only=True)
    utility_score = serializers.IntegerField(read_only=True)

    def create(self, validated_data):
        return sc.PoiFake(**validated_data)

    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        return instance

# 11) DailySchedule
class DailyScheduleSerializer(serializers.Serializer):
    dailyschedule = PoiSerializer(many=True, read_only=True)
    #poi_quantity = serializers.IntegerField(read_only=True)

    def create(self, validated_data):
        return sc.DailySchedule(**validated_data)

    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        return instance

        


# 12) Itinerary
class ItinerarySerializer(serializers.Serializer):
    itinerary = DailyScheduleSerializer(many=True)
    #days = serializers.IntegerField(read_only=True)

    def create(self, validated_data):
        return sc.Itinerary(**validated_data)

    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        return instance


