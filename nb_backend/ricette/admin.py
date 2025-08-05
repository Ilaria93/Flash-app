from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import Ricetta, Ingrediente

admin.site.register(Ricetta)
admin.site.register(Ingrediente)
