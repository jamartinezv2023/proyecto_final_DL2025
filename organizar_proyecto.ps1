<#
Script: organizar_proyecto.ps1
Propósito: Reorganizar el proyecto de Deep Learning para cumplir con la entrega final.
Autor: Asistente IA
Fecha: 2025
#>

Write-Host "=== Organización del Proyecto Deep Learning (Entrega Final) ===" -ForegroundColor Cyan

# --- 1. Verificar directorio actual ---
$repo = Get-Location
Write-Host "Directorio actual: $repo"

# --- 2. Crear estructura de carpetas si no existen ---
$folders = @("notebooks", "data", "models", "docs")

foreach ($folder in $folders) {
    if (-Not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "Carpeta creada: $folder"
    } else {
        Write-Host "Carpeta ya existe: $folder"
    }
}

# --- 3. Mover notebooks principales ---
$notebooks = @{
    "01 - exploración de datos.ipynb" = "notebooks"
    "02 - preprocesado.ipynb" = "notebooks"
    "03 - arquitectura de línea de base.ipynb" = "notebooks"
    "04 - LSTM.ipynb" = "notebooks"
    "05 - sequence models.ipynb" = "notebooks"
    "06 - BERT sentiment analysis.ipynb" = "notebooks"
    "07 - otros_notebooks.ipynb" = "notebooks"
}

foreach ($file in $notebooks.Keys) {
    if (Test-Path $file) {
        Move-Item $file -Destination $notebooks[$file] -Force
        Write-Host "Notebook movido: $file" -ForegroundColor Green
    } else {
        Write-Host "Notebook no encontrado (se omitirá): $file" -ForegroundColor Yellow
    }
}

# --- 4. Mover dataset CSV ---
$dataPath = "international-football-results-from-1872-to-2017"
if (Test-Path $dataPath) {
    Move-Item "$dataPath\*.csv" -Destination "data" -Force
    Write-Host "Datos movidos a /data" -ForegroundColor Green
    
    # Eliminar carpeta si quedó vacía
    Remove-Item $dataPath -Recurse -Force
    Write-Host "Carpeta original de dataset eliminada" -ForegroundColor DarkGray
} else {
    Write-Host "Dataset no encontrado, por favor verifica la ruta." -ForegroundColor Yellow
}

# --- 5. Mover PDFs de entregas ---
if (Test-Path "ENTREGA1.PDF") {
    Move-Item "ENTREGA1.PDF" "docs" -Force
    Write-Host "ENTREGA1 movida a /docs" -ForegroundColor Green
}

# Crear archivo vacío de INFORME_PROYECTO si no existe
$informe = "docs/INFORME_PROYECTO.pdf"
if (-Not (Test-Path $informe)) {
    New-Item -ItemType File -Path $informe | Out-Null
    Write-Host "Plantilla creada: INFORME_PROYECTO.pdf" -ForegroundColor Green
}

# --- 6. Crear README_DATA.md ---
$dataReadme = "data\README_DATA.md"
if (-Not (Test-Path $dataReadme)) {
@"
# Dataset de Resultados de Fútbol Internacional (1872–2017)

Este dataset contiene resultados históricos de partidos internacionales.

## Archivos incluidos:
- results.csv — resultados principales
- goalscorers.csv — goleadores
- shootouts.csv — datos de penales
- former_names.csv — eventos especiales de renombrado

## Fuente:
https://www.kaggle.com/martj42/international-football-results-from-1872-to-2017
"@ | Out-File $dataReadme -Encoding UTF8

    Write-Host "README_DATA.md generado en /data" -ForegroundColor Green
}

# --- 7. Crear requirements.txt automáticamente ---
Write-Host "Generando requirements.txt..." -ForegroundColor Cyan
@"
pandas
numpy
matplotlib
seaborn
scikit-learn
tensorflow
keras
torch
transformers
jupyter
notebook
"@ | Out-File "requirements.txt" -Encoding UTF8
Write-Host "Archivo requirements.txt creado" -ForegroundColor Green

# --- 8. Crear carpetas para modelos ---
if (-Not (Test-Path "models\placeholder.txt")) {
    "Aquí se almacenarán los modelos entrenados (LSTM y Transformer)." |
        Out-File "models\placeholder.txt"
    Write-Host "models/placeholder.txt creado" -ForegroundColor Green
}

# --- 9. Actualizar README.md automáticamente ---
$readmeContent = @"
# Proyecto Final — Deep Learning (2025)

Este repositorio contiene la solución completa del proyecto final de Deep Learning, basado en predicción de resultados de fútbol usando LSTM y Transformers.

### ➤ Contenido
- Exploración de datos
- Preprocesamiento
- Arquitectura base
- Modelo LSTM
- Modelo Transformer
- Informe final
- Video explicativo

### ➤ Video de presentación
(Agrega aquí el enlace de YouTube)

### ➤ Cómo ejecutar
1. Instalar dependencias:
   \`\`\`
   pip install -r requirements.txt
   \`\`\`
2. Abrir los notebooks en Google Colab o Jupyter.

### ➤ Datos
Todos los archivos .csv están en la carpeta **/data**, listos para funcionar en los notebooks.

### ➤ Autores
- José M.
- Equipo de Deep Learning (2025)
"@

$readmeContent | Out-File "README.md" -Encoding UTF8
Write-Host "README.md actualizado" -ForegroundColor Green

# --- 10. Finalización ---
Write-Host "=== Proyecto organizado con éxito ===" -ForegroundColor Cyan
Write-Host "Todo está listo para continuar con notebooks LSTM + Transformer" -ForegroundColor Green
