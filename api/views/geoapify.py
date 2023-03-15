from rest_framework.decorators import api_view, action
from rest_framework import viewsets, views
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics import GenericAPIView
from ..serializers import *
import requests

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes
from ..algorithm import generator
from ..utils import special_classes as sc
from ..models import *


API_KEY = '37f1ed86af2b40a4820f21fb49aeb5ca'


def getPlaceIdList(geoapify_request):
    response = (requests.get(geoapify_request)).json()
    features = response.get('features')
    placeIdList = []
    if features != None and features != []:
        for feature in features:
            placeIdList.append(feature['properties']['place_id'])
    
    return placeIdList
            

class AccommodationView(views.APIView):

    #serializer_class = fakeSerializer

    #http_method_names = ['get']

    @extend_schema(
        parameters=([
            OpenApiParameter(name="categories", type=OpenApiTypes.STR, required=True,
                            description="Comma-separated list of place categories. MUST BE SET TO 'accommodation' or its subclasses, like 'accommodation.hotel'. Check all the details in Geoapify doc.",
                            examples=[OpenApiExample(name='Example value', value='accommodation, accommodation.hotel')]),
            
            OpenApiParameter(name="conditions", type=OpenApiTypes.STR, 
                            description="In addition to categories, there is a possibility to filter results by conditions. For example, only places with internet_access. Check more in externalDocs"),
            OpenApiParameter(name="filter", type=OpenApiTypes.STR,
                            description="Filter places by bounds, circle, geometry or countries"),
            OpenApiParameter(name="bias", type=OpenApiTypes.STR,
                            description="Search first near the location. Note, the API will search places near the location, but not further tham 50km."),
            OpenApiParameter(name="limit", type=OpenApiTypes.STR,
                            description="Maximal number of results per page."),
            OpenApiParameter(name="offset", type=OpenApiTypes.STR,
                            description="Offset to the first result index. Is used to access pages, when number of results is bigger than given limit."),              
            OpenApiParameter(name="lang", type=OpenApiTypes.STR, 
                            description="Result language. 2-character ISO 639-1 language codes are supported."),
            OpenApiParameter(name="name", type=OpenApiTypes.STR,
                            description="Allows to filter places by the given name"),   
            OpenApiParameter(name="lat", type=OpenApiTypes.DOUBLE),
            OpenApiParameter(name="lon", type=OpenApiTypes.DOUBLE),  
        
            ]),
            external_docs={'url':'https://apidocs.geoapify.com/docs/places/#about', 'description':'Geoapify Places API'},
        description='Retrieve Accommodations (Hotel, Motel, Hostal, Guest House, Chalet) by using two Geoapify calls.' +
        'In a first step, it is performed a Geoapify Place request in order to obtain the ID of places of interest. Later, the retrieved IDs are given as input to a Geoapify Place Details request.'
    )
    
    def get(self, request, format=None):
        api_request = 'https://api.geoapify.com/v2/places?'
        api_request += 'apiKey=' + API_KEY
        query_dict = request.GET
        for param in query_dict:
            
            api_request += '&' + param + '=' + query_dict.get(param)
        
            # api_request += '&filter=' + request.GET.get('filter')
            """api_request += '&conditions=' + request.GET.get('conditions')
            api_request += '&bias=' + request.GET.get('bias')
            api_request += '&limit=' + request.GET.get('limit')
            api_request += '&offset=' + request.GET.get('offset')
            api_request += '&lang=' + request.GET.get('lang')
            api_request += '&name=' + request.GET.get('name')"""

        if ('filter' not in query_dict) and ('bias' not in query_dict) and not('lat' in query_dict and 'lon' in query_dict):  
            return Response(status=status.HTTP_400_BAD_REQUEST, data="Request parameters must contain at least one of [filter, bias, (lat,lon)]")
        places = getPlaceIdList(api_request)

        place_details_request = 'https://api.geoapify.com/v2/place-details?'
        place_details_request += 'apiKey=' + API_KEY

        accommodations = []

        for place in places:

            request_preview = place_details_request + '&id=' + place
            response = requests.get(request_preview)

            accommodations.append(response.json())
            
        #response = requests.get(api_request)
        
        return Response(accommodations)


class CateringView(views.APIView):

    #serializer_class = fakeSerializer

    #http_method_names = ['get']

    @extend_schema(
        parameters=([
            OpenApiParameter(name="categories", type=OpenApiTypes.STR, required=True,
                            description="Comma-separated list of place categories. MUST BE SET TO 'catering' or its subclasses, like 'catering.restaurant'. Check all the details in Geoapify doc.",
                            examples=[OpenApiExample(name='Example value', value='catering, catering.restaurant')]),
            
            OpenApiParameter(name="conditions", type=OpenApiTypes.STR, 
                            description="In addition to categories, there is a possibility to filter results by conditions. For example, only places with internet_access. Check more in externalDocs"),
            OpenApiParameter(name="filter", type=OpenApiTypes.STR,
                            description="Filter places by bounds, circle, geometry or countries"),
            OpenApiParameter(name="bias", type=OpenApiTypes.STR,
                            description="Search first near the location. Note, the API will search places near the location, but not further tham 50km."),
            OpenApiParameter(name="limit", type=OpenApiTypes.STR,
                            description="Maximal number of results per page."),
            OpenApiParameter(name="offset", type=OpenApiTypes.STR,
                            description="Offset to the first result index. Is used to access pages, when number of results is bigger than given limit."),              
            OpenApiParameter(name="lang", type=OpenApiTypes.STR, 
                            description="Result language. 2-character ISO 639-1 language codes are supported."),
            OpenApiParameter(name="name", type=OpenApiTypes.STR,
                            description="Allows to filter places by the given name"),   
            OpenApiParameter(name="lat", type=OpenApiTypes.DOUBLE),
            OpenApiParameter(name="lon", type=OpenApiTypes.DOUBLE),  
        
            ]),
            external_docs={'url':'https://apidocs.geoapify.com/docs/places/#about', 'description':'Geoapify Places API'},
        description='Retrieve Caterings (Restaurant, Bar, Fast food, Pub) by using two Geoapify calls.' +
        'In a first step, it is performed a Geoapify Place request in order to obtain the ID of places of interest. Later, the retrieved IDs are given as input to a Geoapify Place Details request.'
    )
    
    def get(self, request, format=None):
        api_request = 'https://api.geoapify.com/v2/places?'
        api_request += 'apiKey=' + API_KEY
        query_dict = request.GET
        for param in query_dict:
            
            api_request += '&' + param + '=' + query_dict.get(param)
        
            # api_request += '&filter=' + request.GET.get('filter')
            """api_request += '&conditions=' + request.GET.get('conditions')
            api_request += '&bias=' + request.GET.get('bias')
            api_request += '&limit=' + request.GET.get('limit')
            api_request += '&offset=' + request.GET.get('offset')
            api_request += '&lang=' + request.GET.get('lang')
            api_request += '&name=' + request.GET.get('name')"""

        if ('filter' not in query_dict) and ('bias' not in query_dict) and not('lat' in query_dict and 'lon' in query_dict):  
            return Response(status=status.HTTP_400_BAD_REQUEST, data="Request parameters must contain at least one of [filter, bias, (lat,lon)]")
        places = getPlaceIdList(api_request)

        place_details_request = 'https://api.geoapify.com/v2/place-details?'
        place_details_request += 'apiKey=' + API_KEY

        caterings = []

        for place in places:
            request_preview = place_details_request + '&id=' + place
            response = requests.get(request_preview)

            caterings.append(response.json())
            
        #response = requests.get(api_request)
        
        return Response(caterings)
