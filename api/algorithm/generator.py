from random import *
from ..models import *
from ..utils import special_classes as sc
import requests
import simplejson as json

from django.contrib.postgres.search import SearchQuery, SearchRank, SearchVector

from django.db.models import Value, IntegerField
from django.db.models import Q
from django.db.models.functions import Coalesce

# *************************************************
# TEST FUNCTION: POI RANDOMLY TAKEN FROM DB
# *************************************************

def random_itinerary(user_id, days, must_see_poi=None, budget=None, intensity=None, preference=None):
    
    ds_list = []

    for day in range(days):
        poi_list = []
        poi_per_day = randint(2,4)
        for n in range(poi_per_day):
            length = len(Poi.objects.all())
            poi = Poi.objects.get(pk=randint(1,length))
            poi_list.append(poi)
        ds_list.append(sc.DailySchedule(dailyschedule=poi_list))

    return sc.Itinerary(itinerary=ds_list)


# *************************************************
# GEOAPIFY GENERATOR
# *************************************************

def random_poi_selection(poi_quantity):

    qs = Poi.objects.all()
    pks = list(qs.values_list('poi_id', flat=True))

    poi_id_list = sample(pks, k=poi_quantity)

    query_set = Poi.objects.filter(poi_id__in=poi_id_list)
    chosen_poi = set(list(query_set))

    
    return chosen_poi, query_set

    """
    query_set = Poi.objects.annotate(
        utility_score = Value(randint(1,100), output_field=IntegerField())
    )
    poi_list = list(query_set)
    utility_score_list = query_set.values_list('utility_score', flat=True)
    

    chosen_poi = set(choices(population=poi_list, weights=utility_score_list, k=poi_quantity))
    while(len(chosen_poi) != poi_quantity):
        left_poi = poi_quantity - len(chosen_poi)
        chosen_poi.update(set(choices(population=poi_list, weights=utility_score_list, k=left_poi)))
    
    return chosen_poi, query_set
    """
    
   
def rank_text_search_poi_selection(poi_quantity, user_preferences):

    search_vector = SearchVector("name", weight="A", config='italian')
    search_vector += SearchVector("description", weight="B", config='italian')
    search_vector += SearchVector( "type", weight="B", config='italian') 

    #weights_vector = [0.4, 0.6, 0.8, 1.0] # D,C,B,A
    
    query_string = user_preferences.lower().strip().replace(',', ' or ')
   
    query = SearchQuery(query_string, config='italian', search_type='websearch') 
    
    query_set_ranked_poi = Poi.objects.annotate(
        utility_score = SearchRank(
            search_vector,
            query,
            #cover_density=True
            #weights = weights_vector
        )
    ).order_by('-utility_score').filter(~Q(utility_score = 0))

    #return query_set_ranked_poi

    
    if query_set_ranked_poi.count() >= poi_quantity:


        poi_list = list(query_set_ranked_poi)
        utility_score_list = query_set_ranked_poi.values_list('utility_score', flat=True)

        chosen_poi = set(choices(population=poi_list, weights=utility_score_list, k=poi_quantity))
        while(len(chosen_poi) != poi_quantity):
            left_poi = poi_quantity - len(chosen_poi)
            chosen_poi.update(set(choices(population=poi_list, weights=utility_score_list, k=left_poi)))
    
        return chosen_poi, query_set_ranked_poi

    # poi found with utility_score > 0 are not enough
    elif query_set_ranked_poi.count() != 0:
        
        poi_list = list(query_set_ranked_poi)

        utility_score_list = query_set_ranked_poi.values_list('utility_score', flat=True)

        chosen_poi = set(choices(population=poi_list, weights=utility_score_list, k=poi_quantity))

        while(len(chosen_poi) != len(poi_list)):
            left_poi = len(poi_list) - len(chosen_poi)
            chosen_poi.update(set(choices(population=poi_list, weights=utility_score_list, k=left_poi)))


        
        if len(chosen_poi) != poi_quantity:
            left_poi = poi_quantity - len(chosen_poi)
            k_random_poi, query_set = random_poi_selection(left_poi)
            
            chosen_poi.update(k_random_poi)
            query_set_ranked_poi.union(query_set)
    else:
        return random_poi_selection(poi_quantity)
        
    




