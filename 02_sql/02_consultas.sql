-- =====================================================================
-- Proyecto SQL (DATOS REALES oficiales) · Llegadas de turistas extranjeros por paso, país y mes (SIET 2013-2026)
-- ESCENARIO SIMULADO: soy analista en una corporación regional de turismo (gestor de destino). Los datos son reales; el encargo es una simulación.
-- ENCARGO: "Querido/a analista: 1) ¿Por dónde entran los turistas y cómo cambió en 2026? 2) ¿De qué países vienen y cuáles explican la caída de 2026?
--   3) ¿Cuánto depende el flujo de Argentina? 4) ¿Qué regiones concentran las entradas y cómo se relacionan con la ocupación del alojamiento?
--   5) ¿Podemos confiar en estos datos? Quedamos a la espera de tus resultados. ¡Gracias!"
-- Flujo: AUDITAR (Q01-Q04b) -> VIEW (Q05) -> ANALIZAR (Q06-Q23)
-- MAPA DE PREGUNTAS: 1 = Q07, Q14, Q15, Q21 · 2 = Q06, Q08, Q09, Q11, Q17, Q19, Q21 · 3 = Q10, Q12, Q13, Q16, Q20, Q23 · 4 = Q15, Q18, Q22 · 5 = Q01-Q04b, Q09b
-- RESPUESTAS (cifras de las consultas ejecutadas):
--   1) En 2025 entró 48,0 % por Frontera Argentina, 39,9 % por aeropuertos y 12,2 % por Frontera Norte. En ene-jul 2026: -36,1 %, +1,3 % y -5,0 % (Frontera Argentina = 99,5 % de la caída).
--   2) Argentina 47,6 %, Brasil 11,4 %, Bolivia 9,4 % y Perú 5,9 % (2025). La caída de 2026 es de Argentina (-766.959 llegadas; 109,9 % del cambio) y, en menor medida, de Bolivia (-23.624).
--   3) Argentina pasó de 32,1 % (2022) a 47,6 % (2025); en ene-jul pesó 52,7 % en 2025 y 39,3 % en 2026
--   4) Metropolitana 39,4 % de las entradas (ocupación 76,0 %), Valparaíso 18,7 % (34,0 %), Los Lagos 8,1 %, La Araucanía 7,2 % y Magallanes 6,8 %.
--   5) Sí: reproduce 7 totales oficiales sin diferencia. Única diferencia entre fuentes: Maule (SIET 22.020 contra el desglose regional del Barómetro 20.020).
-- =====================================================================

-- [Q01] CALIDAD · Nulos y ceros (los ceros son meses sin llegadas de una nación en un paso: vienen así en la fuente) · responde la pregunta 5
SELECT 'llegadas_siet.llegadas nulas' AS control, COUNT(*) AS casos FROM llegadas_siet WHERE llegadas IS NULL
UNION ALL SELECT 'llegadas_siet.llegadas en cero', COUNT(*) FROM llegadas_siet WHERE llegadas = 0
UNION ALL SELECT 'llegadas_ext_barometro con NULL (O''Higgins y Ñuble: sin pasos fronterizos)', COUNT(*) FROM llegadas_ext_barometro WHERE llegadas_ene_nov_2024 IS NULL
UNION ALL SELECT 'regiones sin ningún paso fronterizo (información, no error)', COUNT(*) FROM regiones r LEFT JOIN dim_paso p ON p.region_id = r.region_id WHERE p.paso_id IS NULL;

-- [Q02] CALIDAD · Duplicados: pasos y nacionalidades repetidos (la clave del hecho es paso+nación+año+mes) · responde la pregunta 5
SELECT 'pasos duplicados' AS control, COUNT(*) AS casos FROM (SELECT nombre, region_id FROM dim_paso GROUP BY nombre, region_id HAVING COUNT(*) > 1)
UNION ALL SELECT 'naciones duplicadas', COUNT(*) FROM (SELECT nacion FROM dim_nacion GROUP BY nacion HAVING COUNT(*) > 1)
UNION ALL SELECT 'hechos duplicados (paso+nación+año+mes)', COUNT(*) FROM (SELECT 1 FROM llegadas_siet GROUP BY paso_id, nacion_id, anio, mes HAVING COUNT(*) > 1);

