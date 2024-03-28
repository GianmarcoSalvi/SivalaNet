# Generated by Django 4.2.4 on 2024-03-11 15:55

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_alter_image_order_with_respect_to_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='PrecompiledItineraryPoi',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.IntegerField()),
                ('poi', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.poi')),
                ('precompiled_itinerary', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.precompileditinerary')),
            ],
            options={
                'unique_together': {('precompiled_itinerary', 'poi')},
            },
        ),
    ]
