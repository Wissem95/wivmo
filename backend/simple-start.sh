#!/bin/bash
set -e

echo "🚀 Starting LifeCompanion Backend (Simple Mode)..."

# Wait for database
while ! nc -z postgres 5432; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

echo "✅ Database ready!"

# Install dependencies if vendor is empty
if [ ! -d "vendor" ] || [ -z "$(ls -A vendor)" ]; then
  echo "📦 Installing dependencies..."
  composer install --no-dev --optimize-autoloader
fi

# Generate key if needed
if ! php artisan tinker --execute="echo 'OK';" 2>/dev/null; then
  echo "🔑 Setting up Laravel..."
  php artisan key:generate --force
fi

# Run migrations
echo "🗄️ Running migrations..."
php artisan migrate --force

echo "🎯 Starting PHP server..."
exec php artisan serve --host=0.0.0.0 --port=8000