-- [Q03] CALIDAD · Integridad referencial (anti-joins) · responde la pregunta 5
SELECT 'hechos sin paso' AS control, COUNT(*) AS casos FROM llegadas_siet l LEFT JOIN dim_paso p ON p.paso_id = l.paso_id WHERE p.paso_id IS NULL
UNION ALL SELECT 'hechos sin nación', COUNT(*) FROM llegadas_siet l LEFT JOIN dim_nacion n ON n.nacion_id = l.nacion_id WHERE n.nacion_id IS NULL
UNION ALL SELECT 'pasos sin región', COUNT(*) FROM dim_paso p LEFT JOIN regiones r ON r.region_id = p.region_id WHERE r.region_id IS NULL
UNION ALL SELECT 'pasos sin ningún hecho', COUNT(*) FROM dim_paso p LEFT JOIN llegadas_siet l ON l.paso_id = p.paso_id WHERE l.paso_id IS NULL;

-- [Q03b] CALIDAD · Verificación nativa de SQLite: sin filas = ninguna violación de clave foránea · responde la pregunta 5
PRAGMA foreign_key_check;

-- [Q04] CALIDAD · Conciliación con los totales oficiales publicados (comunicados de la Subsecretaría de Turismo y SIET) · responde la pregunta 5
SELECT 'Total 2017 (máximo de la base, 2013-2025)' AS indicador, SUM(llegadas) AS suma_tabla, 6449883 AS total_oficial, SUM(llegadas) - 6449883 AS diferencia FROM llegadas_siet WHERE anio = 2017
UNION ALL SELECT 'Total 2022', SUM(llegadas), 2030479, SUM(llegadas) - 2030479 FROM llegadas_siet WHERE anio = 2022
UNION ALL SELECT 'Total 2023', SUM(llegadas), 3730507, SUM(llegadas) - 3730507 FROM llegadas_siet WHERE anio = 2023
UNION ALL SELECT 'Total 2024', SUM(llegadas), 5239233, SUM(llegadas) - 5239233 FROM llegadas_siet WHERE anio = 2024
UNION ALL SELECT 'Total 2025', SUM(llegadas), 6004567, SUM(llegadas) - 6004567 FROM llegadas_siet WHERE anio = 2025
UNION ALL SELECT 'Acumulado ene-may 2026 (oficial SIET 2.287.859)', SUM(llegadas), 2287859, SUM(llegadas) - 2287859 FROM llegadas_siet WHERE anio = 2026 AND mes <= 5
UNION ALL SELECT 'Ene-nov 2024 (Barómetro: 4.591.490)', SUM(llegadas), 4591490, SUM(llegadas) - 4591490 FROM llegadas_siet WHERE anio = 2024 AND mes <= 11;

-- [Q04b] CALIDAD · Conciliación por región: SIET (ene-nov 2024) contra el Barómetro de Turismo. Solo muestra las regiones que NO coinciden · responde la pregunta 5
SELECT r.nombre AS region, s.siet_ene_nov_2024, b.llegadas_ene_nov_2024 AS barometro, s.siet_ene_nov_2024 - b.llegadas_ene_nov_2024 AS diferencia
FROM regiones r
JOIN llegadas_ext_barometro b ON b.region_id = r.region_id
LEFT JOIN (SELECT p.region_id, SUM(l.llegadas) AS siet_ene_nov_2024 FROM llegadas_siet l JOIN dim_paso p ON p.paso_id = l.paso_id
           WHERE l.anio = 2024 AND l.mes <= 11 GROUP BY p.region_id) s ON s.region_id = r.region_id
WHERE s.siet_ene_nov_2024 IS NOT NULL AND s.siet_ene_nov_2024 <> COALESCE(b.llegadas_ene_nov_2024, 0)
ORDER BY ABS(diferencia) DESC;

