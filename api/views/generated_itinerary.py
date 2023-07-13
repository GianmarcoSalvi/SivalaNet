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


class GeneratedItineraryViewSet(mixins.ListModelMixin, viewsets.GenericViewSet):
    serializer_class = ItinerarySerializer()

    @extend_schema(
        parameters=([
            OpenApiParameter(name="user_id", type=OpenApiTypes.INT, default=1,
                             description="Only for registered users. Otherwise, 'user_age' and 'user_disability' are required."),

            OpenApiParameter(name="user_age", type=OpenApiTypes.INT),
            OpenApiParameter(name="user_disability", type=OpenApiTypes.BOOL),

            OpenApiParameter(name="user_preferences", type=OpenApiTypes.STR,
                             description="Sequence of keywords (strings) divided by commas, representing user preferences about poi: Museo, Biblioteca, Medioevo, Pittura, Natura, Parco, etc",
                             examples=[
                                 OpenApiExample(name="Single preference", value="Museo"),
                                 OpenApiExample(name="Multiple preference", value="Museo, Parco, Biblioteca"),
                             ]
                             ),

            OpenApiParameter(name="start_location_lat", type=OpenApiTypes.DOUBLE,
                             examples=[OpenApiExample(name='Viterbo', value="42.4193700")]),
            OpenApiParameter(name="start_location_lon", type=OpenApiTypes.DOUBLE,
                             examples=[OpenApiExample(name='Viterbo', value="12.1056000")]),

            OpenApiParameter(name="end_location_lat", type=OpenApiTypes.DOUBLE),
            OpenApiParameter(name="end_location_lon", type=OpenApiTypes.DOUBLE),

            OpenApiParameter(name='city_id', type=OpenApiTypes.INT,
                             examples=[OpenApiExample(name='Viterbo', value=58)]),

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
            # OpenApiParameter(name='generating_engine', type=OpenApiTypes.STR, enum=('random', 'geoapify', 'ortools'),
            #                   default='geoapify', required=True,
            #                   description='Choose between different itinerary generators.')
        ])
    )
    def list(self, request):

        params = request.GET
        start_location_lat = params.get('start_location_lat')
        start_location_lon = params.get('start_location_lon')
        end_location_lat = params.get('end_location_lat')
        end_location_lon = params.get('end_location_lon')
        city_id = params.get('city_id')
        user_id = params.get('user_id')
        user_age = params.get('user_age')
        user_disability = params.get('user_disability')
        days = params.get('days')
        user_preferences = params.get('user_preferences')

        if (user_id is None and user_disability is None and user_age is None) or (
                user_id and user_age and user_disability):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="Request parameters must contain either the user_id or the user information (age, disability)")
        if not ((start_location_lat is None and start_location_lon is None and city_id is None) or \
                (start_location_lat is not None and start_location_lon is not None and city_id is None) or \
                (start_location_lat is None and start_location_lon is None and city_id is not None)):
            return Response(status=status.HTTP_400_BAD_REQUEST,
                            data="If you want to define a starting point you have to insert one among (start_location_lat, start_location_lon) and city_id."
                                 " Otherwise can leave all of them empty.")

        if city_id is not None:
            start_location_lat = City.objects.get(pk=city_id).lat
            start_location_lon = City.objects.get(pk=city_id).lon

        geoapify_json_response, query_set_ranked_poi = \
            gen.geoapify_routing_planner(days,
                                         user_preferences,
                                         start_point_lat=start_location_lat,
                                         start_point_lon=start_location_lon,
                                         end_point_lat=end_location_lat,
                                         end_point_lon=end_location_lon)

        itinerary = gen.geoapify_response_to_model(geoapify_json_response, query_set_ranked_poi)

        serializer = ItinerarySerializer(instance=itinerary, context={'request': request})

        # return Response(itinerary)
        return Response(data=serializer.data, status=status.HTTP_200_OK)

        # serializer = PoiSerializer(gen.rank_text_search_poi_selection(days, user_preferences), many=True)

        # return Response(data = serializer.data, status=status.HTTP_200_OK)

        """ match params.get('generating_engine'):

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

                serializer = ItinerarySerializer(instance=itinerary, context={'request': request})

                # return Response(itinerary)
                return Response(data=serializer.data, status=status.HTTP_200_OK)

                # serializer = PoiSerializer(gen.rank_text_search_poi_selection(days, user_preferences), many=True)

                # return Response(data = serializer.data, status=status.HTTP_200_OK)

                # return Response(params)
                # return Response(gen.rank_text_search_poi_selection(days, user_preferences))

            case 'ortools':
                return Response(status=status.HTTP_501_NOT_IMPLEMENTED)"""

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
