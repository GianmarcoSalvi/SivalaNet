import django
import requests
from api.models import Poi, City
import random
import json
import time

output_file = "sample_itinerary.json"


def clear_itinerary_response(generated_itinerary_response, input_params, index):
    clean_itinerary = {
        "Durata in giorni dell'itinerario": input_params['days'],
        'Preferenze utente': input_params['user_preferences'],
        'Comune di partenza': City.objects.get(pk=input_params['city_id']).name,
        'Valutazione itinerario (da 1 a 10)': '*** INSERIRE QUI LA VALUTAZIONE ***',
        'Commenti': '*** INSERIRE QUI EVENTUALI OSSERVAZIONI E COMMENTI ***',
        'Itinerario ' + str(index): {},

    }
    itinerary = generated_itinerary_response['itinerary']
    for day, daily_schedule in enumerate(itinerary):
        poi_list = []
        for poi in daily_schedule['dailyschedule']:
            poi_clean = {'Nome POI': poi['name'], 'Comune': poi['city']}
            poi_list.append(poi_clean)

        clean_itinerary['Itinerario ' + str(index)]['Giorno ' + str(day + 1)] = poi_list

    return clean_itinerary


def run():
    django.setup()

    params = {}
    number_of_itineraries = 100
    keywords = ['Museo, Galleria', 'Parco, Giardino, Lago', 'Chiesa, Culto', 'Villa, Palazzo',
                'Architettura, Monumento', 'Medioevo', 'Moderno', 'Rinascimento', 'Etrusco', 'Preistoria']

    overwrite_file = input('Do you want to overwrite file "' + output_file + '"? (NO <-> no/n, YES <-> yes/y): ')
    if overwrite_file in ['y', 'yes']:
        itineraries = []
        start = 0

    elif overwrite_file in ['n', 'no']:
        with open(output_file, 'r') as file:
            loaded = json.load(file)
            start = len(loaded)
            itineraries = loaded
    else:
        print('Enter yes/y or no/n.')
        return

    city_count = City.objects.count()
    user_id = 1
    params['user_id'] = user_id
    url = 'http://localhost:3888/sivalanetapi/v1/generated_itinerary'

    for i in range(start, number_of_itineraries):
        days = random.randint(2, 5)
        params['days'] = days
        city_id = random.randint(1, city_count)
        params['city_id'] = city_id
        user_preferences = keywords[i % len(keywords)]
        params['user_preferences'] = user_preferences

        response = requests.get(url, params)

        if response.status_code == 200:
            data = response.json()
            itineraries.append(clear_itinerary_response(data, params, i + 1))
            print('Itinerary ', i + 1, ' appended to file.')

        else:
            print('Geoapify Requests limit reached. Saving current itineraries and returning...')
            break

    with open(output_file, 'w') as file:
        if itineraries:
            json.dump(itineraries, file, indent=4, ensure_ascii=False)
