# Simple CRUD Task Manager

A small Django-based CRUD application that demonstrates a modern development workflow, 
including automated testing, CI integration, Git automation, and Docker containerization.
This project also uses a Dockerized PostgreSQL database for the event store and application data.

## Overview

This project is a simple CRUD task manager built with Django. It serves as a demonstration of best practices for development workflows including:

- **Automated Git workflows:** Using a comprehensive Makefile to handle branch updates, rebasing, testing, and pull request creation.
- **Continuous Integration (CI):** Leveraging GitHub Actions to automatically run tests, linters, and migration checks on each commit and pull request.
- **Containerization:** A Dockerfile configuration to build and run the app in an isolated, reproducible environment.
- **Dockerized PostgreSQL:** A Docker target for starting a PostgreSQL database container, so you can keep your event store separate from your global environment.

## Features

- **Basic CRUD Operations:** Create, read, update, and delete tasks.
- **Automated Testing:** Run Django tests to ensure code quality.
- **Linting:** Code is automatically linted using Ruff.
- **Git Workflow Automation:** Simplified commands for updating branches, rebasing, pushing, and creating pull requests.
- **Docker Support:** Easily build and run the app in a Docker container.
- **Dockerized Database:** Start and stop a PostgreSQL database container via Makefile targets for local development.

## Requirements

- **Python 3.10** (or later)
- **Poetry** for dependency management
- **Docker** (for containerized development)
- **Git** and **GitHub CLI (`gh`)** for Git workflow automation

## Installation

### Run in your local environment

Install dependencies
   ```bash
   pip install poetry
   poetry install
   poetry install --no-root
   ```
Run the Django development server
   ```bash
    make run-app
   ```
    
### Run in Docker container - optional
   ```bash
    make build-docker-image
    make run-docker
   ```
