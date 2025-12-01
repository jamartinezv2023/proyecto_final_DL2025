<# 
 Script: preparar_entrega_final.ps1
 Objetivo: Dejar el proyecto listo para la entrega final (estructura, docs, checklist).
 Debe ejecutarse desde la raíz del repo: C:\Deeplearning\proyecto_final_DL2025
#>

$ErrorActionPreference = "Stop"

Write-Host "=== Organización del Proyecto Deep Learning (Entrega Final) ===" -ForegroundColor Cyan

# 1. Detectar raíz del proyecto
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root
Write-Host "Directorio actual: $Root"

# 2. Crear estructura de carpetas
$dirs = @("notebooks","data","models","docs")
foreach ($d in $dirs) {
    $full = Join-Path $Root $d
    if (-not (Test-Path $full)) {
        New-Item -ItemType Directory -Path $full | Out-Null
        Write-Host "Carpeta creada: $d"
    } else {
        Write-Host "Carpeta ya existe: $d"
    }
}

# 3. Asegurar que notebooks 01-07 estén en /notebooks
$notebookNames = @(
    "01 - exploración de datos.ipynb",
    "02 - preprocesado.ipynb",
    "03 - arquitectura de línea de base.ipynb",
    "04 - LSTM.ipynb",
    "05 - sequence models.ipynb",
    "06 - BERT sentiment analysis.ipynb",
    "07 - otros_notebooks.ipynb"
)

$notebooksOk = $true

foreach ($nb in $notebookNames) {
    $inRoot = Join-Path $Root $nb
    $inNotebooks = Join-Path (Join-Path $Root "notebooks") $nb

    if (Test-Path $inRoot) {
        Move-Item $inRoot $inNotebooks -Force
        Write-Host "Notebook movido a /notebooks: $nb"
    } elseif (Test-Path $inNotebooks) {
        Write-Host "Notebook ya está en /notebooks: $nb"
    } else {
        Write-Warning "Notebook no encontrado (revisa nombre): $nb"
        $notebooksOk = $false
    }
}

# 4. Mover dataset de fútbol a /data
$dataFolder = Join-Path $Root "international-football-results-from-1872-to-2017"
$dataTarget = Join-Path $Root "data"

if (Test-Path $dataFolder) {
    Get-ChildItem $dataFolder -Filter "*.csv" | ForEach-Object {
        Move-Item $_.FullName $dataTarget -Force
        Write-Host "CSV movido a /data: $($_.Name)"
    }
    Remove-Item $dataFolder -Recurse -Force
    Write-Host "Carpeta original de dataset eliminada"
} else {
    Write-Host "Dataset ya estaba organizado en /data o carpeta original no existe."
}

# 5. Verificar ENTREGA1.PDF en /docs
$entrega1Src = Join-Path $Root "ENTREGA1.PDF"
$entrega1Dst = Join-Path (Join-Path $Root "docs") "ENTREGA1.PDF"
$entrega1Ok = $false

if (Test-Path $entrega1Src) {
    Move-Item $entrega1Src $entrega1Dst -Force
    Write-Host "ENTREGA1.PDF movida a /docs"
    $entrega1Ok = $true
} elseif (Test-Path $entrega1Dst) {
    Write-Host "ENTREGA1.PDF ya está en /docs"
    $entrega1Ok = $true
} else {
    Write-Warning "ENTREGA1.PDF no encontrada. Asegúrate de copiarla a /docs."
}

# 6. Generar plantilla LaTeX INFORME_PROYECTO.tex en /docs
$informeTex = Join-Path (Join-Path $Root "docs") "INFORME_PROYECTO.tex"

