from rest_framework.decorators import api_view, action
from rest_framework import viewsets, views
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes
from ..algorithm import generator
from ..utils import special_classes as sc
from ..models import *


class ItineraryViewSet(viewsets.ViewSet):
    serializer_class = ItinerarySerializer

    @extend_schema(
    parameters=([
        OpenApiParameter(name="user_id", type=OpenApiTypes.INT, required=True),
        OpenApiParameter(name="days", type=OpenApiTypes.INT, required=True, 
                         description="How many days lasts the journey"),
        OpenApiParameter(name="must_see_poi", type=OpenApiTypes.INT, required=False, many=True,
                         description="List of poi_id (int) chosen by the user"),
        OpenApiParameter(name="budget", type=OpenApiTypes.INT, required=False,
                         description="Budget in euros for the entire journey"),
        OpenApiParameter(name="intensity", type=OpenApiTypes.INT, required=False, enum=(1,2,3,4,5),
                         description="How much relaxed (from 1) or dynimic (up to 5) the journey will be"),
        OpenApiParameter(name="preference", type=OpenApiTypes.INT, required=False, enum=(1,2,3),
                         description="[1] Highest quantity of Poi. [2] Most popular attractions itinerary. [3] Budget minimizing itinerary"),
        OpenApiParameter(name='generating_engine', type=OpenApiTypes.STR, enum=('test','geoapify','ortools'), default='test',
                         description='Choose between different itinerary generators.')
        ])
    )
    def list(self, request):

        match request.GET.get('generating_engine'):

            case 'test':


                itinerary = generator.generate_itinerary(
                    days=int(request.GET.get('days')), 
                    user_id=request.GET.get('user_id'))
                
                serializer = ItinerarySerializer(instance=itinerary)
                return Response(serializer.data)

            case 'geoapify':

                return
            
            case 'ortools':

                return 

        