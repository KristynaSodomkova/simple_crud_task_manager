from django.test import TestCase
from django.urls import reverse

from datetime import date

from tasks.models import Task


class TaskModelTest(TestCase):
    def setUp(self):
        self.task = Task.objects.create(
            name="Test Task",
            category="Testing",
            description="This is a test task.",
            start=date.today(),
            expected_finish=date.today(),
            finished=False,
        )

    def test_task_creation(self):
        self.assertEqual(self.task.name, "Test Task")
        self.assertFalse(self.task.finished)

class TaskViewTest(TestCase):
    def setUp(self):
        self.task = Task.objects.create(
            name="Test Task",
            category="Testing",
            description="This is a test task.",
            start=date.today(),
            expected_finish=date.today(),
            finished=False,
        )

    def test_task_list_view(self):
        response = self.client.get(reverse('task_list'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, self.task.name)

    def test_add_task_view(self):
        response = self.client.post(reverse('add_task'), {
            'name': "New Task",
            'category': "Development",
            'description': "New task description",
            'start': date.today(),
            'expected_finish': date.today(),
        })
        self.assertEqual(response.status_code, 302)  # Should redirect after successful add
        self.assertEqual(Task.objects.count(), 2)

    def test_update_task_view(self):
        response = self.client.post(reverse('update_task', args=[self.task.pk]), {
            'name': "Updated Task",
            'category': self.task.category,
            'description': self.task.description,
            'start': self.task.start,
            'expected_finish': self.task.expected_finish,
        })
        self.assertEqual(response.status_code, 302)
        self.task.refresh_from_db()
        self.assertEqual(self.task.name, "Updated Task")

    def test_delete_task_view(self):
        response = self.client.post(reverse('delete_task', args=[self.task.pk]))
        self.assertEqual(response.status_code, 302)
        self.assertEqual(Task.objects.count(), 0)

    def test_finish_task_view(self):
        response = self.client.post(reverse('finish_task', args=[self.task.pk]))
        self.assertEqual(response.status_code, 302)
        self.task.refresh_from_db()
        self.assertTrue(self.task.finished)
        self.assertIsNotNone(self.task.finished_on)
