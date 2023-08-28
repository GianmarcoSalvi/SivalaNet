import django
import requests
from api.models import Poi


def run():
    django.setup()
    poi_set = Poi.objects.filter(address='NaN')

    apiKey = '37f1ed86af2b40a4820f21fb49aeb5ca'
    request = 'https://api.geoapify.com/v1/geocode/reverse'

    # list of poi not found by geoapify
    errors_on_poi = []

    for poi in poi_set:
        # poi lat and lon to pass to geoapify request
        lat = str(poi.lat)
        lon = str(poi.lon)
        params = {
            'apiKey': apiKey,
            'lat': lat,
            'lon': lon
        }
        response = requests.get(request, params=params)
        data = response.json()

        if response.status_code == 200:
            address = data['features'][0]['properties']['address_line1']
            poi.address = address
            print('POI ID: ', poi.poi_id, ', ADDRESS: ', poi.address)
            poi.save()
        else:
            errors_on_poi.append(poi.poi_id)
            print('ERROR ON POI - ', poi.poi_id)

    print('POI NOT RETRIEVED BY GEOAPIFY: ', len(errors_on_poi), '\n')
    print(errors_on_poi)

    return
