# 📘 Proyecto Final – Deep Learning 2025  
## Predicción de Resultados Deportivos mediante Modelos Secuenciales (LSTM y Transformer)

**Universidad de Antioquia – Facultad de Ingeniería**  
**Ingeniería de Sistemas – Fundamentos de Deep Learning**  
**Autor:** José Alfredo Martínez Valdés  
**Correo:** jose.martinez7@udea.edu.co  
**Año:** 2025  

---

## 📝 Descripción General

Este proyecto implementa un sistema completo de **Deep Learning aplicado a series temporales deportivas**, cuyo objetivo es **predecir el resultado del próximo partido del equipo local** (victoria, empate o derrota).  

Se exploran y comparan arquitecturas modernas de aprendizaje profundo:

- **LSTM (Long Short-Term Memory)**  
- **Transformer (Self-Attention)**  

El proyecto cumple todos los requisitos de la asignatura:

✔ Notebooks reproducibles  
✔ Informes PDF (Entrega 1 y Final)  
✔ Video explicativo en YouTube  
✔ Pipeline organizado y estructurado  
✔ Código modular y limpio  

---

# 📂 Estructura del Repositorio

proyecto_final_DL2025/
│
├── data/ # Datos crudos y procesados (NO versionados)
│
├── models/ # Modelos entrenados (checkpoints, .h5, .pth)
│
├── notebooks/ # Notebooks reproducibles y numerados
│ ├── 01_exploracion_datos.ipynb
│ ├── 02_preprocesamiento.ipynb
│ ├── 03_baseline.ipynb
│ ├── 04_LSTM.ipynb
│ ├── 05_Transformer.ipynb
│ └── 06_iteraciones_experimentales.ipynb
│
├── src/
│ ├── dataset.py
│ ├── train.py
│ ├── evaluate.py
│ ├── model_lstm.py
│ ├── model_transformer.py
│ └── utils.py
│
├── docs/
│ ├── ENTREGA1.pdf
│ ├── INFORME_PROYECTO.pdf
│ └── presentacion_proyecto.pptx (ignorado por .gitignore)
│
├── requirements.txt
└── README.md

yaml
Copiar código

---

# 🧾 Cumplimiento de Requisitos

### ✔ 1. Notebooks reproducibles  
Ordenados y preparados para ejecutarse en Google Colab:

1. Exploración de datos  
2. Preprocesamiento  
3. Baseline  
4. Modelo LSTM  
5. Modelo Transformer  
6. Iteraciones experimentales

### ✔ 2. Informes PDF incluidos
- `ENTREGA1.pdf`  
- `INFORME_PROYECTO.pdf`

### ✔ 3. Video explicativo del proyecto  
Incluye recorrido por los notebooks, análisis del dataset, entrenamiento de modelos y conclusiones.

🔗 **Enlace al video en YouTube:** 
 
👉 https://youtu.be/3QCbO28zlaQ
*(Reemplazar con el enlace real)*

---

# 📊 Dataset Utilizado

### ● Origen  
Historial de resultados de fútbol profesional.

### ● Dimensión  
Entre **7.000 y 8.000 partidos** tras limpieza.

### ● Variables principales  
- Fecha del partido  
- Equipo local y visitante  
- Goles anotados y recibidos  
- Resultado categórico  
- Diferencia de goles  
- Secuencias temporales de longitud **k**  

### ● Distribución del objetivo  
- Victoria: ~43%  
- Empate: ~27%  
- Derrota: ~30%  

---

# 🔧 Instalación del Proyecto

### 1. Crear entorno virtual
```bash
python -m venv venv
source venv/bin/activate       # Linux/Mac
venv\Scripts\activate          # Windows
2. Instalar dependencias
bash
Copiar código
pip install -r requirements.txt
🚀 Ejecución del Proyecto
Preprocesamiento de datos
bash
Copiar código
python src/dataset.py
Entrenamiento (ejemplo)
bash
Copiar código
python src/train.py --model lstm --epochs 40 --batch-size 32
Evaluación del modelo
bash
Copiar código
python src/evaluate.py --model models/best_model.pth
📈 Resultados Principales
Desempeño representativo:

Modelo	Accuracy	Precisión Macro	F1 Macro
Baseline	0.45	0.41	0.39
LSTM	0.57	0.55	0.53
Transformer	0.61	0.59	0.58

El modelo Transformer logró el mejor desempeño general.

Incluye visualizaciones:

Curvas de entrenamiento

Matrices de confusión

Comparación entre arquitecturas

Análisis de errores por clase

🧠 Consideraciones Técnicas
Secuencias temporales creadas a partir de los últimos k partidos

División temporal (train/val/test) para evitar fuga de información

Regularización: dropout + early stopping

Optimizador Adam

Métricas macro por desbalance de clases

Código modular para facilitar la experimentación

👨‍💻 Autor
José Alfredo Martínez Valdés
Ingeniería de Sistemas — Universidad de Antioquia
2025

