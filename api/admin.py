from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import *

# Register your models here.
admin.site.register(City)
admin.site.register(DayAndHour)
admin.site.register(Image)
admin.site.register(Poi)
admin.site.register(Province)
admin.site.register(Region)
admin.site.register(SocialInteraction)
admin.site.register(SocialMedia)
admin.site.register(Tag)
admin.site.register(User)
admin.site.register(UserTag)
admin.site.register(PoiOpeningHour)
admin.site.register(Place)