-- [Q05] VIEW reutilizable · Hechos con todas las dimensiones y la fecha
CREATE VIEW v_llegadas AS
SELECT l.anio, l.mes, printf('%04d-%02d', l.anio, l.mes) AS periodo, l.llegadas,
       n.nacion, n.continente,
       CASE WHEN n.nacion = 'ARGENTINA' THEN 'Argentina'
            WHEN n.nacion IN ('BOLIVIA', 'PERU') THEN 'Bolivia y Perú'
            WHEN n.nacion = 'CHILE' THEN 'Chilenos residentes en el exterior'
            WHEN n.continente = 'AMERICA DEL SUR' THEN 'Resto de Sudamérica'
            WHEN n.continente = 'AMERICA DEL NORTE' THEN 'América del Norte'
            WHEN n.continente = 'EUROPA' THEN 'Europa'
            ELSE 'Otros mercados' END AS mercado,
       p.nombre AS paso, p.tipo_paso, r.nombre AS region, r.macrozona
FROM llegadas_siet l
JOIN dim_nacion n ON n.nacion_id = l.nacion_id
JOIN dim_paso p   ON p.paso_id = l.paso_id
JOIN regiones r   ON r.region_id = p.region_id;

-- [Q06] LAG + subconsulta · Llegadas por año completo, variación interanual e índice contra 2019 (2026 se excluye: solo tiene ene-jul) · responde la pregunta 2
WITH a AS (SELECT anio, SUM(llegadas) AS llegadas FROM v_llegadas WHERE anio <= 2025 GROUP BY anio)
SELECT anio, llegadas, ROUND(100.0 * (llegadas - LAG(llegadas) OVER (ORDER BY anio)) / LAG(llegadas) OVER (ORDER BY anio), 1) AS var_interanual_pct,
       ROUND(100.0 * llegadas / (SELECT llegadas FROM a WHERE anio = 2019), 1) AS indice_2019_igual_100
FROM a WHERE anio >= 2013 ORDER BY anio;

-- [Q07] CASE WHEN · ¿Por dónde entran? Llegadas por tipo de paso (años completos y ene-jul) · responde la pregunta 1
SELECT tipo_paso,
       SUM(CASE WHEN anio = 2019 THEN llegadas END) AS a2019,
       SUM(CASE WHEN anio = 2024 THEN llegadas END) AS a2024,
       SUM(CASE WHEN anio = 2025 THEN llegadas END) AS a2025,
       ROUND(100.0 * SUM(CASE WHEN anio = 2025 THEN llegadas END) / (SELECT SUM(llegadas) FROM v_llegadas WHERE anio = 2025), 1) AS pct_2025,
       SUM(CASE WHEN anio = 2025 AND mes <= 7 THEN llegadas END) AS ene_jul_2025,
       SUM(CASE WHEN anio = 2026 AND mes <= 7 THEN llegadas END) AS ene_jul_2026,
       ROUND(100.0 * (SUM(CASE WHEN anio = 2026 AND mes <= 7 THEN llegadas END) - SUM(CASE WHEN anio = 2025 AND mes <= 7 THEN llegadas END))
             / SUM(CASE WHEN anio = 2025 AND mes <= 7 THEN llegadas END), 1) AS var_2026_pct
FROM v_llegadas GROUP BY tipo_paso ORDER BY a2025 DESC;

-- [Q08] SUM() OVER · Los 10 países con más llegadas en 2025: participación y variación contra 2024 · responde la pregunta 2
WITH p AS (SELECT nacion, SUM(CASE WHEN anio = 2025 THEN llegadas END) AS a2025, SUM(CASE WHEN anio = 2024 THEN llegadas END) AS a2024
           FROM v_llegadas WHERE anio IN (2024, 2025) GROUP BY nacion)
SELECT nacion, a2024, a2025, ROUND(100.0 * (a2025 - a2024) / a2024, 1) AS var_2025_pct,
       ROUND(100.0 * a2025 / SUM(a2025) OVER (), 1) AS participacion_pct
FROM p ORDER BY a2025 DESC LIMIT 10;

-- [Q09] CTE + subconsulta escalar · Cambio de cada país entre enero-julio de 2025 y de 2026 (cambio mínimo de 3.000 llegadas) · responde la pregunta 2
-- COALESCE: si un país no tiene filas en un año, cuenta como 0 y no sale del total
WITH c AS (
    SELECT nacion,
           COALESCE(SUM(CASE WHEN anio = 2025 THEN llegadas END), 0) AS ene_jul_2025,
           COALESCE(SUM(CASE WHEN anio = 2026 THEN llegadas END), 0) AS ene_jul_2026
    FROM v_llegadas
    WHERE mes <= 7 AND anio IN (2025, 2026)
    GROUP BY nacion
)
SELECT nacion, ene_jul_2025, ene_jul_2026,
       ene_jul_2026 - ene_jul_2025 AS cambio,
       -- Se divide por el cambio de TODOS los países, no solo de los que se muestran
       ROUND(100.0 * (ene_jul_2026 - ene_jul_2025) /
             (SELECT SUM(ene_jul_2026 - ene_jul_2025) FROM c), 1) AS pct_del_cambio_total
