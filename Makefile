.PHONY: help run test makemigrations migrate shell lint clean

help:
	@echo "Available targets:"
	@echo "  make run           - start the Django development server"
	@echo "  make test          - run Django tests"
	@echo "  make makemigrations - create new migrations based on changes"
	@echo "  make migrate       - apply database migrations"
	@echo "  make shell         - open the Django shell"
	@echo "  make lint          - run ruff linting and formatting"
	@echo "  make clean         - remove temporary or build files"
	@echo "  make build-docker-image - build the Docker image"
	@echo "  make run-docker    - run the Django development server in Docker"
	@echo "  make update-master  - update the local master branch"
	@echo "  make rebase         - rebase the current branch on master"
	@echo "  make merge          - merge the current branch into master"
	@echo "  make push           - push the current branch to origin"
	@echo "  make submit         - update master, rebase, test, push, and open a PR"
	@echo "  make pr             - open a PR for the current branch"
	@echo "  make prune-branches - remove stale remote tracking branches"
	@echo "  make db-stop        - Stop and remove the PostgreSQL Docker container (db-crud-es)"
	@echo "  make db-start       - Start the PostgreSQL Docker container (db-crud-es) on host port 5433"
	@echo "  make run-app        - Start the PostgreSQL container, apply migrations, and run the Django development server"

run:
	cd crud_task_manager && poetry run python manage.py runserver 8080

test:
	cd crud_task_manager && poetry run python manage.py test

update-master:
	git checkout master
	git fetch origin master
	git merge origin/master
	git checkout -

rebase:
	git fetch origin
	git rebase origin/master

merge:
	git checkout master
	git merge --ff-only $(shell git branch --show-current)
	git push origin master

push:
	git push origin $(shell git branch --show-current) --force

submit: update-master rebase test push pr

pr:
	@echo "Checking for existing Pull Request on GitHub..."
	@pr_url=$$(gh pr list --head $(shell git branch --show-current) --base master --state open --json url --jq '.[].url'); \
	if [ -n "$$pr_url" ]; then \
	  echo "A pull request for branch '$(shell git branch --show-current)' already exists:"; \
	  echo "$$pr_url"; \
	else \
	  echo "Opening a Pull Request on GitHub..."; \
	  gh pr create --base master --head $(shell git branch --show-current) --title "Auto PR: $(shell git branch --show-current)" --body "Merging latest changes from $(shell git branch --show-current) into master."; \
	fi


prune-branches:
	git fetch --prune

makemigrations:
	cd crud_task_manager && poetry run python manage.py makemigrations

migrate:
	cd crud_task_manager && poetry run python manage.py migrate

shell:
	cd crud_task_manager && poetry run python manage.py shell

lint:
	cd crud_task_manager && poetry run ruff check --fix .

clean:
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -exec rm -rf {} +

build-docker-image:
	docker build -t crud-app .

# Run the Django development server in docker
run-docker:
	docker run -p 8080:8080 crud-app

db-stop:
	-docker rm -f db-crud-es

db-start: db-stop
	docker run --name db-crud-es -p 5433:5432 -e POSTGRES_DB=project -e POSTGRES_PASSWORD=secret -d postgres:17
	@echo "Waiting for db..."
	sleep 3

run-app: db-start migrate run
	@echo "Application is running!"
