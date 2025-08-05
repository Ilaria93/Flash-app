from django.db import models

# Create your models here.
from django.db import models

class Ingrediente(models.Model):
    nome = models.CharField(max_length=100)

    def __str__(self):
        return self.nome

class Ricetta(models.Model):
    nome = models.CharField(max_length=200)
    descrizione = models.TextField()
    ingredienti = models.ManyToManyField(Ingrediente)
    istruzioni = models.TextField()

    def __str__(self):
        return self.nome
