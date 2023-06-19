# from api.serializers import *
from api.models import *
import os
from django.core.files.images import ImageFile
from pathlib import Path
import pandas as pd

im = Image.objects.all()
im.delete()

base_path = '/Users/gianmarco/PycharmProjects/webscraper/venv/images'
images = os.listdir(base_path)


list_all_poi = list(Poi.objects.all())


df = pd.DataFrame(columns=['Image ID', 'File name', 'Poi list'])

for index, image in enumerate(images):
    path = Path(base_path + '/' + image)
    with path.open(mode='rb') as f:
        poi_list = []
        poi_obj = []
        print(str(index) + " - Insert poi_ids of *** " + path.name.strip() + " *** : \n")
        poi_id = input("Poi: ")
        while poi_id.isdigit():
            poi_list.append(poi_id)
            poi_id = input("Poi: ")

        # Se la lista dei poi in input è vuota
        if not poi_list:
            if path.name == 'placeholder.png':
                poi_obj = list_all_poi
            else:
                continue

        else:
            for poi_id in poi_list:
                poi_obj.append(Poi.objects.get(pk=poi_id))

        # Image creation
        i = Image(
            image_id=index,
            file=ImageFile(f, name=path.name.strip()),
            is_active=True
        )
        i.save()
        i.poi.set(poi_obj)
        i.save()
        print('Image associated with poi: ' + str(poi_list) + '\n')

        # Log file

        # Create an empty DataFrame
        row_data = {'Image ID': i.image_id, 'File name': i.file, 'Poi list': poi_list}
        df = pd.concat([df, pd.DataFrame([row_data])], ignore_index=True)

# Specify the filename and sheet name
filename = 'log_images.xlsx'
sheet_name = 'Sheet1'


# DA ERRORE QUI
# Check if the file exists
if os.path.isfile(filename):
    # File exists, overwrite its content
    with pd.ExcelWriter(filename, engine='openpyxl', mode='w') as writer:
        df.to_excel(writer, sheet_name=sheet_name, index=False)
else:
    # File does not exist, create it and write the data
    df.to_excel(filename, sheet_name=sheet_name, index=False)

print(Image.objects.all())
