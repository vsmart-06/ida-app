from django.urls import path
from ida_app.views import *

urlpatterns = [
    path("", index),
    path("signup/", signup),
    path("login/", login),
    path("add-event/", add_event),
    path("get-events/", get_events),
    path("toggle-notification/", toggle_notification),
    path("get-notifications/", get_notifications),
]