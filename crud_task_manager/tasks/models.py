from django.db import models

class Task(models.Model):
    name = models.CharField(max_length=100)
    category = models.CharField(max_length=50)
    description = models.TextField(blank=True)
    start = models.DateField(blank=True, null=True)
    expected_finish = models.DateField(blank=True, null=True)
    finished = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    finished_on = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.name
