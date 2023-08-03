from api.models import *
import os
from django.core.files.images import ImageFile
from pathlib import Path
import json
import django
import django_project.settings

path_to_photos = '/Users/gianmarco/Google-Image-Scraper/photos'
path_to_poi_names = '/Users/gianmarco/Root/Università/Magistrale/Tesi/Code/API/django_project/poi_list.json'


def run():
    django.setup()
    # os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_project.settings')

    poi_photo_dirs = os.listdir(path_to_photos)

    f = open(path_to_poi_names, 'r', encoding='utf-8')
    poi_names = json.load(f)
    counter = 0
    poi_found = []
    placeholder_img = Image.objects.get(pk=107)

    for poi in poi_photo_dirs:
        for key in poi_names:
            if key == 503:
                continue
            poi_name = poi_names[key][0] + ', ' + poi_names[key][1]
            if poi_name == poi and poi not in poi_found:
                print(poi_name)
                poi_found.append(poi)
                counter += 1
                print('POI ', key, ' Trovato')

                image_file_list = os.listdir(
                    os.path.join(path_to_photos, poi)
                )

                poi_obj = [Poi.objects.get(pk=key)]

                for img in image_file_list:
                    path = Path(os.path.join(path_to_photos, poi, img))
                    print(path)
                    placeholder_img.poi.remove(key)
                    with path.open(mode='rb') as f:
                        # Image creation
                        i = Image(
                            file=ImageFile(f, name=path.name.strip()),
                            is_active=True
                        )
                        i.save()
                        i.poi.set(poi_obj)
                        i.save()
                        print('Image associated with poi: ' + str(poi_obj) + '\n')

    print('TROVATI ', counter, ' POI SU ', len(poi_names))
