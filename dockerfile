FROM python:3.12-slim as builder
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
WORKDIR /app
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        libpq-dev && \
    rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install \
 --no-cache-dir \
  --prefix=/install \
   -r requirements.txt



FROM python:3.12-slim as production
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
WORKDIR /app
RUN pip install \
    --no-cache-dir \
    --prefix=/install \
    -r requirements.txt
COPY --from=builder /install /usr/local
COPY . .
RUN adduser \
 --disabled-password \
  --gecos "" \
   django-user && \ 
   chown -R django-user:django-user \
   app USER django-user
RUN python manage.py collectstatic --noinput
EXPOSE 8000
CMD [ "gunicorn", "django-todo.wsgi:application", "--bind", "0.0.0.0:8000" ]