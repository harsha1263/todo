from django.shortcuts import get_object_or_404, render, redirect
from .models import Task

def task_list(request):
    # Ensure this is 'order_by' and not 'order_set'
    tasks = Task.objects.all().order_by('-created_at') 
    
    if request.method == "POST":
        title = request.POST.get("title")
        if title:
            Task.objects.create(title=title)
        return redirect('task_list')
    return render(request, 'tasks/task_list.html', {'tasks': tasks})

# ADD THIS FUNCTION BELOW:
def toggle_task(request, task_id):
    task = Task.objects.get(id=task_id)
    task.completed = not task.completed
    task.save()
    return redirect('task_list')

def delete_task(request, task_id):
    task = get_object_or_404(Task, id=task_id)
    task.delete()
    return redirect('task_list')