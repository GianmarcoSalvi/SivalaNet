from random import *
from ..models import *
from ..utils import special_classes as sc


# TEST FUNCTION

def generate_itinerary(user_id, days, must_see_poi=None, budget=None, intensity=None, preference=None):
    
    dailySchedule = []
    ds_list = []

	
			
    # 	poi = {
	# 	"poi_id": 1,
	# 	"city": 1,
	# 	"name": "Museo del fiore",
	# 	"lat": 42.7477229,
	# 	"lon": 11.8630202,
	# 	"address": "PREDIO GIARDINO; 37",
	# 	"type": "Museo, galleria e/o raccolta",
	# 	"poh_id": 1,
	# 	"phone": "763733642",
	# 	"email": "info@museodelfiore.it",
	# 	"average_visiting_time": 5,
	# 	"utility_score": 74
	# }
	
    

    for day in range(days):
      poi_list = []
      poi_per_day = randint(1,4)
      for n in range(poi_per_day):
        length = len(Poi.objects.all())
        poi = Poi.objects.get(pk=randint(1,length))
        poi_list.append(poi)
      ds_list.append(sc.DailySchedule(dailyschedule=poi_list))


    return sc.Itinerary(itinerary=ds_list)



# GEOAPIFY GENERATOR

def random_poi_selection(poi_quantity):
   poi_list = list(Poi.objects.all())
   utility_score_list = Poi.objects.values_list('utility_score', flat=True)
   return random.choices(poi_list, utility_score_list, poi_quantity)
   

def geoapify_routing_planner(start_point_lat, start_point_lon, end_point_lat, end_point_lon, days):
	API_KEY = '37f1ed86af2b40a4820f21fb49aeb5ca'
	api_request = 'https://api.geoapify.com/v1/routeplanner?'
    
	api_request += 'apiKey=' + API_KEY
    
	
	agents = {
        "start_location" : [start_point_lon, start_point_lat],
        "end_location" : [end_point_lon, end_point_lat],
	}


	body = {
        'mode':'drive'
            
	}

	pass
   
