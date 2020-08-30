FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /app
WORKDIR /app
# Installing OS Dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y libsqlite3-dev gettext
RUN pip install pipenv
COPY . /app
RUN pipenv lock --requirements > requirements.txt
RUN pip install -r requirements.txt
# Django service
RUN python manage.py makemigrations
RUN python manage.py migrate
RUN python manage.py collectstatic --noinput
# Celery
RUN celery -A myshop worker -l info &
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]