#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Python dependencies
pip install -r requirements.txt

# Run database migrations
echo "Running database migrations..."

# Initialize database directly
echo "Initializing database..."
python manage.py dbshell << 'EOF'
-- Create users_user table if not exists
CREATE TABLE IF NOT EXISTS users_user (
    id SERIAL PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP WITH TIME ZONE,
    is_superuser BOOLEAN NOT NULL DEFAULT FALSE,
    username VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL,
    is_staff BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    date_joined TIMESTAMP WITH TIME ZONE NOT NULL,
    location VARCHAR(100),
    is_chef BOOLEAN NOT NULL DEFAULT FALSE
);

-- Create users_chefprofile table if not exists
CREATE TABLE IF NOT EXISTS users_chefprofile (
    id SERIAL PRIMARY KEY,
    bio TEXT,
    specialization VARCHAR(100),
    experience_years INTEGER NOT NULL DEFAULT 0,
    profile_picture VARCHAR(100),
    kitchen_license_image VARCHAR(100) NOT NULL,
    bank_details TEXT,
    rating DECIMAL(3,2) NOT NULL DEFAULT 0.0,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER NOT NULL UNIQUE REFERENCES users_user(id) ON DELETE CASCADE
);

-- Create meals_meal table if not exists
CREATE TABLE IF NOT EXISTS meals_meal (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image VARCHAR(100),
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    chef_id INTEGER NOT NULL REFERENCES users_user(id) ON DELETE CASCADE
);

-- Create meals_subscription table if not exists
CREATE TABLE IF NOT EXISTS meals_subscription (
    id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER NOT NULL REFERENCES users_user(id) ON DELETE CASCADE,
    meal_id INTEGER NOT NULL REFERENCES meals_meal(id) ON DELETE CASCADE
);

-- Create meals_payment table if not exists
CREATE TABLE IF NOT EXISTS meals_payment (
    id SERIAL PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    payment_id VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subscription_id INTEGER NOT NULL REFERENCES meals_subscription(id) ON DELETE CASCADE
);

-- Create auth tables if not exists
CREATE TABLE IF NOT EXISTS auth_group (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS auth_permission (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    content_type_id INTEGER NOT NULL,
    codename VARCHAR(100) NOT NULL,
    UNIQUE(content_type_id, codename)
);

CREATE TABLE IF NOT EXISTS auth_user_groups (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users_user(id) ON DELETE CASCADE,
    group_id INTEGER NOT NULL REFERENCES auth_group(id) ON DELETE CASCADE,
    UNIQUE(user_id, group_id)
);

CREATE TABLE IF NOT EXISTS auth_user_user_permissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users_user(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES auth_permission(id) ON DELETE CASCADE,
    UNIQUE(user_id, permission_id)
);

-- Create django tables if not exists
CREATE TABLE IF NOT EXISTS django_content_type (
    id SERIAL PRIMARY KEY,
    app_label VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    UNIQUE(app_label, model)
);

CREATE TABLE IF NOT EXISTS django_session (
    session_key VARCHAR(40) NOT NULL PRIMARY KEY,
    session_data TEXT NOT NULL,
    expire_date TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS django_admin_log (
    id SERIAL PRIMARY KEY,
    action_time TIMESTAMP WITH TIME ZONE NOT NULL,
    object_id TEXT,
    object_repr VARCHAR(200) NOT NULL,
    action_flag SMALLINT NOT NULL,
    change_message TEXT NOT NULL,
    content_type_id INTEGER REFERENCES django_content_type(id) ON DELETE SET NULL,
    user_id INTEGER NOT NULL REFERENCES users_user(id) ON DELETE CASCADE
);

-- Create indexes if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'users_user_username_idx') THEN
        CREATE INDEX users_user_username_idx ON users_user(username);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'users_chefprofile_user_id_idx') THEN
        CREATE INDEX users_chefprofile_user_id_idx ON users_chefprofile(user_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'meals_meal_chef_id_idx') THEN
        CREATE INDEX meals_meal_chef_id_idx ON meals_meal(chef_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'meals_subscription_user_id_idx') THEN
        CREATE INDEX meals_subscription_user_id_idx ON meals_subscription(user_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'meals_subscription_meal_id_idx') THEN
        CREATE INDEX meals_subscription_meal_id_idx ON meals_subscription(meal_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'meals_payment_subscription_id_idx') THEN
        CREATE INDEX meals_payment_subscription_id_idx ON meals_payment(subscription_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'django_session_expire_date_idx') THEN
        CREATE INDEX django_session_expire_date_idx ON django_session(expire_date);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'django_admin_log_content_type_id_idx') THEN
        CREATE INDEX django_admin_log_content_type_id_idx ON django_admin_log(content_type_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'django_admin_log_user_id_idx') THEN
        CREATE INDEX django_admin_log_user_id_idx ON django_admin_log(user_id);
    END IF;
END
$$;

EOF

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