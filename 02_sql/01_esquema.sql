-- Proyecto SQL (DATOS REALES oficiales) · Llegadas de turistas extranjeros por paso fronterizo, país y mes (SIET, 2013-2026)
-- + indicadores regionales 2024 del Barómetro de Turismo (alojamiento, empleo, viajes internos)
PRAGMA foreign_keys = ON;
DROP VIEW IF EXISTS v_llegadas;
DROP TABLE IF EXISTS llegadas_siet; DROP TABLE IF EXISTS dim_paso; DROP TABLE IF EXISTS dim_nacion;
DROP TABLE IF EXISTS viajes_internos_region; DROP TABLE IF EXISTS empleo_act_region; DROP TABLE IF EXISTS eat_region;
DROP TABLE IF EXISTS llegadas_ext_barometro; DROP TABLE IF EXISTS regiones;
CREATE TABLE regiones (region_id INTEGER PRIMARY KEY, nombre TEXT NOT NULL UNIQUE,
    macrozona TEXT NOT NULL CHECK (macrozona IN ('Norte','Centro','Sur','Austral')));   -- macrozona: clasificación del analista
CREATE TABLE dim_paso (paso_id INTEGER PRIMARY KEY, nombre TEXT NOT NULL,
    tipo_paso TEXT NOT NULL CHECK (tipo_paso IN ('Aeropuertos','Frontera Norte','Frontera Argentina')),
    region_id INTEGER NOT NULL REFERENCES regiones(region_id), UNIQUE (nombre, region_id));
CREATE TABLE dim_nacion (nacion_id INTEGER PRIMARY KEY, nacion TEXT NOT NULL UNIQUE, grupo TEXT, continente TEXT NOT NULL);
CREATE TABLE llegadas_siet (paso_id INTEGER NOT NULL REFERENCES dim_paso(paso_id), nacion_id INTEGER NOT NULL REFERENCES dim_nacion(nacion_id),
    anio INTEGER NOT NULL CHECK (anio BETWEEN 2013 AND 2026), mes INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
    llegadas INTEGER NOT NULL CHECK (llegadas >= 0), PRIMARY KEY (paso_id, nacion_id, anio, mes));
CREATE TABLE llegadas_ext_barometro (region_id INTEGER PRIMARY KEY REFERENCES regiones(region_id), llegadas_ene_nov_2024 INTEGER, var_interanual_pct REAL);
CREATE TABLE eat_region (region_id INTEGER PRIMARY KEY REFERENCES regiones(region_id), llegadas_nov_2024 INTEGER NOT NULL, var_llegadas_pct REAL,
    pernoctaciones_nov_2024 INTEGER NOT NULL, var_pernoct_pct REAL, ocupacion_habitaciones_pct REAL NOT NULL, var_ocupacion_pp REAL);
CREATE TABLE empleo_act_region (region_id INTEGER PRIMARY KEY REFERENCES regiones(region_id), ocupados_miles REAL NOT NULL, var_interanual_pct REAL);
CREATE TABLE viajes_internos_region (region_id INTEGER PRIMARY KEY REFERENCES regiones(region_id), emitidos_ene_oct_2024 INTEGER NOT NULL, var_emitidos_pct REAL,
    recibidos_ene_oct_2024 INTEGER NOT NULL, var_recibidos_pct REAL);
CREATE INDEX idx_llegadas_anio_mes ON llegadas_siet(anio, mes);
CREATE INDEX idx_llegadas_nacion ON llegadas_siet(nacion_id);
CREATE INDEX idx_llegadas_paso ON llegadas_siet(paso_id);
CREATE INDEX idx_paso_region ON dim_paso(region_id);
