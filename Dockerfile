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

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Define PORT como 8000 por defecto (Railway lo sobrescribirá si lo define)
ENV PORT 8000

# Expone el puerto 8000
EXPOSE 8000

# Usa el entrypoint para iniciar la aplicación
ENTRYPOINT ["/app/entrypoint.sh"]