if (-not (Test-Path $informeTex)) {
    $latex = @"
% File: docs/INFORME_PROYECTO.tex
\documentclass[11pt,a4paper]{article}

\usepackage[spanish]{babel}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{amsmath,amsfonts,amssymb}
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{booktabs}
\usepackage{geometry}
\geometry{margin=2.5cm}

\title{Predicción de resultados de fútbol internacional \\ usando modelos LSTM y Transformers}
\author{José A. Martínez V.}
\date{\today}

\begin{document}
\maketitle

\begin{abstract}
En este informe se describe el desarrollo de un sistema de predicción de resultados de partidos internacionales de fútbol
utilizando técnicas de \emph{deep learning}. Se emplea el dataset público \textit{international football results from 1872 to 2017},
y se construyen modelos basados en LSTM y Transformers. Se presentan las decisiones de preprocesado, las arquitecturas,
las métricas de desempeño y una breve discusión de los resultados.
\end{abstract}

\section{Contexto de aplicación}
% Explicar por qué predecir resultados de fútbol es relevante:
% apuestas deportivas, análisis de rendimiento, planificación de partidos, etc.
% Mencionar brevemente que se usa un dataset histórico con partidos de selecciones nacionales.

\section{Objetivo de \textit{machine learning}}
% Formular el problema:
% Dado el historial reciente de partidos de dos selecciones (y atributos derivados),
% predecir el resultado del próximo partido (victoria local, empate, victoria visitante).
% Explicar las variables de entrada de forma conceptual (no código).

\section{Descripción del dataset}
% Describir:
% - Fuente del dataset (Kaggle / repositorio público).
% - Ficheros utilizados (results.csv, goalscorers.csv, etc.).
% - Número de partidos, rango temporal (1872-2017).
% - Cómo se construyen las clases (local gana / empate / visita gana).
% - Distribución aproximada de las clases (porcentaje de cada categoría).

\section{Preprocesado de datos}
% Describir los pasos clave:
% - Limpieza de duplicados o partidos no válidos.
% - Selección de variables relevantes (equipos, fecha, marcador, torneo, lugar).
% - Codificación de equipos (por ejemplo, embeddings o one-hot).
% - Construcción de secuencias temporales para cada selección (ventanas de N partidos).
% - División train/validation/test respetando el orden temporal.

\section{Modelos propuestos}
\subsection{Modelo de línea de base}
% Describir un modelo simple (por ejemplo, regresión logística o red densa)
% que sirva como referencia.

\subsection{Modelo LSTM}
% Describir la arquitectura LSTM:
% - Dimensión de los embeddings.
% - Número de capas LSTM.
% - Capas densas finales.
% - Función de pérdida, optimizador y número de épocas.
% Comentar brevemente por qué LSTM es adecuado para series temporales.

\subsection{Modelo Transformer}
% Describir la arquitectura Transformer o modelo basado en atención:
% - Codificación posicional.
% - Capas de atención multi-cabeza.
% - Capas feed-forward.
% - Parámetros principales (número de capas, cabezas, etc.).
% Comentar brevemente por qué la atención puede capturar dependencias de largo plazo.

\section{Métricas de desempeño}
% Indicar las métricas utilizadas:
% - Exactitud (accuracy).
% - Matriz de confusión.
% - En caso de clases desbalanceadas, F1-score macro o ponderado.
% Justificar por qué estas métricas son relevantes para el problema de negocio.

\section{Resultados experimentales}
% Presentar tablas y/o figuras:
% - Resultados del modelo base.
% - Resultados del LSTM.
% - Resultados del Transformer.
% Comparar y discutir:
% - ¿Cuál modelo funciona mejor?
% - ¿Sobreajuste? (diferencias train/val).
% - ¿Limitaciones del enfoque?

\section{Discusión y trabajo futuro}
% Comentar:
% - Limitaciones de los datos (calidad, sesgos, cambios en el fútbol moderno, etc.).
% - Posibles mejoras: más variables, ajuste de hiperparámetros, modelos híbridos, etc.
% - Cómo se podría utilizar este sistema en un contexto real.

\section*{Referencias}
% Añadir referencias principales (formato libre o BibTeX resumido):
% - Goodfellow et al. (2016) Deep Learning.
% - Hochreiter \& Schmidhuber (1997) Long Short-Term Memory.
% - Vaswani et al. (2017) Attention is All You Need.
% - Documentación de Keras/TensorFlow utilizada.

\end{document}
"@

    $latex | Out-File -FilePath $informeTex -Encoding UTF8
    Write-Host "Plantilla LaTeX creada: docs/INFORME_PROYECTO.tex"
} else {
    Write-Host "INFORME_PROYECTO.tex ya existe, no se sobrescribe."
}

# 7. requirements.txt (mínimo para Colab)
$reqFile = Join-Path $Root "requirements.txt"
if (-not (Test-Path $reqFile)) {
    $req = @"
numpy
pandas
matplotlib
seaborn
scikit-learn
tensorflow
keras
torch
transformers
"@
    $req | Out-File -FilePath $reqFile -Encoding UTF8
    Write-Host "requirements.txt creado con librerías básicas."
} else {
    Write-Host "requirements.txt ya existe, revísalo y ajusta versiones si hace falta."
}

# 8. Crear presentación PowerPoint con notas (si PowerPoint está disponible)
$pptOk = $false
$docsDir = Join-Path $Root "docs"
$pptPath = Join-Path $docsDir "presentacion_proyecto.pptx"
$notesTxt = Join-Path $docsDir "presentacion_proyecto_notas.txt"

