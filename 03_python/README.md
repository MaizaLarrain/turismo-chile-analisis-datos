# Turismo receptivo en Chile: cuánto depende el país de Argentina y quién explica el crecimiento de 2025 y la caída de 2026

Proyecto de análisis en Python (pandas, NumPy y matplotlib) con datos oficiales del SIET (Sernatur). Caso simulado: soy analista de datos de un hotel urbano de tamaño medio y debo ayudar a presupuestar y a planificar las campañas de venta del próximo año.

## Pregunta
¿Cuánto depende el turismo en Chile de Argentina, quién explica el crecimiento de 2025 y la caída de 2026, y con qué rango conviene presupuestar 2026?

## Resultado principal
Argentina explica casi toda la historia: aportó el 100,4 % del aumento de 2025 (+768.052 de +765.334 llegadas) y explica el 109,9 % de la caída de enero-julio de 2026 (-766.959 de -698.090 llegadas; -39,7 % en su flujo). Pasa de 100 % porque el resto del mundo creció y compensó una parte. Su peso en las llegadas subió de 32,1 % en 2022 a 47,6 % en 2025. Sin Argentina, las llegadas se mantienen en 2025 (-0,1 % en el año completo; +0,7 % en enero-julio) y crecen +4,0 % en enero-julio de 2026, con mejora en 5 de los 7 meses. En tres escenarios ilustrativos (no es un pronóstico), 2026 cerraría entre 4,88 y 5,10 millones de llegadas, entre 15,1 % y 18,7 % menos que en 2025.

## Qué contiene
- `turismo_chile_dependencia_y_coyuntura.ipynb`: notebook ejecutado, con controles de calidad al inicio, 9 celdas de código y 4 gráficos. GitHub lo muestra directamente.
- `cells_notebook.py`: el código y los textos de las celdas del notebook.
- `ejecutar_notebook.py`: ejecuta las celdas y regenera el notebook con las salidas reales.
- `respuestas.md` y `recomendaciones.md`: textos de las respuestas al encargo y de las recomendaciones que se insertan en las secciones 8 y 9 del notebook.
- `requirements.txt`: librerías necesarias (pandas, numpy y matplotlib).
- `../datos_oficiales/siet/llegadas_nacionalidad_mes_largo.csv`: llegadas por nacionalidad y mes desde 2008 (SIET, Sernatur).
- `../datos_oficiales/siet/leer_siet.py`: lee el Excel oficial del SIET y lo pasa a formato largo.

## Qué demuestra
- pandas: carga, limpieza y controles. Lectura de un Excel oficial, paso a formato largo y conciliación con los totales oficiales de 2017 y de 2022 a 2025 y con el acumulado de enero a mayo de 2026.
- Descomposición del crecimiento: aporte de cada país al cambio anual y al de enero-julio.
- Series de tiempo mensuales: variación interanual mes a mes de Argentina y del resto.
- Estacionalidad: índice estacional y correlación entre los calendarios de dos grupos de mercados.
- Escenarios de sensibilidad con dos componentes y supuestos explícitos.
- Gráficos con matplotlib y un notebook reproducible, con los hallazgos calculados por código.

## Cómo reproducirlo
Requisitos: Python 3 y las librerías pandas, numpy y matplotlib. Para abrir el notebook en Visual Studio Code también hacen falta las extensiones Python y Jupyter y la librería ipykernel.
1. Clonar el repositorio.
2. Entrar a la carpeta `03_python` e instalar las librerías: `python -m pip install -r requirements.txt`
3. Abrir `turismo_chile_dependencia_y_coyuntura.ipynb` y ejecutar las celdas en orden. Hay que abrirlo desde dentro de `03_python`, porque lee los datos con la ruta `../datos_oficiales/`.
4. Opcional: ejecutar `python ejecutar_notebook.py final` para regenerar el notebook con las respuestas y las recomendaciones finales (sin la palabra `final`, las secciones 8 y 9 quedan con el texto "(pendiente)").
5. Opcional, para usar Google Colab: en una celda ejecutar `!git clone https://github.com/TU_USUARIO/turismo-chile-analisis-datos.git`, luego `%cd turismo-chile-analisis-datos/03_python` y después `!pip install -r requirements.txt`. Sin clonar el repositorio, el notebook no encuentra la carpeta `datos_oficiales`.

## Datos
- Llegadas de turistas extranjeros por nacionalidad y mes, de 2008 a julio de 2026: archivo "Cuadros de llegadas de turistas extranjeros" del SIET, Sernatur (publicación de agosto de 2026). Cifras preliminares desde julio de 2020. Incluyen chilenos residentes en el exterior. Son 152 categorías de nacionalidad (incluye 9 categorías "O. ..." y Chile), más 9 agrupaciones por continente y el total general.
- Totales anuales oficiales de 2017 y de 2022 a 2025: comunicados de la Subsecretaría de Turismo.
- El Excel original del SIET no está en el repositorio. Para repetir la lectura con `leer_siet.py`, hay que descargarlo desde Sernatur y dejarlo junto al script; los CSV ya generados permiten ejecutar el notebook sin él.
- "Resto" significa todo menos Argentina (incluye Brasil y Bolivia).

## Límites
- Muestra cuánto y cuándo cayó cada país, no por qué. Explicar la caída de Argentina requiere información externa (tipo de cambio, conectividad).
- 2026 llega solo hasta julio: los escenarios suponen un comportamiento de agosto a diciembre que no se conoce.
- El índice estacional usa 3 años completos (2023-2025), con 2023 todavía en recuperación.
- Los escenarios son un ejercicio simple, no un pronóstico.
- Las llegadas incluyen chilenos residentes en el exterior y son preliminares desde julio de 2020.

## Autora
Paula Maiza Rivera Larrain · Analista de datos junior · [LinkedIn](https://www.linkedin.com/in/paula-ma%C3%ADza-rivera-larrain-9719a428b/)