def jobs_dict(poi_list):
    jobs = []
    
    for poi in poi_list:
        job = {}
        job.update({"location":[poi.lon, poi.lat]})
        job.update({"id":str(poi.poi_id)})
        job.update({"description": poi.name})
        job.update({"duration": poi.average_visiting_time})	
        jobs.append(job)
        
    return jobs
    

def time_windows(days):
    time_windows = []
    SECS_PER_DAY = 86400
    SECS_PER_HOUR = 3600
    
    AVAILABLE_MORNING_HOURS = 4; # from 9 to 13
    LUNCH_TIME_HOURS = 2; # from 13 to 15
    AVAILABLE_AFTERNOON_HOURS = 5; # from 15 to 20
    
    for day in range(days):
        time_windows.append([SECS_PER_DAY*day, SECS_PER_DAY*day + AVAILABLE_MORNING_HOURS * SECS_PER_HOUR])
        time_windows.append([
            SECS_PER_DAY*day + AVAILABLE_MORNING_HOURS * SECS_PER_HOUR + LUNCH_TIME_HOURS*SECS_PER_HOUR,
            SECS_PER_DAY*day + AVAILABLE_MORNING_HOURS * SECS_PER_HOUR + 
            LUNCH_TIME_HOURS*SECS_PER_HOUR + AVAILABLE_AFTERNOON_HOURS*SECS_PER_HOUR 
        ])

    return time_windows

# Consumes geoapify credits
def geoapify_routing_planner(start_point_lat, start_point_lon, end_point_lat, end_point_lon, days, user_preferences):
    API_KEY = '37f1ed86af2b40a4820f21fb49aeb5ca'
    api_request = 'https://api.geoapify.com/v1/routeplanner?'
    api_request += 'apiKey=' + API_KEY
    
    POI_PER_DAY = 5
    
    poi_list, query_set_ranked_poi = rank_text_search_poi_selection(days * POI_PER_DAY, user_preferences) # rank_text_search_poi_selection
    #poi_list = random_poi_selection(days * POI_PER_DAY) # rank_text_search_poi_selection
    
    # BODY ELEMENTS FOR REQUEST

    mode = "drive"
    traffic = "approximated" # 'free_flow'
    type = "balanced" # 'short', 'less_maneuvers'
    tw = time_windows(days)
    ags = [{
        "start_location" : [start_point_lon, start_point_lat],
        "end_location" : [end_point_lon, end_point_lat],
        "time_windows": tw,
        "id": "TOURIST_AGENT"
    }]

    jobs = jobs_dict(poi_list)

    body = {
        "mode": mode,
        "agents": ags,
        "traffic": traffic,
        "type": type,
        "jobs": jobs
    }

    headers = {"Content-Type": "application/json; charset=utf-8"}
    
    response = requests.post(api_request,headers=headers, json=body)

    # SOMETIMES RESPONSE ISN'T OK

    with open('geoapify_rp_log.json', 'w') as outfile:
        outfile.write(str("Ciao fesso\n\n\n") + str(response.json())) #

    return response.json(), query_set_ranked_poi
        


def geoapify_response_to_model(routing_planner_response, query_set_ranked_poi):


    rpr = routing_planner_response

    actions = rpr["features"][0]["properties"]["actions"]
    # jobs = rpr["properties"]["params"]["jobs"]

    breaks_count = 0
    poi_list = []
    
    ds_list = []

    for idx in range(len(actions)):
        act_type = actions[idx]["type"]

        match act_type:

            case "job":
                poi_id = int(actions[idx]["job_id"])
                poi = query_set_ranked_poi.get(pk=poi_id)
                poi_list.append(poi)
                
            case "break":
                breaks_count += 1
                if breaks_count % 2 == 0:
                    ds_list.append(sc.DailySchedule(dailyschedule=poi_list))
                    poi_list = []
                else:
                    pass

            case "end":
                ds_list.append(sc.DailySchedule(dailyschedule=poi_list))

            case other:
                pass

    return sc.Itinerary(itinerary=ds_list)