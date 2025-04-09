FROM python:3.12-slim

# Actualiza e instala Tesseract OCR y dependencias
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo
WORKDIR /app

# Copia el proyecto
COPY . /app

# Instala dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Expone el puerto (por defecto 8000; Railway establecerá $PORT)
EXPOSE 8000

# Inicia la aplicación utilizando la forma shell para CMD
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}

# Forzado para redeploy en Railway