FROM c
WHERE ABS(ene_jul_2026 - ene_jul_2025) >= 3000
ORDER BY cambio;

-- [Q09b] VERIFICACIÓN · El cambio total ene-jul 2026 contra 2025 debe dar -698090 (el mismo total que la tabla de pasos) · responde la pregunta 5
SELECT SUM(CASE WHEN anio = 2026 THEN llegadas ELSE 0 END)
     - SUM(CASE WHEN anio = 2025 THEN llegadas ELSE 0 END) AS cambio_total
FROM v_llegadas
WHERE mes <= 7 AND anio IN (2025, 2026);

-- [Q10] CASE WHEN (vista) · Peso de cada grupo de mercados: años completos y ene-jul de 2025 y 2026 (comparables) · responde la pregunta 3
SELECT mercado,
       ROUND(100.0 * SUM(CASE WHEN anio = 2022 THEN llegadas END) / (SELECT SUM(llegadas) FROM v_llegadas WHERE anio = 2022), 1) AS pct_2022,
       ROUND(100.0 * SUM(CASE WHEN anio = 2024 THEN llegadas END) / (SELECT SUM(llegadas) FROM v_llegadas WHERE anio = 2024), 1) AS pct_2024,
       ROUND(100.0 * SUM(CASE WHEN anio = 2025 THEN llegadas END) / (SELECT SUM(llegadas) FROM v_llegadas WHERE anio = 2025), 1) AS pct_2025,
       ROUND(100.0 * SUM(CASE WHEN anio = 2025 AND mes <= 7 THEN llegadas END) / (SELECT SUM(llegadas) FROM v_llegadas WHERE anio = 2025 AND mes <= 7), 1) AS pct_ene_jul_2025,
       ROUND(100.0 * SUM(CASE WHEN anio = 2026 AND mes <= 7 THEN llegadas END) / (SELECT SUM(llegadas) FROM v_llegadas WHERE anio = 2026 AND mes <= 7), 1) AS pct_ene_jul_2026
FROM v_llegadas GROUP BY mercado ORDER BY pct_2025 DESC;

