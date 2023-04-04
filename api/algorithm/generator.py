from random import *
from ..models import *
from ..utils import special_classes as sc
import requests
import simplejson as json

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

def probabilistic_poi_selection(poi_quantity):
    poi_list = list(Poi.objects.all())
    utility_score_list = Poi.objects.values_list('utility_score', flat=True)
    
    chosen_poi = set(choices(population=poi_list, weights=utility_score_list, k=poi_quantity))
    while(len(chosen_poi) != poi_quantity):
        left_poi = poi_quantity - len(chosen_poi)
        chosen_poi.update(set(choices(population=poi_list, weights=utility_score_list, k=left_poi)))
    
    return chosen_poi
   

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
def geoapify_routing_planner(start_point_lat, start_point_lon, end_point_lat, end_point_lon, days):
    API_KEY = '37f1ed86af2b40a4820f21fb49aeb5ca'
    api_request = 'https://api.geoapify.com/v1/routeplanner?'
    api_request += 'apiKey=' + API_KEY
    
    POI_PER_DAY = 5
    
    poi_list = probabilistic_poi_selection(days * POI_PER_DAY)

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

    # with open('geoapify_rp_log.json', 'w') as outfile:
    # 	outfile.write(response.json())

    return response.json()



def geoapify_response_to_model(routing_planner_response):

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
                poi = Poi.objects.get(pk=poi_id)
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