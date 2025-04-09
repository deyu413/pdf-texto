FROM python:3.12-slim

# Instala Tesseract OCR y dependencias
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

# Instala dependencias Python (incluyendo python-multipart)
RUN pip install --no-cache-dir -r requirements.txt

# Define el puerto por defecto (Railway lo sobrescribirá)
ENV PORT=8000

# Expone el puerto definido en la variable ENV
EXPOSE $PORT

# Usa la variable PORT dinámica (IMPORTANTE: usa shell-form para expandir $PORT)
CMD uvicorn main:app --host 0.0.0.0 --port $PORT