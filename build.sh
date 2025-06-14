#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Python dependencies
pip install -r requirements.txt

# Run database migrations
echo "Running database migrations..."
# First, ensure all migrations are created
python manage.py makemigrations --noinput

# Then apply migrations in the correct order
echo "Applying migrations..."
python manage.py migrate auth --noinput
python manage.py migrate contenttypes --noinput
python manage.py migrate admin --noinput
python manage.py migrate sessions --noinput
python manage.py migrate users --noinput
python manage.py migrate meals --noinput
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --no-input 