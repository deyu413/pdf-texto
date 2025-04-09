document.addEventListener('DOMContentLoaded', () => {
    const form = document.querySelector('form');
    form.addEventListener('submit', (event) => {
        const fileInput = document.querySelector('input[type="file"]');
        if (!fileInput.files.length) {
            alert("Por favor, selecciona un archivo PDF para subir.");
            event.preventDefault();
        }
    });
});
