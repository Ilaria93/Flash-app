from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
from rest_framework import generics, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator

# Create your views here.
from rest_framework import generics
from .models import Ricetta
from .serializers import RicettaSerializer

class RicettaListAPIView(generics.ListAPIView):
    serializer_class = RicettaSerializer

    def get_queryset(self):
        ingredienti = self.request.query_params.getlist('ingredienti')
        queryset = Ricetta.objects.all()
        if ingredienti:
            for ingrediente in ingredienti:
                queryset = queryset.filter(ingredienti__nome__icontains=ingrediente)
        return queryset.distinct()

@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    """Endpoint per la registrazione di un nuovo utente"""
    try:
        data = request.data
        username = data.get('email')
        email = data.get('email')
        password = data.get('password')
        first_name = data.get('nome', '')
        last_name = data.get('cognome', '')
        
        if not username or not email or not password:
            return Response({
                'error': 'Email e password sono obbligatori'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        if User.objects.filter(username=username).exists():
            return Response({
                'error': 'Un utente con questa email esiste già'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name
        )
        
        token, created = Token.objects.get_or_create(user=user)
        
        return Response({
            'message': 'Registrazione avvenuta con successo',
            'token': token.key,
            'user': {
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'first_name': user.first_name,
                'last_name': user.last_name
            }
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([AllowAny])
def login_user(request):
    """Endpoint per il login dell'utente"""
    try:
        data = request.data
        username = data.get('email')
        password = data.get('password')
        
        if not username or not password:
            return Response({
                'error': 'Email e password sono obbligatori'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        user = authenticate(username=username, password=password)
        
        if user is not None:
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'message': 'Login avvenuto con successo',
                'token': token.key,
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name
                }
            }, status=status.HTTP_200_OK)
        else:
            return Response({
                'error': 'Credenziali non valide'
            }, status=status.HTTP_401_UNAUTHORIZED)
            
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
