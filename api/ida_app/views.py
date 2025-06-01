import datetime
import time
from django.http import HttpRequest, JsonResponse, HttpResponse
from django.contrib.auth import authenticate
from django.views.decorators.csrf import csrf_exempt
from ida_app.models import *

def index(request: HttpRequest):
    return HttpResponse("API is up and running")

def signup(request: HttpRequest):
    if request.method != "POST":
        return JsonResponse({"error": "This endpoint can only be accessed via POST"}, status = 400)
    
    email = request.POST.get("email")
    password = request.POST.get("password")

    if not email:
        return JsonResponse({"error": "'email' field is required"}, status = 400)
    if not password:
        return JsonResponse({"error": "'password' field is required"}, status = 400)

    try:
        user: UserCredentials = UserCredentials.objects.create_user(email = email, password = password)
    except Exception:
        return JsonResponse({"error": "A user with that email already exists"}, status = 400)

    settings = UserSettings(user = user, announcements = True, updates = True, merch = True, status = True, reminders = True)
    settings.save()

    return JsonResponse({"message": "User successfully signed up", "user_id": user.user_id, "email": user.email, "admin": user.admin})

def login(request: HttpRequest):
    if request.method != "POST":
        return JsonResponse({"error": "This endpoint can only be accessed via POST"}, status = 400)
    
    email = request.POST.get("email")
    password = request.POST.get("password")

    if not email:
        return JsonResponse({"error": "'email' field is required"}, status = 400)
    if not password:
        return JsonResponse({"error": "'password' field is required"}, status = 400)

    user: UserCredentials = authenticate(request, email = email, password = password)

    if user:
        return JsonResponse({"message": "User successfully logged in", "user_id": user.user_id, "email": user.email, "admin": user.admin})
    
    return JsonResponse({"error": "Email or password is incorrect"}, status = 400)

def add_event(request: HttpRequest):
    if request.method != "POST":
        return JsonResponse({"error": "This endpoint can only be accessed via POST"}, status = 400)

    name = request.POST.get("name")
    date = request.POST.get("date")
    location = request.POST.get("location")

    try:
        latitude = float(request.POST.get("latitude"))
    except:
        return JsonResponse({"error": "'latitude' field is required as a float"}, status = 400)
    
    try:
        longitude = float(request.POST.get("longitude"))
    except:
        return JsonResponse({"error": "'longitude' field is required as a float"}, status = 400)
    
    image = request.POST.get("image")
    essential = request.POST.get("essential")
    if not essential:
        essential = False
    else:
        essential = essential == "yes"

    if not name:
        return JsonResponse({"error": "'name' field is required"}, status = 400)
    if not date:
        return JsonResponse({"error": "'date' field is required"}, status = 400)
    if not location:
        return JsonResponse({"error": "'location' field is required"}, status = 400)
    
    try:
        event = Events(name = name, date = datetime.datetime.strptime(date, "%Y-%m-%d %H:%M:%S"), location = location, latitude = latitude, longitude = longitude, image = image, essential = essential)
        event.save()
    except:
        return JsonResponse({"error": "An unknown error occurred with the database"}, status = 400)

    return JsonResponse({"message": "Event successfully added", "event_id": event.event_id})

def get_events(request: HttpRequest):
    if request.method != "GET":
        return JsonResponse({"error": "This endpoint can only be accessed via GET"}, status = 400)
    
    completed = request.GET.get("completed")
    essential = request.GET.get("essential")

    Events.objects.filter(date__lte = datetime.datetime.now().astimezone(tz = datetime.timezone.utc)).update(completed = True)
    
    if not completed:
        events = list(Events.objects.all().values())
    else:
        events = Events.objects.filter(completed = completed == "yes")
        if completed != "yes" and essential:
            events = events.filter(essential = essential == "yes")
        events = list(events.values())

    return JsonResponse({"data": events})

def toggle_notification(request: HttpRequest):
    if request.method != "POST":
        return JsonResponse({"error": "This endpoint can only be accessed via POST"}, status = 400)

    try:
        user_id = int(request.POST.get("user_id"))
    except:
        return JsonResponse({"error": "'user_id' field is required as a int"}, status = 400)
    
    try:
        event_id = int(request.POST.get("event_id"))
    except:
        return JsonResponse({"error": "'event_id' field is required as a int"}, status = 400)

    try:
        user = UserCredentials.objects.get(user_id = user_id)
    except:
        return JsonResponse({"error": "A user with that user ID does not exist"}, status = 400)
    
    try:
        event = Events.objects.get(event_id = event_id)
    except:
        return JsonResponse({"error": "An event with that event ID does not exist"}, status = 400)
    
    try:
        notif = UserNotifications.objects.get(user = user, event = event)
        notif.delete()
    except:
        notif = UserNotifications(user = user, event = event)
        notif.save()
    
    return JsonResponse({"message": "Notification successfully toggled"})

def get_notifications(request: HttpRequest):
    if request.method != "GET":
        return JsonResponse({"error": "This endpoint can only be accessed via GET"}, status = 400)

    try:
        user_id = int(request.GET.get("user_id"))
    except:
        return JsonResponse({"error": "'user_id' field is required as a int"}, status = 400)

    try:
        user = UserCredentials.objects.get(user_id = user_id)
    except:
        return JsonResponse({"error": "A user with that user ID does not exist"}, status = 400)

    notifs = UserNotifications.objects.filter(user = user).only("event_id")
    
    return JsonResponse({"data": [x["event_id"] for x in list(notifs.values("event_id"))]})

def change_settings(request: HttpRequest):
    if request.method != "POST":
        return JsonResponse({"error": "This endpoint can only be accessed via POST"}, status = 400)
    
    try:
        user_id = int(request.POST.get("user_id"))
    except:
        return JsonResponse({"error": "'user_id' field is required as a int"}, status = 400)
    
    announcements = request.POST.get("announcements")
    if not announcements:
        return JsonResponse({"error": "'announcements' field is required"}, status = 400)
    announcements = announcements == "yes"
    
    updates = request.POST.get("updates")
    if not updates:
        return JsonResponse({"error": "'updates' field is required"}, status = 400)
    updates = updates == "yes"
    
    merch = request.POST.get("merch")
    if not merch:
        return JsonResponse({"error": "'merch' field is required"}, status = 400)
    merch = merch == "yes"
    
    status = request.POST.get("status")
    if not status:
        return JsonResponse({"error": "'status' field is required"}, status = 400)
    status = status == "yes"

    reminders = request.POST.get("reminders")
    if not reminders:
        return JsonResponse({"error": "'reminders' field is required"}, status = 400)
    
    try:
        user = UserCredentials.objects.get(user_id = user_id)
    except:
        return JsonResponse({"error": "A user with that user ID does not exist"}, status = 400)
    
    settings = UserSettings.objects.get(user = user)
    settings.announcements = announcements
    settings.updates = updates
    settings.merch = merch
    settings.status = status
    settings.reminders = reminders
    settings.save()

    return JsonResponse({"message": "Settings changed successfully"})

def get_settings(request: HttpRequest):
    if request.method != "GET":
        return JsonResponse({"error": "This endpoint can only be accessed via GET"}, status = 400)
    
    try:
        user_id = int(request.GET.get("user_id"))
    except:
        return JsonResponse({"error": "'user_id' field is required as a int"}, status = 400)
    
    try:
        user = UserCredentials.objects.get(user_id = user_id)
    except:
        return JsonResponse({"error": "A user with that user ID does not exist"}, status = 400)
    
    settings = UserSettings.objects.get(user = user).__dict__
    settings.pop("_state")

    return JsonResponse({"data": settings})