from django.http import HttpRequest, JsonResponse, HttpResponse
from django.contrib.auth import authenticate
from django.views.decorators.csrf import csrf_exempt
from ida_app.models import *

def index(request: HttpRequest):
    return HttpResponse("API is up and running")

@csrf_exempt
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

    return JsonResponse({"message": "User successfully signed up", "user_id": user.user_id})

@csrf_exempt
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
        return JsonResponse({"message": "User successfully logged in", "user_id": user.user_id})
    
    return JsonResponse({"error": "Email or password is incorrect"}, status = 400)