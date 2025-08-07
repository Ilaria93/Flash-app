from django.urls import path
from .views import (
    RicettaListAPIView, 
    register_user, 
    login_user,
    ai_recipes_by_ingredients,
    ai_ingredient_tips,
    ai_complementary_ingredients,
    ai_smart_suggestions
)

urlpatterns = [
    # Ricette tradizionali
    path('ricette/', RicettaListAPIView.as_view(), name='ricetta-list'),
    
    # Autenticazione
    path('auth/register/', register_user, name='register'),
    path('auth/login/', login_user, name='login'),
    
    # Endpoint AI Food
    path('ai/recipes/', ai_recipes_by_ingredients, name='ai-recipes'),
    path('ai/tips/', ai_ingredient_tips, name='ai-tips'),
    path('ai/complements/', ai_complementary_ingredients, name='ai-complements'),
    path('ai/suggestions/', ai_smart_suggestions, name='ai-suggestions'),
]
