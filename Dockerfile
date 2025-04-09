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

# Copia todos los archivos del proyecto a la imagen
COPY . /app

# Instala dependencias Python (incluyendo python-multipart y demás)
RUN pip install --no-cache-dir -r requirements.txt

# Define el valor por defecto de PORT (Railway lo sobrescribirá si provee uno)
ENV PORT 8000

# Expone el puerto (por defecto 8000)
EXPOSE 8000

# Inicia la aplicación utilizando la forma shell para CMD y así expandir la variable PORT
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT}"]
