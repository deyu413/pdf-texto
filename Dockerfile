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

# Instala dependencias (incluyendo python-multipart)
RUN pip install --no-cache-dir -r requirements.txt

# Define el puerto por defecto y expónelo
ENV PORT=8000
EXPOSE $PORT

# Usa shell-form para expandir $PORT correctamente
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT}"]