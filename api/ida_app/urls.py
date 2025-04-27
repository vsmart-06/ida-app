from django.urls import path
from ida_app.views import *

urlpatterns = [
    path("", index),
    path("signup/", signup),
    path("login/", login),
]