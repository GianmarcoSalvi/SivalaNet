import time

import django
import openai
import os
import ast
from api.models import Poi
import json


# from api.models import Poi
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

def convert_unicode_escape(text):
    return ast.literal_eval(f'"{text}"')


def generate_content_request(poi, city):
    return f"Fornisci descrizione dettagliata di '{poi}' nel comune di {city}, Italia"


def run():
    # os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'django_project.settings')
    django.setup()

    os.environ["OPENAI_API_KEY"] = "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"
    openai.organization = "org-A7pjf4L0VGyhmioWxCHBIUkb"
    openai.api_key = os.getenv("OPENAI_API_KEY")

    MODEL = "gpt-3.5-turbo"

    message = [{
        'role': 'user'
    }]

    n_files = len(os.listdir('/Users/gianmarco/Root/Università/Magistrale/Tesi/Code/API/django_project/gpt_output'))

    queryset = Poi.objects.all().order_by('poi_id')[n_files:]


    # print(convert_unicode_escape(response['choices'][0]['message']['content'].replace('\n\n', " ")))

    for poi in queryset:
        name = process_poi_name(poi.name)
        city = poi.city.name

        message[0]['content'] = generate_content_request(name, city)

        print(message)

        while True:
            try:
                response = openai.ChatCompletion.create(
                    model=MODEL,
                    messages=message,
                    temperature=0,
                )
                break
            except openai.error.ServiceUnavailableError:
                time.sleep(60)
                continue

        output_file = f"gpt_output/poi_{poi.poi_id}.json"
        with open(output_file, 'w') as file:
            json.dump(response, file, indent=4)
            print(f'poi_{poi.poi_id} saved correctly - ' + name + ', ' + city)
