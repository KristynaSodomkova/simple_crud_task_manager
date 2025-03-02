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

run:
	cd crud_task_manager && poetry run python manage.py runserver 8080

test:
	cd crud_task_manager && poetry run python manage.py test

update-master:
	git checkout master
	git pull origin master
	git checkout -

rebase:
	git fetch origin
	git rebase origin/master

merge:
	git checkout master
	git merge --ff-only $(shell git branch --show-current)
	git push origin master

push:
	git push origin $(shell git branch --show-current)

submit: update-master rebase merge push

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
