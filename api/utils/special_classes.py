from ..models import *
from ..algorithm import generator


class DailySchedule(object):
    def __init__(self, **kwargs):
        for field in ['dailyschedule']:
            setattr(self, field, kwargs.get(field, None))

    
class Itinerary(object):
    def __init__(self, **kwargs):
        for field in ['itinerary']:
            setattr(self, field, kwargs.get(field, None))



class PoiFake(object):
    def __init__(self, **kwargs):
        for field in ('poi_id', 'city', 'name', 'lat', 'lon', 'address', 'type', 'poh_id', 'phone', 'email', 'average_visiting_time', 'utility_score'):
            setattr(self, field, kwargs.get(field, None))



# GEOAPIFY CLASSES


"""
class Accommodation(object):
    def __init__(self, **kwargs):
        for field in ('stars','rooms','beds','reservation'):
            setattr(self, field, kwargs.get(field, None))

class Contact(object):
    def __init__(self, **kwargs):
        for field in ('phone', 'phone_other', 'phone_international', 'email', 'email_other', 'fax'):
            setattr(self, field, kwargs.get(field, None))

class WikiAndMedia(object):
    def __init__(self, **kwargs):
        for field in ('wikidata', 'wikipedia', 'wikimedia_commons', 'image'):
            setattr(self, field, kwargs.get(field, None))

class Place(object):
    def __init__(self, **kwargs):
        for field in ('name', 'country', 'state', 'postcode','city','street','housenumber','lat','lon','formatted','addres_line1','addres_line2',
                      'categories','place_id'):
            setattr(self, field, kwargs.get(field, None))

class Facility(object):
    def __init__(self, **kwargs):
        for field in ('wikidata', 'wikipedia', 'wikimedia_commons', 'image'):
            setattr(self, field, kwargs.get(field, None))
"""

