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

# Copia todos los archivos del proyecto
COPY . /app

# Instala dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Define el valor por defecto de PORT (Railway lo sobrescribirá si lo define)
ENV PORT 8000

# Expone el puerto 8000
EXPOSE 8000

# Copia el entrypoint.sh y le da permisos de ejecución
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Establece el entrypoint para iniciar la aplicación
ENTRYPOINT ["/app/entrypoint.sh"]
