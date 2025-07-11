# Generated by Django 5.2 on 2025-07-10 07:56

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ida_app', '0016_usercredentials_avatar'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventRsvp',
            fields=[
                ('record_id', models.AutoField(primary_key=True, serialize=False, unique=True)),
                ('event', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='event_rsvp', to='ida_app.events')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_rsvp', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
