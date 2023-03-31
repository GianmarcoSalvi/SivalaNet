from rest_framework.decorators import api_view, action
from rest_framework import views
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes
from ..algorithm import generator as gen
from ..models import *


class ItineraryView(views.APIView):
    
    serializer_class = ItinerarySerializer

    @extend_schema(
    parameters=([
        OpenApiParameter(name="user_id", type=OpenApiTypes.INT, required=True, default=1),
        OpenApiParameter(name="start_location_lat", type=OpenApiTypes.DOUBLE, required=True, 
                         examples=[OpenApiExample(name='Viterbo', value="42.4193700")]),
        OpenApiParameter(name="start_location_lon", type=OpenApiTypes.DOUBLE, required=True,
                         examples=[OpenApiExample(name='Viterbo', value="12.1056000")]),

        OpenApiParameter(name="end_location_lat", type=OpenApiTypes.DOUBLE, required=True,
                        examples=[OpenApiExample(name='Viterbo', value="42.4193700")]),
        OpenApiParameter(name="end_location_lon", type=OpenApiTypes.DOUBLE, required=True,
                         examples=[OpenApiExample(name='Viterbo', value="12.1056000")]),
        
        OpenApiParameter(name="days", type=OpenApiTypes.INT, required=True, default=3, 
                         description="How many days lasts the journey"),
        OpenApiParameter(name="must_see_poi", type=OpenApiTypes.INT, required=False, many=True,
                         description="List of poi_id (int) chosen by the user"),
        OpenApiParameter(name="budget", type=OpenApiTypes.INT, required=False,
                         description="User-defined budget in euros for the entire journey"),
        OpenApiParameter(name="intensity", type=OpenApiTypes.INT, required=False, enum=(1,2,3,4,5),
                         description="How much relaxed (from 1) or dynimic (up to 5) the journey will be"),
        OpenApiParameter(name="preference", type=OpenApiTypes.INT, required=False, enum=(1,2,3),
                         description="[1] Highest quantity of Poi. [2] Most popular attractions itinerary. [3] Budget minimizing itinerary"),
        OpenApiParameter(name='generating_engine', type=OpenApiTypes.STR, enum=('test','geoapify','ortools'), default='test', required=True,
                         description='Choose between different itinerary generators.')
        ])
    )
    def get(self, request):

        match request.GET.get('generating_engine'):

            case 'test':
                itinerary = gen.random_itinerary(
                    days=int(request.GET.get('days')), 
                    user_id=request.GET.get('user_id'))
                
                serializer = ItinerarySerializer(instance=itinerary)
                return Response(serializer.data)

            case 'geoapify':
                sl_lon = request.GET.get('start_location_lon')
                sl_lat = request.GET.get('start_location_lat')
                el_lon = request.GET.get('end_location_lon')
                el_lat = request.GET.get('end_location_lat')
                days = int(request.GET.get('days'))

                itinerary = gen.geoapify_response_to_model(
                   gen.geoapify_routing_planner(sl_lat, sl_lon, el_lat, el_lon, days)
                )
                
                serializer = ItinerarySerializer(instance=itinerary)

                return Response(serializer.data)

                #return Response(gen.geoapify_routing_planner(sl_lat, sl_lon, el_lat, el_lon, days))
                
            case 'ortools':
                
                return

        