from rest_framework import serializers
from .models import Ricetta, Ingrediente

class IngredienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingrediente
        fields = '__all__'

class RicettaSerializer(serializers.ModelSerializer):
    ingredienti = IngredienteSerializer(many=True)

    class Meta:
        model = Ricetta
        fields = '__all__'
