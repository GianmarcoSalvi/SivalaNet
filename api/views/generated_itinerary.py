from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, action
from rest_framework import views, viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status
from ..serializers import *
import json

from django.http import JsonResponse

from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample, extend_schema_view
from drf_spectacular.types import OpenApiTypes
from ..algorithm import generator as gen
from ..models import *
from rest_framework import mixins


class GeneratedItineraryViewSet(mixins.ListModelMixin,viewsets.GenericViewSet):

    @extend_schema(
            parameters=([
                OpenApiParameter(name="user_id", type=OpenApiTypes.INT, default=1,
                                 description="Only for registered users. Otherwise, 'user_age', 'user_disability', 'user_gender' are required."),

                OpenApiParameter(name="user_age", type=OpenApiTypes.INT),
                OpenApiParameter(name="user_disability", type=OpenApiTypes.BOOL),
                OpenApiParameter(name="user_gender", type=OpenApiTypes.STR, enum=('M', 'F')),

                OpenApiParameter(name="user_preferences", type=OpenApiTypes.STR,
                                 description="Sequence of keywords (strings) divided by commas, representing user preferences about poi: Museo, Biblioteca, Medioevo, Pittura, Natura, Parco, etc",
                                 examples=[
                                     OpenApiExample(name="Single preference", value="Museo"),
                                     OpenApiExample(name="Multiple preference", value="Museo, Parco, Biblioteca"),
                                 ]
                                 ),

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
                OpenApiParameter(name="intensity", type=OpenApiTypes.INT, required=False, enum=(1, 2, 3, 4, 5),
                                 description="How much relaxed (from 1) or dynimic (up to 5) the journey will be"),
                OpenApiParameter(name="preference", type=OpenApiTypes.INT, required=False, enum=(1, 2, 3),
                                 description="[1] Highest quantity of Poi. [2] Most popular attractions itinerary. [3] Budget minimizing itinerary"),
                OpenApiParameter(name='generating_engine', type=OpenApiTypes.STR, enum=('random', 'geoapify', 'ortools'),
                                 default='geoapify', required=True,
                                 description='Choose between different itinerary generators.')
            ])
        )
    def list(self, request):

        params = request.GET

        if ('user_id' not in params) and not (
                'user_age' in params and 'user_disability' in params and 'user_gender' in params):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="Request parameters must contain either the user_id or ALL the user information (age, gender, disability). NOT BOTH.")
        elif ('user_id' in params) and (
                'user_age' in params and 'user_disability' in params and 'user_gender' in params):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="Request parameters must contain either the user_id or ALL the user information (age, gender, disability). NOT BOTH.")

        match params.get('generating_engine'):

            case 'random':
                itinerary = gen.random_itinerary(
                    days=int(request.GET.get('days')),
                    user_id=request.GET.get('user_id'))

                serializer = ItinerarySerializer(instance=itinerary)
                return Response(data=serializer.data, status=status.HTTP_200_OK)

            case 'geoapify':
                sl_lon = request.GET.get('start_location_lon')
                sl_lat = request.GET.get('start_location_lat')
                el_lon = request.GET.get('end_location_lon')
                el_lat = request.GET.get('end_location_lat')
                days = int(request.GET.get('days'))
                user_preferences = request.GET.get('user_preferences')

                geoapify_json_response, query_set_ranked_poi = gen.geoapify_routing_planner(sl_lat, sl_lon, el_lat,
                                                                                            el_lon, days,
                                                                                            user_preferences)

                itinerary = gen.geoapify_response_to_model(geoapify_json_response, query_set_ranked_poi)

                serializer = ItinerarySerializer(instance=itinerary)

                # return Response(itinerary)
                return Response(data=serializer.data, status=status.HTTP_200_OK)

                # serializer = PoiSerializer(gen.rank_text_search_poi_selection(days, user_preferences), many=True)

                # return Response(data = serializer.data, status=status.HTTP_200_OK)

                # return Response(params)
                # return Response(gen.rank_text_search_poi_selection(days, user_preferences))

            case 'ortools':
                return Response(status=status.HTTP_501_NOT_IMPLEMENTED)

    """
    @extend_schema(
        parameters=([
            OpenApiParameter(name="itinerary_id", type=OpenApiTypes.INT, default=1, required=True)
        ]),
        methods=['GET']
    )
    def get_precompiled(self, request):

        try:
            id = int(request.GET.get('itinerary_id'))
            itinerary = PrecompiledItinerary.objects.get(pk=id)
            serializer = PrecompiledItinerarySerializer(instance=itinerary)
            return Response(data=serializer.data, status=status.HTTP_200_OK)

        except:
            return Response(status=status.HTTP_404_NOT_FOUND)
    """