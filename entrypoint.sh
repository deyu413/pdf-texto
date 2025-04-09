#!/bin/sh
# Si PORT no está definida, se usa 8000 por defecto
if [ -z "$PORT" ]; then
  PORT=8000
fi
echo "Starting app on port $PORT"
exec uvicorn main:app --host 0.0.0.0 --port "$PORT"