try {
    $pp = New-Object -ComObject PowerPoint.Application
    $pp.Visible = 1
    $pres = $pp.Presentations.Add()

    # Slide 1 - Título
    $slide1 = $pres.Slides.Add(1,1)   # 1 = ppLayoutTitle
    $slide1.Shapes.Item(1).TextFrame.TextRange.Text = "Predicción de resultados de fútbol"
    $slide1.Shapes.Item(2).TextFrame.TextRange.Text = "LSTM + Transformer - Proyecto Final"
    $slide1.NotesPage.Shapes.Item(2).TextFrame.TextRange.Text = @"
Presentación del proyecto final de Deep Learning.
Nombre del estudiante, curso, año.
Objetivo: explicar datos, modelos (LSTM y Transformer) y resultados.
"@

    # Slide 2 - Datos
    $slide2 = $pres.Slides.Add(2,1)
    $slide2.Shapes.Item(1).TextFrame.TextRange.Text = "Datos"
    $slide2.Shapes.Item(2).TextFrame.TextRange.Text = "Dataset: international football results (1872-2017)"
    $slide2.NotesPage.Shapes.Item(2).TextFrame.TextRange.Text = @"
Explicar brevemente el dataset:
- Partidos internacionales de selecciones nacionales.
- Rango de años.
- Variables clave: equipos, marcador, torneo, local/visitante, etc.
Comentar por qué estos datos son adecuados para el problema.
"@

    # Slide 3 - Preprocesado
    $slide3 = $pres.Slides.Add(3,1)
    $slide3.Shapes.Item(1).TextFrame.TextRange.Text = "Preprocesado"
    $slide3.Shapes.Item(2).TextFrame.TextRange.Text = "Limpieza + construcción de secuencias"
    $slide3.NotesPage.Shapes.Item(2).TextFrame.TextRange.Text = @"
Explicar:
- Limpieza básica (duplicados, valores faltantes).
- Construcción de secuencias por selección (últimos N partidos).
- Codificación de equipos (embeddings / one-hot).
- División train/valid/test respetando el tiempo.
"@

    # Slide 4 - Modelo LSTM
    $slide4 = $pres.Slides.Add(4,1)
    $slide4.Shapes.Item(1).TextFrame.TextRange.Text = "Modelo LSTM"
    $slide4.Shapes.Item(2).TextFrame.TextRange.Text = "Arquitectura y entrenamiento"
    $slide4.NotesPage.Shapes.Item(2).TextFrame.TextRange.Text = @"
Describir:
- Capas LSTM usadas.
- Dimensión de las entradas (features por partido).
- Capas densas finales y función de activación.
- Epochs, batch size, optimizador.
Mostrar (en el video) cómo se entrena en el notebook 04 - LSTM.ipynb.
"@

    # Slide 5 - Modelo Transformer
    $slide5 = $pres.Slides.Add(5,1)
    $slide5.Shapes.Item(1).TextFrame.TextRange.Text = "Modelo Transformer"
    $slide5.Shapes.Item(2).TextFrame.TextRange.Text = "Atención para series temporales"
    $slide5.NotesPage.Shapes.Item(2).TextFrame.TextRange.Text = @"
Explicar:
- Idea de la atención y la posición en la secuencia.
- Arquitectura simplificada que has implementado.
- Comparación conceptual con LSTM (paralelismo, dependencias de largo plazo).
Mostrar su notebook (p.ej. 05 - sequence models.ipynb adaptado).
"@

    # Slide 6 - Resultados
    $slide6 = $pres.Slides.Add(6,1)
    $slide6.Shapes.Item(1).TextFrame.TextRange.Text = "Resultados"
    $slide6.Shapes.Item(2).TextFrame.TextRange.Text = "Métricas y comparación"
    $slide6.NotesPage.Shapes.Item(2).TextFrame.TextRange.Text = @"
Comentar:
- Accuracy de la línea base.
- Accuracy (y otras métricas) del LSTM.
- Accuracy del Transformer.
- Qué modelo funciona mejor y por qué.
- Alguna limitación o posible mejora.
"@

    # Slide 7 - Conclusiones
    $slide7 = $pres.Slides.Add(7,1)
    $slide7.Shapes.Item(1).TextFrame.TextRange.Text = "Conclusiones"
    $slide7.Shapes.Item(2).TextFrame.TextRange.Text = "Resumen y trabajo futuro"
    $slide7.NotesPage.Shapes.Item(2).TextFrame.TextRange.Text = @"
Resumen:
- Qué problema has resuelto.
- Qué aprendiste de los datos.
- Qué modelo recomendarías.
Trabajo futuro:
- Más features (ranking FIFA, alineaciones, etc.).
- Más ajustes de hiperparámetros o arquitecturas.
Agradecer al profesor y cerrar el video.
"@

    $pres.SaveAs($pptPath)
    $pres.Close()
    $pp.Quit()
    Write-Host "Presentación PowerPoint creada: docs/presentacion_proyecto.pptx"
    $pptOk = $true
} catch {
    Write-Warning "No se pudo crear la presentación en PowerPoint (¿Office no instalado?). Se generará un archivo de notas."
    $notes = @"
Presentación del proyecto (guion para el video)
==============================================

1. Título y presentación
- Nombre, curso, proyecto.
- Problema: predicción de resultados de fútbol con LSTM + Transformer.

2. Datos
- Describir dataset (results.csv, años, número de partidos).
- Variables principales.

3. Preprocesado
- Limpieza, construcción de secuencias, división train/valid/test.

4. Modelo LSTM
- Arquitectura básica.
- Cómo se entrena (notebook 04 - LSTM.ipynb).
- Métricas principales.

5. Modelo Transformer
- Idea de la atención.
- Arquitectura implementada.
- Métricas principales.

6. Resultados y comparación
- Comparar línea base, LSTM y Transformer.
- Comentar fortalezas y debilidades.

7. Conclusiones
- Qué aprendiste.
- Posibles mejoras futuras.
"@
    $notes | Out-File -FilePath $notesTxt -Encoding UTF8
    Write-Host "Notas de presentación creadas: docs/presentacion_proyecto_notas.txt"
}

