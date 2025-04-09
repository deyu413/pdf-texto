from fastapi import FastAPI, File, UploadFile
from fastapi.responses import HTMLResponse
import fitz  # PyMuPDF
import pytesseract
from PIL import Image
import io
import os

app = FastAPI()

if not os.path.exists("files"):
    os.makedirs("files")

def ocr_image(image_bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert('L')
    return pytesseract.image_to_string(img)

@app.get("/", response_class=HTMLResponse)
async def main():
    content = """
    <html>
        <head>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f9f9f9;
                    color: #333;
                    padding: 40px;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                }
                h1 {
                    color: #444;
                }
                form {
                    background-color: white;
                    padding: 20px;
                    border-radius: 10px;
                    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                }
                input[type="file"] {
                    padding: 10px;
                    margin-bottom: 10px;
                }
                input[type="submit"] {
                    padding: 10px 20px;
                    background-color: #4CAF50;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                }
                input[type="submit"]:hover {
                    background-color: #45a049;
                }
            </style>
        </head>
        <body>
            <h1>Sube un archivo PDF</h1>
            <form action="/uploadfile/" method="post" enctype="multipart/form-data">
                <input type="file" name="file" accept=".pdf" required />
                <br>
                <input type="submit" value="Subir archivo" />
            </form>
        </body>
    </html>
    """
    return content

@app.post("/uploadfile/")
async def create_upload_file(file: UploadFile = File(...)):
    try:
        file_location = f"files/{file.filename}"
        with open(file_location, "wb") as f:
            f.write(await file.read())

        doc = fitz.open(file_location)
        final_output = ""

        for page_num in range(len(doc)):
            page = doc.load_page(page_num)
            text = page.get_text("text")  # Conserva saltos de línea reales
            images = page.get_images(full=True)

            image_texts = []

            for img_index, img in enumerate(images):
                xref = img[0]
                base_image = doc.extract_image(xref)
                image_bytes = base_image["image"]
                ocr_result = ocr_image(image_bytes).strip()

                if ocr_result:
                    image_texts.append(f"[Texto extraído de imagen en página {page_num + 1}]: {ocr_result}")

            # Añadir texto de página
            page_output = f"\n--- Página {page_num + 1} ---\n{text.strip()}\n"
            # Añadir OCR debajo del texto
            if image_texts:
                page_output += "\n".join(image_texts) + "\n"

            final_output += page_output + "\n"

        html_output = f"""
        <html>
            <head>
                <style>
                    body {{
                        background-color: #f0f0f0;
                        font-family: 'Segoe UI', sans-serif;
                        padding: 30px;
                        color: #222;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                    }}
                    .container {{
                        background-color: white;
                        padding: 20px;
                        border-radius: 10px;
                        width: 90%;
                        max-width: 800px;
                        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                        white-space: pre-wrap;
                        overflow-wrap: break-word;
                    }}
                    h2 {{
                        margin-bottom: 20px;
                    }}
                </style>
            </head>
            <body>
                <h2>Texto extraído del PDF</h2>
                <div class="container">{final_output}</div>
            </body>
        </html>
        """
        return HTMLResponse(content=html_output)

    except Exception as e:
        return HTMLResponse(content=f"<h2>Error procesando el archivo: {str(e)}</h2>")
