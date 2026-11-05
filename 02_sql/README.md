# Turismo receptivo en Chile: por dónde entran los turistas y de dónde viene la caída de 2026

Proyecto de análisis en SQL (SQLite) con datos oficiales del SIET (Sernatur) e indicadores regionales 2024 del Barómetro de Turismo. Caso simulado: soy analista de una corporación regional de turismo que debe decidir dónde invertir.

## Pregunta
¿Por qué pasos fronterizos y aeropuertos entran los turistas, de qué países vienen, qué regiones concentran las entradas y de dónde viene la caída de enero-julio 2026?

## Resultado principal
Entre enero y julio de 2026 llegaron 698.090 turistas menos que en el mismo período de 2025 (-19,1 %). Los pasos fronterizos con Argentina explican -694.892 (99,5 % de la caída neta); los aeropuertos subieron 1,3 %. Los argentinos como nacionalidad bajaron 766.959 (-39,7 %), compensados en parte por otros mercados.

## Qué contiene
- `01_esquema.sql`: tablas, claves foráneas e índices.
- `02_consultas.sql`: 25 consultas numeradas y comentadas (Q01 en adelante).
- `cargar_base.py`: lee los CSV oficiales y crea la base SQLite.
- `ejecutar_consultas.py`: ejecuta las consultas y guarda los resultados.
- `resultados/` y `resultados_consultas.md`: un CSV por consulta y un resumen en texto.
- `turismo_chile_siet.db`: base SQLite ya construida (8 tablas y 1 vista).
- `../datos_oficiales/`: CSV del SIET (Sernatur) y del Barómetro de Turismo.

## Qué demuestra
- Modelo relacional con claves foráneas e índices (178.182 filas de hechos).
- JOIN múltiples, GROUP BY, HAVING, subconsultas, CTE y CASE WHEN.
- Funciones de ventana: SUM OVER, RANK, ROW_NUMBER, NTILE, LAG, AVG OVER.
- Vista reutilizable y control de calidad: conciliación con 7 totales oficiales, integridad referencial y una diferencia entre fuentes (Maule, 2.000 llegadas).

## Cómo reproducirlo
Requisitos: Python 3 y las librerías pandas y tabulate.
1. Clonar el repositorio.
2. Entrar a la carpeta `02_sql` e instalar las librerías: `python -m pip install pandas tabulate`
3. Ejecutar `python cargar_base.py` (opcional: lee `../datos_oficiales/` y recrea `turismo_chile_siet.db`).
4. Ejecutar `python ejecutar_consultas.py` (corre las consultas de `02_consultas.sql`, guarda un CSV por consulta en `resultados/` y genera `resultados_consultas.md`).
5. Abrir `turismo_chile_siet.db` con cualquier cliente SQLite si quieres explorar las tablas y la vista `v_llegadas`.

## Datos
- Llegadas por paso, nacionalidad y mes, 2013 a julio 2026: SIET, Sernatur (publicación de agosto 2026). Cifras preliminares. Incluyen chilenos residentes en el exterior.
- Indicadores regionales 2024 (alojamiento, empleo, viajes internos): Barómetro de Turismo (Subsecretaría de Turismo y Sernatur), con datos del INE: alojamiento (EMAT) y empleo (ENE).
- Hay una diferencia entre fuentes en Maule (SIET 22.020 contra el desglose regional del Barómetro 20.020). Es el 0,04 % del total y no cambia ninguna conclusión.

## Límites
- Muestra cuánto y cuándo, no por qué cayó Argentina; no se probaron causas.
- La entrada por región no es el destino visitado.
- 2026 llega solo hasta julio, sin la temporada alta de diciembre a febrero.
- Los indicadores regionales son de 2024 y de períodos distintos.
- La conciliación con totales oficiales de 2026 llega solo hasta mayo.

## Notas
El SQL usa dialecto SQLite (por ejemplo `printf`). En SQL Server se usa FORMAT y en PostgreSQL TO_CHAR.

## Autora
Paula Maiza Rivera Larrain · Analista de datos junior · [LinkedIn](https://www.linkedin.com/in/paula-ma%C3%ADza-rivera-larrain-9719a428b/)
