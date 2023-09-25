import django
import os
import re
from api.models import Poi
import json
import pandas as pd


def have_credits(string):
    return 'Description credits:' in string


def run():
    new_credits = 0
    existing_credits = 0
    path_to_file = '/Users/gianmarco/Root/Università/Magistrale/Tesi/Code/Excel data/output.xlsx'
    mytuscia_credits = '\n(Description credits: www.mytuscia.com)'
    openai_credits = '\n(Description credits: OpenAI LM generated)'

    django.setup()

    chiese_dict = {
        "CHIESE_DI_NEPI": [528, 511, 535, 533, 515, 519, 514, 523, 526, 536, 508],
        "CHIESE_DI_BASSANO_ROMANO": [84, 87, 81, 82, 85],
        "CHIESE_DI_SORIANO": [630, 641, 626, 627, 629, 632, 625, 631],
        "CHIESE_DI_TARQUINIA": [673, 685, 687, 688, 689, 692, 704, 706, 702, 712, 714, 720, 674, 711, 695],
        "CHIESE_ROMANICHE_DI_TUSCANIA": [753, 725, 736, 726, 735, 739, 747, 741, 740, 743],
        "CHIESE_DI_BOMARZO": [145, 140, 151, 149, 148, 142, 144],
        "CHIESE_DI_BASSANO_IN_TEVERINA": [94, 91, 93, 89],
        "CHIESE_DI_ACQUAPENDENTE": [2, 9, 31, 3, 47, 11, 38, 37, 23, 27, 45, 44, 10],
        "CHIESE_DI_CANEPINA": [172, 173],
        "CHIESE_DI_CAPRANICA": [200, 204],
        "CHIESE_DI_CORCHIANO": [318, 309, 310, 314, 315, 312],
        "CHIESE_DI_CASTIGLIONE_IN_TEVERINA": [240, 252, 245, 237, 253, 243, 248]
    }

    df = pd.read_excel(path_to_file, index_col=False)

    for row in df.index:
        poi_id = df['poi_id'][row]
        if pd.isna(poi_id) is False:
            poi_id = int(poi_id)
            print("POI ID: ", poi_id)
            poi = Poi.objects.get(pk=poi_id)

            descr = poi.description

            if not have_credits(descr):

                descr += mytuscia_credits

                poi.description = descr
                poi.save()

                print("Description saved for the poi.")
            else:
                print("Poi already has description credis. Skipped.")
                continue

    print("******************* CHIESE TIME *********************\n\n\n\n")
    for lista_chiese in chiese_dict:
        for chiesa in chiese_dict[lista_chiese]:
            poi_id = int(chiesa)
            print("POI ID: ", poi_id)
            poi = Poi.objects.get(pk=poi_id)

            descr = poi.description

            if not have_credits(descr):
                descr += mytuscia_credits

                poi.description = descr
                poi.save()

                print("Description saved for the poi.")
            else:
                print("Poi already has description credis. Skipped.")
                continue

    print("\n\n\n*********************** GPT DESCRIPTION TIME ***************************\n\n\n")

    for poi in Poi.objects.all():
        desc = poi.description

        if not have_credits(desc):
            new_credits += 1
            desc += openai_credits
            poi.description = desc
            poi.save()

        else:
            existing_credits += 1
            continue

    print("EXISTING_CREDITS: ", existing_credits)
    print("NEW_CREDITS: ", new_credits)
