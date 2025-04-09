#!/bin/sh
# Si la variable PORT no está definida, usa 8000 como valor por defecto
if [ -z "$PORT" ]; then
    PORT=8000
fi
echo "Iniciando la aplicación en el puerto $PORT"
# Ejecuta uvicorn sin comillas alrededor de $PORT para que se expanda correctamente
exec uvicorn main:app --host 0.0.0.0 --port $PORT
