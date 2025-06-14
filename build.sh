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

# Remove old migrations
echo "Removing old migrations..."
rm -rf users/migrations/0*.py
rm -rf meals/migrations/0*.py

# Create fresh migrations for PostgreSQL
echo "Creating fresh migrations..."
python manage.py makemigrations users --noinput
python manage.py makemigrations meals --noinput

# Apply migrations
echo "Applying migrations..."
python manage.py migrate --noinput

# Create superuser if it doesn't exist
echo "Creating superuser..."
python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
EOF

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --no-input 