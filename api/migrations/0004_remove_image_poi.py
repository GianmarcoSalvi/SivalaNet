# Generated by Django 4.2.1 on 2023-06-14 16:11

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_auto_20230614_1559'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='image',
            name='poi',
        ),
    ]