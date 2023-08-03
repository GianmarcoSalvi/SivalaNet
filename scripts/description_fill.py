import django
import os
import re
from api.models import Poi
import json


def run():
    django.setup()
    gpt_dir = os.listdir('gpt_out_corrected')

    for poi in gpt_dir:
        poi_id = int(re.findall(r'\d+', poi)[0])
        with open(os.path.join('gpt_out_corrected', poi), encoding='utf-8') as file:
            data = json.load(file)
            description = data['choices'][0]['message']['content']
            # print(poi_id, ' - ', description)
            to_save = Poi.objects.get(pk=poi_id)
            if to_save.description:
                print('POI ', poi_id, ' already has description. Continuing...')
                continue
            to_save.description = description
            to_save.save()
            print('POI ', poi_id, ' description saved.')