# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.

#from django.db import models
from django.contrib.gis.db import models
from django.contrib.gis.geos import Point

from .utils.db_types import *

class City(models.Model):
    city_id = models.AutoField(primary_key=True)
    province = models.ForeignKey('Province', models.DO_NOTHING)
    name = models.CharField(max_length=256, blank=True, null=True)
    lat = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    lon = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'city'


class DayAndHour(models.Model):
    dah_id = models.AutoField(primary_key=True)
    poh = models.ForeignKey('PoiOpeningHour', models.DO_NOTHING)
    weekday = WeekDayField() 
    opening_hour = models.TimeField()
    closing_hour = models.TimeField()
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'day_and_hour'


class Image(models.Model):
    image_id = models.AutoField(primary_key=True)
    poi = models.ForeignKey('Poi', models.DO_NOTHING)
    url = models.CharField(max_length=1024, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'image'


class Poi(models.Model):
    poi_id = models.AutoField(primary_key=True)
    city = models.ForeignKey(City, models.DO_NOTHING)
    name = models.CharField(max_length=256)
    location = models.PointField(geography=True)
    lat = models.DecimalField(max_digits=9, decimal_places=7)
    lon = models.DecimalField(max_digits=9, decimal_places=7)
    address = models.CharField(max_length=256, blank=True, null=True)
    type = models.CharField(max_length=128)
    phone = models.CharField(max_length=64, blank=True, null=True)
    email = models.CharField(max_length=128, blank=True, null=True)
    average_visiting_time = models.IntegerField()
    # utility_score = models.IntegerField(blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)
    poh = models.OneToOneField('PoiOpeningHour', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'poi'


class Province(models.Model):
    province_id = models.AutoField(primary_key=True)
    region = models.ForeignKey('Region', models.DO_NOTHING)
    name = models.CharField(unique=True, max_length=256, blank=True, null=True)
    lat = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    lon = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'province'


class Region(models.Model):
    region_id = models.AutoField(primary_key=True)
    name = models.CharField(unique=True, max_length=128, blank=True, null=True)
    min_lat = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    min_lon = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    max_lat = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    max_lon = models.DecimalField(max_digits=9, decimal_places=7, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'region'


class SocialInteraction(models.Model):
    si_id = models.AutoField(primary_key=True)
    url = models.CharField(max_length=1024)
    source_type = SourceField()  # This field type is a guess.
    wos = models.ForeignKey('SocialMedia', models.DO_NOTHING, blank=True, null=True)
    poi = models.ForeignKey(Poi, models.DO_NOTHING, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'social_interaction'


class SocialMedia(models.Model):
    sm_id = models.AutoField(primary_key=True)
    url = models.CharField(max_length=1024)
    source_type = SourceField() # This field type is a guess.
    city = models.ForeignKey(City, models.DO_NOTHING, blank=True, null=True)
    poi = models.ForeignKey(Poi, models.DO_NOTHING, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'social_media'


class Tag(models.Model):
    tag_id = models.AutoField(primary_key=True)
    tag = models.CharField(max_length=128)
    si = models.ForeignKey(SocialInteraction, models.DO_NOTHING, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tag'


class User(models.Model):
    user_id = models.AutoField(primary_key=True)
    email = models.CharField(unique=True, max_length=128)
    password = models.CharField(max_length=32)
    age = models.IntegerField()
    gender = GenderField() 
    disability = models.IntegerField()
    tags = models.ManyToManyField(Tag, through='UserTag')
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'user_account'


class UserTag(models.Model):
    ut_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, models.DO_NOTHING)
    tag = models.ForeignKey(Tag, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'user_tag'


class PoiOpeningHour(models.Model):
    poh_id = models.AutoField(primary_key=True)
    is_active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'poi_opening_hour'

class Place(models.Model):
    place_id = models.CharField(max_length=1024,primary_key=True)
    json = models.CharField(max_length=8192)
    last_modification = models.DateTimeField(auto_now=True) # only updates when is called Model.save(). QuereySet.update() won't work

    class Meta:
        managed = False
        db_table = 'place'