-- [Q11] CTE + SUM() OVER · Curva de concentración (Pareto) de países en 2025 · responde la pregunta 2
WITH p AS (SELECT nacion, SUM(llegadas) AS llegadas FROM v_llegadas WHERE anio = 2025 GROUP BY nacion)
SELECT nacion, llegadas, ROUND(100.0 * llegadas / SUM(llegadas) OVER (), 1) AS participacion_pct,
       ROUND(100.0 * SUM(llegadas) OVER (ORDER BY llegadas DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(llegadas) OVER (), 1) AS acumulado_pct
FROM p ORDER BY llegadas DESC LIMIT 8;

-- [Q12] CTE + LEFT JOIN (autounión) · Llegadas mensuales de Argentina y variación interanual (2025 y 2026) · responde la pregunta 3
-- Se une cada mes con el mismo mes del año anterior (no falla si falta una fila)
WITH m AS (
    SELECT anio, mes, SUM(llegadas) AS llegadas
    FROM v_llegadas
    WHERE nacion = 'ARGENTINA'
    GROUP BY anio, mes
)
SELECT printf('%04d-%02d', a.anio, a.mes) AS periodo,
       a.llegadas,
       b.llegadas AS mismo_mes_anio_anterior,
       ROUND(100.0 * (a.llegadas - b.llegadas) / NULLIF(b.llegadas, 0), 1) AS var_interanual_pct
FROM m a
LEFT JOIN m b ON b.anio = a.anio - 1 AND b.mes = a.mes
ORDER BY a.anio, a.mes;

-- [Q13] CASE WHEN · Argentina contra el resto del mundo, ene-jul de cada año · responde la pregunta 3
SELECT anio,
       SUM(llegadas) AS total,
       SUM(CASE WHEN nacion = 'ARGENTINA' THEN llegadas ELSE 0 END) AS argentina,
       SUM(CASE WHEN nacion <> 'ARGENTINA' THEN llegadas ELSE 0 END) AS resto,
       ROUND(100.0 * SUM(CASE WHEN nacion = 'ARGENTINA' THEN llegadas ELSE 0 END) / SUM(llegadas), 1) AS pct_argentina
FROM v_llegadas WHERE mes <= 7 AND anio BETWEEN 2022 AND 2026 GROUP BY anio ORDER BY anio;

-- [Q14] RANK() · Los 3 países con más llegadas por tipo de paso en 2025 · responde la pregunta 1
WITH x AS (SELECT tipo_paso, nacion, SUM(llegadas) AS llegadas, RANK() OVER (PARTITION BY tipo_paso ORDER BY SUM(llegadas) DESC) AS posicion
           FROM v_llegadas WHERE anio = 2025 GROUP BY tipo_paso, nacion)
SELECT tipo_paso, posicion, nacion, llegadas FROM x WHERE posicion <= 3 ORDER BY tipo_paso, posicion;

-- [Q15] ROW_NUMBER() · El paso principal de cada región en 2025 y su peso dentro de la región · responde la pregunta 1 y 4
WITH x AS (SELECT region, paso, SUM(llegadas) AS llegadas, ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(llegadas) DESC) AS n,
                  SUM(SUM(llegadas)) OVER (PARTITION BY region) AS total_region
           FROM v_llegadas WHERE anio = 2025 GROUP BY region, paso)
SELECT region, paso AS paso_principal, llegadas, ROUND(100.0 * llegadas / total_region, 1) AS pct_de_la_region FROM x WHERE n = 1 ORDER BY llegadas DESC;

-- [Q16] AVG() OVER · Índice estacional 2023-2025: Argentina contra el resto (mes / promedio mensual del año, promediado) · responde la pregunta 3
WITH m AS (SELECT anio, mes, CASE WHEN nacion = 'ARGENTINA' THEN 'Argentina' ELSE 'Resto' END AS grupo, SUM(llegadas) AS llegadas
           FROM v_llegadas WHERE anio BETWEEN 2023 AND 2025 GROUP BY anio, mes, grupo),
     i AS (SELECT anio, mes, grupo, 1.0 * llegadas / AVG(llegadas) OVER (PARTITION BY anio, grupo) AS indice FROM m)
SELECT mes, ROUND(AVG(CASE WHEN grupo = 'Argentina' THEN indice END), 2) AS indice_argentina, ROUND(AVG(CASE WHEN grupo = 'Resto' THEN indice END), 2) AS indice_resto
FROM i GROUP BY mes ORDER BY mes;

-- [Q17] Subconsulta escalar · Países que crecieron en ene-jul 2026 más que el resto del mundo sin Argentina (mínimo 10.000 llegadas en 2025) · responde la pregunta 2
WITH c AS (SELECT nacion, SUM(CASE WHEN anio = 2025 THEN llegadas END) AS a25, SUM(CASE WHEN anio = 2026 THEN llegadas END) AS a26
           FROM v_llegadas WHERE mes <= 7 AND anio IN (2025, 2026) GROUP BY nacion)
SELECT nacion, a25, a26, ROUND(100.0 * (a26 - a25) / a25, 1) AS var_pct
FROM c WHERE a25 >= 10000 AND 1.0 * a26 / a25 > (SELECT 1.0 * SUM(a26) / SUM(a25) FROM c WHERE nacion <> 'ARGENTINA') ORDER BY var_pct DESC LIMIT 8;

-- [Q18] JOIN entre fuentes + RANK · Entradas por región (SIET 2025) y ocupación del alojamiento (EMAT, nov-2024) · responde la pregunta 4
SELECT r.nombre AS region, r.macrozona, x.entradas_2025, ROUND(100.0 * x.entradas_2025 / SUM(x.entradas_2025) OVER (), 1) AS pct_entradas,
       a.ocupacion_habitaciones_pct AS ocupacion_eat_nov24, RANK() OVER (ORDER BY x.entradas_2025 DESC) AS ranking_entradas
