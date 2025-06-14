#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Python dependencies
pip install -r requirements.txt

# Run database migrations
echo "Running database migrations..."
python manage.py makemigrations users --noinput
python manage.py makemigrations meals --noinput
python manage.py migrate users --noinput
python manage.py migrate meals --noinput
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --no-input 