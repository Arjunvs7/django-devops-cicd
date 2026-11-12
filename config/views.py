from django.http import HttpResponse

def home(request):
    return HttpResponse(
        "Welcome! Django application is running."
    )