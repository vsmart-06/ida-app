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
        kwargs.setdefault("is_staff", True)
        kwargs.setdefault("is_superuser", True)
        return self.create_user(email, password, **kwargs)


class UserCredentials(AbstractBaseUser, PermissionsMixin):
    user_id = models.AutoField(primary_key = True, unique = True, null = False)
    email = models.EmailField(unique = True, null = False)
    is_staff = models.BooleanField(default = False, null = False)

    USERNAME_FIELD = "email"

    objects: UserManager = UserManager()