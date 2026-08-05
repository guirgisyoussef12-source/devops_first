#!/bin/bash
set -e

echo "Installing dependencies..."
pip install -r requirements.txt

echo "Checking Django project..."
python manage.py check

echo "Checking migrations..."
python manage.py makemigrations --check --dry-run

echo "Running tests..."
python manage.py test

echo "All checks passed!"