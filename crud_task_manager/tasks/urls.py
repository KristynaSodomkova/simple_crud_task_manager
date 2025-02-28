from django.urls import path

from tasks.views import TaskListView, CreateTaskView, TaskUpdateView, TaskDeleteView, FinishTaskView

urlpatterns = [
    path('', TaskListView.as_view(), name='task_list'),
    path('add/', CreateTaskView.as_view(), name='add_task'),
    path('update/<int:pk>/', TaskUpdateView.as_view(), name='update_task'),
    path('delete/<int:pk>/', TaskDeleteView.as_view(), name='delete_task'),
    path('finish/<int:pk>/', FinishTaskView.as_view(), name='finish_task'),
]
