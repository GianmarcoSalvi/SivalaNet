import django
from bardapi import Bard
import os, requests
from api.models import Poi
import json
import time
import random

from api.serializers import PoiSerializer

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_project.settings')
django.setup()


def random_timer():
    time.sleep(random.randint(10,60))
    return


desc_text = "Provide a detailed, context-specific, only textual description in italian of that POI"


def request_text(poi, city):
    response = "Retrieve some images of a Place Of Interest (POI) " + '"' + poi + '" which is located ' \
               + "in " + city + ", Italy"
    return response


def set_encoder(obj):
    if isinstance(obj, set):
        return list(obj)
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")


def process_poi_name(poi_name):
    # Task 1: Remove content inside parentheses and parentheses
    index_open_parenthesis = poi_name.find('(')
    index_close_parenthesis = poi_name.find(')')
    if index_open_parenthesis != -1 and index_close_parenthesis != -1:
        poi_name = poi_name[:index_open_parenthesis] + poi_name[index_close_parenthesis + 1:]

    # Task 2: Replace 's.' or 'S.' with 'santo' or 'santa'
    words = poi_name.split()
    new_words = []

    for i, word in enumerate(words):
        if word.lower() in ['s.']:
            next_word = words[i + 1].lower() if i + 1 < len(words) else None
            if next_word and next_word.endswith('a'):
                new_words.append('Santa')
            elif next_word and next_word.endswith('o'):
                new_words.append('Santo')
            else:
                new_words.append('San')
        else:
            new_words.append(word)

    # Task 3: Replace 'ss.' or 'SS.' with 'santissimo' or 'santissima'
    final_words = []

    for i, word in enumerate(new_words):
        if word.lower() in ['ss.', 's.s']:
            next_word = new_words[i + 1].lower() if i + 1 < len(new_words) else None
            if next_word and next_word.endswith('a'):
                final_words.append('Santissima')
            elif next_word and next_word.endswith('o'):
                final_words.append('Santissimo')
            else:
                final_words.append('Santissimo')  # Default to 'santissimo' if not followed by 'a' or 'o'
        else:
            final_words.append(word)

    # Reconstruct the modified name
    modified_poi_name = ' '.join(final_words)
    return modified_poi_name


# info_text = "If you hace access to it, provide information about its opening hour"

os.environ["_BARD_API_KEY"] = "ZAjcM2a4CbbRGXi1jqQxyMU81EvikwclzOsbjlCbUqPt9dz_5Wm6FZBW6_UASaISEKKHTQ."

token = "ZAjcM2a4CbbRGXi1jqQxyMU81EvikwclzOsbjlCbUqPt9dz_5Wm6FZBW6_UASaISEKKHTQ."

session = requests.Session()
session.headers = {
    "Host": "bard.google.com",
    "X-Same-Domain": "1",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36",
    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
    "Origin": "https://bard.google.com",
    "Referer": "https://bard.google.com/",
}
session.cookies.set("__Secure-1PSID", os.getenv("_BARD_API_KEY"))
# session.cookies.set("__Secure-1PSID", token)

bard = Bard(token=token, session=session)

n_files = len(os.listdir('../bard_output'))

queryset = Poi.objects.all().order_by('poi_id')[n_files:]

for poi in queryset:
    name = process_poi_name(poi.name)
    city = poi.city.name

    img_text = request_text(name, city)

    try:
        images = bard.get_answer(img_text)['images']
    except KeyError:
        images = []

    description = bard.get_answer(desc_text)['content']

    file_data = {
        'images': images,
        'description': description
    }

    output_file = f"bard_output/poi_{poi.poi_id}.json"
    with open(output_file, 'w') as file:
        json.dump(file_data, file, indent=4, default=set_encoder)
        print(f'poi_{poi.poi_id} saved correctly - ' + name + ', ' + city)

    random_timer()