FROM (SELECT region AS nombre_region, SUM(llegadas) AS entradas_2025 FROM v_llegadas WHERE anio = 2025 GROUP BY region) x
JOIN regiones r ON r.nombre = x.nombre_region JOIN eat_region a ON a.region_id = r.region_id ORDER BY x.entradas_2025 DESC LIMIT 8;

-- [Q19] NTILE · Cuartiles de países según llegadas de 2025 ¿qué parte del flujo explica cada cuartil de países? (la respuesta al 75 % está en Q11: 4 países llegan a 74,2 % y 5 a 78,3 %) · responde la pregunta 2
WITH p AS (SELECT nacion, SUM(llegadas) AS llegadas FROM v_llegadas WHERE anio = 2025 AND nacion NOT LIKE 'O. %' GROUP BY nacion)
SELECT cuartil, COUNT(*) AS paises, SUM(llegadas) AS llegadas, ROUND(100.0 * SUM(llegadas) / (SELECT SUM(llegadas) FROM p), 1) AS pct_del_total
FROM (SELECT nacion, llegadas, NTILE(4) OVER (ORDER BY llegadas DESC) AS cuartil FROM p) GROUP BY cuartil ORDER BY cuartil;

-- [Q20] Comparación contra 2024 · Argentina, enero a julio de 2023 a 2026 · responde la pregunta 3
SELECT anio, SUM(llegadas) AS ene_jul
FROM v_llegadas
WHERE nacion = 'ARGENTINA' AND mes <= 7 AND anio IN (2023, 2024, 2025, 2026)
GROUP BY anio
ORDER BY anio;

-- [Q21] CTE + CASE WHEN · Cambio ene-jul 2026 contra 2025 por tipo de paso, separando argentinos del resto · responde la pregunta 1 y 2
WITH t AS (
    SELECT tipo_paso,
           CASE WHEN nacion = 'ARGENTINA' THEN 'Argentinos' ELSE 'Resto del mundo' END AS grupo,
           COALESCE(SUM(CASE WHEN anio = 2025 THEN llegadas END), 0) AS ene_jul_2025,
           COALESCE(SUM(CASE WHEN anio = 2026 THEN llegadas END), 0) AS ene_jul_2026
    FROM v_llegadas
    WHERE mes <= 7 AND anio IN (2025, 2026)
    GROUP BY tipo_paso, grupo
)
SELECT tipo_paso, grupo, ene_jul_2025, ene_jul_2026,
       ene_jul_2026 - ene_jul_2025 AS cambio,
       ROUND(100.0 * (ene_jul_2026 - ene_jul_2025) / NULLIF(ene_jul_2025, 0), 1) AS var_pct
FROM t
ORDER BY tipo_paso, grupo;

-- [Q22] CTE + subconsulta escalar · Aporte de cada región de entrada a la caída de ene-jul 2026 · responde la pregunta 4
WITH r AS (
    SELECT region,
           COALESCE(SUM(CASE WHEN anio = 2025 THEN llegadas END), 0) AS ene_jul_2025,
           COALESCE(SUM(CASE WHEN anio = 2026 THEN llegadas END), 0) AS ene_jul_2026
    FROM v_llegadas
    WHERE mes <= 7 AND anio IN (2025, 2026)
    GROUP BY region
)
SELECT region, ene_jul_2025, ene_jul_2026,
       ene_jul_2026 - ene_jul_2025 AS cambio,
       ROUND(100.0 * (ene_jul_2026 - ene_jul_2025) / NULLIF(ene_jul_2025, 0), 1) AS var_pct,
       ROUND(100.0 * (ene_jul_2026 - ene_jul_2025) /
             (SELECT SUM(ene_jul_2026 - ene_jul_2025) FROM r), 1) AS pct_del_cambio_total
FROM r
ORDER BY cambio
LIMIT 8;

-- [Q23] Comparación contra 2024 · Argentina, marzo a julio de 2024 y 2026 · responde la pregunta 3
SELECT anio, SUM(llegadas) AS mar_jul
FROM v_llegadas
WHERE nacion = 'ARGENTINA' AND mes BETWEEN 3 AND 7 AND anio IN (2024, 2026)
GROUP BY anio
ORDER BY anio;