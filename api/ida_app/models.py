from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class UserManager(BaseUserManager):
    def create_user(self, email, password, **kwargs):
        if not email:
            raise ValueError("'email' field is required")
        if not password:
            raise ValueError("'password' field is required")

        email = self.normalize_email(email)
        email.lower()

        user: UserCredentials = self.model(email = email, **kwargs)
        user.set_password(password)

        try:
            user.save(using = self._db)
        except:
            raise Exception("A user with that username or email already exists")

        return user
    
    def create_superuser(self, email, password, **kwargs):
        kwargs.setdefault("admin", True)
        kwargs.setdefault("is_superuser", True)
        return self.create_user(email, password, **kwargs)


class UserCredentials(AbstractBaseUser, PermissionsMixin):
    user_id = models.AutoField(primary_key = True, unique = True, null = False)
    email = models.EmailField(unique = True, null = False)
    admin = models.BooleanField(default = False, null = False)

    USERNAME_FIELD = "email"

    objects: UserManager = UserManager()


class Events(models.Model):
    event_id = models.AutoField(primary_key = True, unique = True, null = False)
    name = models.TextField(unique = False, null = False)
    date = models.DateTimeField(unique = False, null = False)
    location = models.TextField(unique = False, null = False)
    latitude = models.FloatField(unique = False, null = False)
    longitude = models.FloatField(unique = False, null = False)
    image = models.TextField(default = "https://i.imgur.com/Mw85Kfp.png", null = False)
    body = models.TextField(unique = False, null = False)
    completed = models.BooleanField(default = False, null = False)
    essential = models.BooleanField(default = False, null = False)

class UserNotifications(models.Model):
    notification_id = models.AutoField(primary_key = True, unique = True, null = False)
    user = models.ForeignKey(UserCredentials, related_name = "user", on_delete = models.CASCADE, null = False)
    event = models.ForeignKey(Events, related_name = "event", on_delete = models.CASCADE, null = False)


class UserSettings(models.Model):
    user = models.OneToOneField(UserCredentials, on_delete = models.CASCADE, primary_key = True, null = False)
    announcements = models.BooleanField(default = True, null = False)
    updates = models.BooleanField(default = True, null = False)
    merch = models.BooleanField(default = True, null = False)
    status = models.BooleanField(default = True, null = False)
    reminders = models.TimeField(unique = False, null = True)