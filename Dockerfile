FROM python:3.12-slim

# Actualiza e instala Tesseract OCR y sus dependencias
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

# Instala dependencias Python
RUN pip install --no-cache-dir -r requirements.txt

# Define PORT por defecto (Railway la sobrescribirá)
ENV PORT 8000

# Expone el puerto
EXPOSE 8000

# Copia el entrypoint script y lo hace ejecutable
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Usa el entrypoint para iniciar la aplicación
ENTRYPOINT ["/app/entrypoint.sh"]
