from django.contrib.gis.db import models


class SourceField(models.Field):
    def db_type(self, connection):
        return 'source'

class WeekDayField(models.Field):
    def db_type(self, connection):
        return 'weekday'

class GenderField(models.Field):
    def db_type(self, connection):
        return 'gender'