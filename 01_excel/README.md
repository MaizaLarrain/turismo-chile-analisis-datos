# Turismo receptivo en Chile: quién explica el crecimiento de 2025 y la caída de 2026

Proyecto de análisis en Excel (fórmulas, Power Query, tablas dinámicas y macro VBA) con datos oficiales del SIET (Sernatur). Caso simulado: soy analista de datos de un tour operador receptivo y debo ayudar a fijar cupos y a contratar guías para el próximo año.

## Pregunta
¿Cómo cambia la demanda durante el año, qué mercados explican el crecimiento de 2025 y la caída de 2026, y qué cierre de 2026 es razonable esperar bajo distintos escenarios?

## Resultado principal
Argentina explica casi toda la historia: aportó el 100,4 % del aumento de 2025 (+768.052 de +765.334 llegadas) y el 109,9 % de la caída de enero-julio de 2026 (-766.959 de -698.090 llegadas; -39,7 % en su flujo). Sin Argentina, enero-julio de 2026 sube +4,0 % frente a 2025. Contra 2024, el total acumulado también sube +4,0 %: la caída es respecto de un 2025 excepcional, pero desde marzo Argentina está 26,5 % bajo su nivel de 2024. En tres escenarios ilustrativos (no es un pronóstico), 2026 cerraría entre 4,88 y 5,12 millones de llegadas, entre 15 % y 19 % menos que en 2025.

## Qué contiene
- `Turismo_Chile_coyuntura_y_mercados_para_publicar.xlsx`: el archivo principal. 7 hojas con solo fórmulas (Inicio, Datos, Estacionalidad, Coyuntura, Mercados, Resumen y Escenarios). Abre sin macros ni avisos de seguridad.
- `Turismo_Chile_coyuntura_y_mercados_(TD_QUERY)_para_publicar.xlsx`: lo anterior más las hojas Series_ancho y PQ_Series (Power Query) y TDSeries (tablas dinámicas con segmentaciones y escala de tiempo).
- `Turismo_Chile_coyuntura_y_mercados (Macros)_para_publicar.xlsm`: la versión completa, con la macro y el botón "Actualizar y exportar".
- `Macro_Actualizar_y_Exportar_Resumen.txt`: el código VBA de la macro, para leerlo sin abrir Excel.
- `Resumen_turismo.pdf`: el Resumen exportado por la macro (respuestas, recomendaciones, explorador y gráfico).
- `series_excel_2022_2026.csv`: 660 filas, 12 series por 55 meses (enero de 2022 a julio de 2026), preparadas a partir del SIET.
- `capturas/`: imágenes de Power Query, de las tablas dinámicas y de la macro.
- `../datos_oficiales/`: CSV del SIET (Sernatur) y otros datos de origen.

## Qué demuestra
- SUMIFS, COUNTIFS y AVERAGEIFS con varios criterios, y SUMPRODUCT (con LARGE), sobre una tabla de Excel con nombres definidos.
- Aporte al cambio total, índice estacional por mercado, concentración (participación de los tres primeros mercados e índice HHI) y modelado de tres escenarios con supuestos editables.
- INDEX/MATCH, IF y RANK; formato condicional, validación de datos (mes de corte editable y explorador por país y año) y 5 controles automáticos contra totales oficiales, que muestran "REVISAR" si una suma deja de calzar.
- Power Query (limpieza y columna de trimestre), tablas dinámicas con segmentaciones y escala de tiempo, y una macro VBA que actualiza el libro, revisa los controles y exporta el Resumen a PDF.

## Cómo usarlo
Requisito: Excel de escritorio (Windows). Las hojas de fórmulas también se ven en otras versiones de Excel, pero Power Query y la macro pueden no funcionar.
1. Descargar o clonar el repositorio y abrir la carpeta `01_excel`.
2. Abrir `Turismo_Chile_coyuntura_y_mercados_para_publicar.xlsx` y revisar las hojas Resumen y Escenarios. El mes de corte se cambia en `Coyuntura!B4`.
3. Para ver las tablas dinámicas y Power Query, abrir el archivo `(TD_QUERY)`.
4. Para probar la macro, abrir el archivo `(Macros)`, pulsar "Habilitar contenido" y usar el botón "Actualizar y exportar" de la hoja Resumen. Si los controles no coinciden, no exporta el PDF. El PDF se guarda junto al libro, con el nombre `Resumen_turismo.pdf`.
5. Si la actualización de Power Query falla en tu computador, cambiar el parámetro `RutaCSV` por la ruta completa de `series_excel_2022_2026.csv`: Datos > Obtener datos > Iniciar el editor de Power Query > RutaCSV > Valor actual.

Las fórmulas del libro están en inglés y con comas. En un Excel en español se escriben con punto y coma y con otros nombres (por ejemplo, SUMIFS es SUMAR.SI.CONJUNTO y SUMPRODUCT es SUMAPRODUCTO).

## Datos
- Llegadas de turistas internacionales por nacionalidad y mes: SIET, Sernatur (publicación de agosto de 2026). Cifras preliminares desde julio de 2020. Incluyen chilenos residentes en el exterior.
- Totales oficiales para los controles: comunicados de la Subsecretaría de Turismo y SIET (totales de 2022 a 2025 y acumulado de enero a mayo de 2026).
- "Resto del mundo" es el total general menos las 11 series nombradas. Por eso los controles verifican los totales, no el reparto por país.

## Límites
- Muestra cuánto y cuándo cayó cada país, no por qué. No se probaron causas (tipo de cambio, economía de Argentina, cierres de pasos).
- 2026 llega solo hasta julio, y el control contra el total oficial de 2026 llega solo hasta mayo.
- Las llegadas son un indicador de la demanda del mercado, no los clientes del operador: el libro no tiene reservas, ocupación de cupos ni costos de guías. Una llegada no es una persona: quien entra dos veces cuenta dos veces.
- Los escenarios son un ejercicio simple, no un pronóstico.
- "Europa" son 4 países (España, Alemania, Francia e Inglaterra) y "Resto del mundo" mezcla muchos países.
- Power Query lee el CSV desde el parámetro `RutaCSV`: para actualizar en otro computador hay que cambiarlo por la ruta completa. Las hojas de fórmulas no dependen de esto.

## Autora
Paula Maiza Rivera Larrain · Analista de datos junior · [LinkedIn](https://www.linkedin.com/in/paula-ma%C3%ADza-rivera-larrain-9719a428b/)
