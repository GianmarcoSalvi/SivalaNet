from rest_framework import serializers
from .models import *
from .utils import special_classes as sc
from django.contrib.auth.models import User as BackUser
from django.contrib.gis.measure import Distance
from django.core.serializers.json import DjangoJSONEncoder

# 1) REGION
class RegionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Region
        #fields = '__all__'
        exclude = ['is_active']

# 2) PROVINCE
class ProvinceSerializer(serializers.ModelSerializer):
    region = serializers.SlugRelatedField(many=False, read_only=True, slug_field='name')
    class Meta:
        model = Province
        #fields = ['__all__', 'region']
        exclude = ['is_active']

# 3) CITY
class CitySerializer(serializers.ModelSerializer):
    province = serializers.SlugRelatedField(many=False, read_only=True, slug_field='name')
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

# 9) IMAGE READ ONLY
class ImageReadOnlySerializer(serializers.ModelSerializer):
    file = serializers.SerializerMethodField()

    class Meta:
        model = Image
        fields = ['file']

    def get_file(self, obj):
        request = self.context.get('request')
        if request and obj.file:
            return request.build_absolute_uri(obj.file.url)
        return None

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

class DayAndHourReadOnlySerializer(serializers.ModelSerializer):
    class Meta:
        model = DayAndHour
        fields = ['weekday','opening_hour','closing_hour'
                                           '']
class PoiOpeningHourSerializer(serializers.ModelSerializer):
    day_and_hour = DayAndHourReadOnlySerializer(source='dayandhour_set', many=True, read_only=True)
    class Meta:
        model = PoiOpeningHour
        exclude = ['is_active']


class DistanceField(serializers.Field):
    def to_representation(self, value):
        if isinstance(value, Distance):
            return int(value.m)  # Return distance in meters
        return None

# 5) POI
class PoiSerializer(serializers.ModelSerializer):
    utility_score = serializers.FloatField(required=False, default=None, allow_null=True, read_only=True)
    distance = DistanceField(allow_null=True)
    poi_opening_hour = PoiOpeningHourSerializer(read_only=True)
    images = ImageReadOnlySerializer(many=True, read_only=True)
    city = serializers.SlugRelatedField(many=False, read_only=True, slug_field='name')
    class Meta:
        model = Poi
        #fields = '__all__'
        exclude = ['is_active','location']
        # depth = 1

    def to_representation(self, instance):
        data = super().to_representation(instance)
        if data['utility_score'] is None:
            data.pop('utility_score')
        if data['distance'] is None:
            data.pop('distance')
        return data
    
    
class PoiReadOnlySerializer(serializers.ModelSerializer):
    utility_score = serializers.SerializerMethodField()
    poi_opening_hour = PoiOpeningHourSerializer(read_only=True)
    images = ImageReadOnlySerializer(many=True, read_only=True)
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


class PrecompiledItinerarySerializer(serializers.ModelSerializer):
    poi = PoiSerializer(many=True, read_only=True)
    # poi = serializers.PrimaryKeyRelatedField(many=True, queryset=Poi.objects.all())
    # poi = serializers.ListField(child=serializers.IntegerField(), write_only=True, allow_empty=False)
    midpoint_lat = serializers.SerializerMethodField()
    midpoint_lon = serializers.SerializerMethodField()
        
    class Meta:
        model = PrecompiledItinerary
        fields = '__all__'
    """
    def create(self, validated_data):
        pois_data = validated_data.pop('poi', [])
        instance = super().create(validated_data)
        self.save_poi_order(instance, pois_data)
        return instance

    def update(self, instance, validated_data):
        pois_data = validated_data.pop('poi', [])
        # instance = super().update(instance, validated_data)
        self.save_poi_order(instance, pois_data)
        instance.save()
        return instance

    def save_poi_order(self, instance, pois_data):
        instance.poi.clear()
        # Create new associations with order
        for order, poi_id in enumerate(pois_data, start=1):
            poi_instance = Poi.objects.get(pk=poi_id)  # Retrieve the Poi instance
            instance.poi.add(poi_instance, through_defaults={'order': order})
    """
    
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        ordered_poi_ids = instance.poi.through.objects.filter(precompiled_itinerary=instance).order_by('order').values_list('poi_id', flat=True)
        pois_data = []
        for poi_id in ordered_poi_ids:
            poi_instance = Poi.objects.get(pk=poi_id)
            pois_data.append(PoiSerializer(poi_instance, context=self.context).data)
    
        # Update the representation with the serialized POIs
        representation['poi'] = pois_data
        return representation
    

    def get_midpoint_lat(self, obj):
        lat = 0
        if obj is None or obj.poi.count() == 0:
            return 0
        for p in obj.poi.all():
            lat += float(p.lat)
        return lat / obj.poi.count()

    def get_midpoint_lon(self, obj):
        lon = 0
        if obj is None or obj.poi.count() == 0:
            return 0
        for p in obj.poi.all():
            lon += float(p.lon)
        return lon / obj.poi.count()


class PlaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Place
        fields = ['json']

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        return representation['json']


# 12) Itinerary
class ItinerarySerializer(serializers.Serializer):
    midpoint_lat = serializers.DecimalField(max_digits=9, decimal_places=7)
    midpoint_lon = serializers.DecimalField(max_digits=9, decimal_places=7)
    itinerary = DailyScheduleSerializer(many=True)
    #days = serializers.IntegerField(read_only=True)

    def create(self, validated_data):
        return sc.Itinerary(**validated_data)

    def update(self, instance, validated_data):
        for field, value in validated_data.items():
            setattr(instance, field, value)
        return instance


