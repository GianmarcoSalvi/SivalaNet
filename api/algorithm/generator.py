from random import *
from ..models import *
from ..utils import special_classes as sc

def generate_itinerary(user_id, days, must_see_poi=None, budget=None, intensity=None, preference=None):
    
    dailySchedule = []
    ds_list = []

    poi = {
      "poi_id": 1,
      "city": 1,
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
      poi_list = []
      poi_per_day = randint(1,4)
      for n in range(poi_per_day):
        poi_list.append(poi)
      ds_list.append(sc.DailySchedule(dailyschedule=poi_list))


    return sc.Itinerary(itinerary=ds_list)

    