from django.urls import path
from .views import RicettaListAPIView, register_user, login_user

urlpatterns = [
    path('ricette/', RicettaListAPIView.as_view(), name='ricetta-list'),
    path('auth/register/', register_user, name='register'),
    path('auth/login/', login_user, name='login'),
]
