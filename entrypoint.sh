#!/bin/sh

echo "🕓 Esperando o banco subir..."

# Loop para aguardar o banco estar disponível
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME"; do
  echo "⏳ Banco ainda não está pronto... tentando de novo..."
  sleep 2
done

echo "🎉 Banco conectado com sucesso!"

echo "🚀 Rodando migrations..."
php artisan migrate --force

echo "🔥 Iniciando Laravel..."
php artisan serve --host=0.0.0.0 --port=8000
