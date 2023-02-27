from random import *
from ..serializers import PoiSerializer, DailyScheduleSerializer
from ..models import *

def generate_itinerary(user_id, days, must_see_poi=None, budget=None, intensity=None, preference=None):
    
    dailySchedule = []
    itinerary = {}

    poi = {
      "poi_id": 1,
      "city_id": 1,
      "name": "Museo del fiore",
      "lat": 42.7477229,
      "lon": 11.8630202,
      "address": "PREDIO GIARDINO; 37",
      "type": "Museo, galleria e/o raccolta",
      "poh_id": 1,
      "phone": "763733642",
      "email": "info@museodelfiore.it",
      "average_visiting_time": 5,
      "utility_score": 74
    }


    for day in range(days):
      dailySchedule = []
      poi_per_day = randint(1,4)
      for n in range(poi_per_day):
        dailySchedule.append(randint(1,970))
      itinerary[day] = dailySchedule

    return itinerary



    