# 9. Actualizar README.md con secciones clave
$readmePath = Join-Path $Root "README.md"
if (-not (Test-Path $readmePath)) {
    New-Item -ItemType File -Path $readmePath | Out-Null
}

$readmeContent = Get-Content $readmePath -Raw

if ($readmeContent -notmatch "## Estructura del repositorio") {
    $append = @"

## Estructura del repositorio

- \`notebooks/\`
  - \`01 - exploración de datos.ipynb\`
  - \`02 - preprocesado.ipynb\`
  - \`03 - arquitectura de línea de base.ipynb\`
  - \`04 - LSTM.ipynb\`
  - \`05 - sequence models.ipynb\` (adaptado a Transformer)
  - \`06 - BERT sentiment analysis.ipynb\` (opcional / otros modelos)
  - \`07 - otros_notebooks.ipynb\` (experimentos extra)
- \`data/\`: ficheros CSV del dataset de fútbol internacional.
- \`models/\`: modelos entrenados guardados (LSTM, Transformer, etc.).
- \`docs/\`: \`ENTREGA1.PDF\`, \`INFORME_PROYECTO.tex\` y \`INFORME_PROYECTO.PDF\`.

## Cómo ejecutar los notebooks en Google Colab

1. Sube este repositorio a tu cuenta de GitHub.
2. Abre cada notebook en Colab usando la opción \`Open in Colab\` o pegando la URL del notebook.
3. Ejecuta las celdas de arriba a abajo.
4. Asegúrate de que:
   - Los paths a \`data/\` son correctos.
   - El entrenamiento de los modelos LSTM y Transformer se ejecuta sin errores.

## Video de presentación

Incluye aquí el enlace a tu video en YouTube (5-10 minutos):

- Video: https://youtu.be/TU_ENLACE_AQUI

"@
    Add-Content -Path $readmePath -Value $append
    Write-Host "README.md actualizado con estructura, ejecución y enlace de video."
} else {
    Write-Host "README.md ya contiene sección de estructura. Revísalo y actualiza el enlace de YouTube."
}

# 10. Checklist final

Write-Host ""
Write-Host "=== CHECKLIST ENTREGA FINAL ===" -ForegroundColor Yellow

if ($notebooksOk) {
    Write-Host "[OK] Notebooks 01-07 encontrados en /notebooks" -ForegroundColor Green
} else {
    Write-Warning "[WARNING] Faltan uno o más notebooks en /notebooks. Revisa nombres y rutas."
}

if ($entrega1Ok) {
    Write-Host "[OK] ENTREGA1.PDF presente en /docs" -ForegroundColor Green
} else {
    Write-Warning "[WARNING] ENTREGA1.PDF no está en /docs"
}

if (Test-Path $informeTex) {
    Write-Host "[OK] Plantilla INFORME_PROYECTO.tex generada en /docs (recuerda compilar a PDF)" -ForegroundColor Green
} else {
    Write-Warning "[WARNING] Falta INFORME_PROYECTO.tex en /docs"
}

if ($pptOk) {
    Write-Host "[OK] Presentación PowerPoint creada en /docs" -ForegroundColor Green
} else {
    Write-Host "[INFO] Usa docs/presentacion_proyecto_notas.txt como guion para tu video." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Ahora te falta:" -ForegroundColor Cyan
Write-Host " - Ajustar y ejecutar los notebooks (01-05) en Colab sin errores."
Write-Host " - Completar INFORME_PROYECTO.tex con tus resultados y compilar a PDF."
Write-Host " - Grabar el video, subirlo a YouTube y poner el enlace en README.md."
Write-Host ""
Write-Host "=== Proyecto organizado y checklist generado ===" -ForegroundColor Cyan
