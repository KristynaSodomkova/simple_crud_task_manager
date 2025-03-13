# Use an official lightweight Python image
FROM python:3.10-slim

# Set environment variables to prevent Python from buffering stdout/stderr
ENV PYTHONUNBUFFERED=1

# Create and set working directory
WORKDIR /app

# Install system dependencies (if needed)
RUN apt-get update && apt-get install -y build-essential && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Disable Poetry's virtual environment creation so dependencies are installed globally
RUN poetry config virtualenvs.create false

# Copy only the dependency files first for caching purposes
COPY ./pyproject.toml ./poetry.lock /app/

# Install Python dependencies using Poetry (without installing the project itself)
RUN poetry install --no-root --no-interaction --no-ansi

# Copy the rest of the code
COPY . /app

# Expose the port your Django app will run on
EXPOSE 8080

# Run the Django development server (bind to 0.0.0.0 so it's accessible from outside the container)
CMD ["poetry", "run", "python", "crud_task_manager/manage.py", "runserver", "0.0.0.0:8080"]