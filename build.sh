#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Python dependencies
pip install -r requirements.txt

# Run database migrations
echo "Running database migrations..."

# Show current migrations
echo "Current migrations:"
python manage.py showmigrations

# Remove any existing migrations
echo "Removing existing migrations..."
rm -f users/migrations/0*.py
rm -f meals/migrations/0*.py

# Create fresh migrations
echo "Creating fresh migrations..."
python manage.py makemigrations users --noinput
python manage.py makemigrations meals --noinput

# Apply migrations in correct order
echo "Applying migrations..."
python manage.py migrate auth --noinput
python manage.py migrate contenttypes --noinput
python manage.py migrate admin --noinput
python manage.py migrate sessions --noinput
python manage.py migrate users --noinput
python manage.py migrate meals --noinput
python manage.py migrate --noinput

# Show final migrations
echo "Final migrations:"
python manage.py showmigrations

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --no-input 