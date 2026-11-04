# Resultados de las consultas (ejecución real)

## Q01 · CALIDAD · Nulos y ceros (los ceros son meses sin llegadas de una nación en un paso: vienen así en la fuente) · responde la pregunta 5

| control                                                                    |   casos |
|:---------------------------------------------------------------------------|--------:|
| llegadas_siet.llegadas nulas                                               |       0 |
| llegadas_siet.llegadas en cero                                             |   11286 |
| llegadas_ext_barometro con NULL (O'Higgins y Ñuble: sin pasos fronterizos) |       2 |
| regiones sin ningún paso fronterizo (información, no error)                |       2 |

## Q02 · CALIDAD · Duplicados: pasos y nacionalidades repetidos (la clave del hecho es paso+nación+año+mes) · responde la pregunta 5

| control                                 |   casos |
|:----------------------------------------|--------:|
| pasos duplicados                        |       0 |
| naciones duplicadas                     |       0 |
| hechos duplicados (paso+nación+año+mes) |       0 |

## Q03 · CALIDAD · Integridad referencial (anti-joins) · responde la pregunta 5

| control                |   casos |
|:-----------------------|--------:|
| hechos sin paso        |       0 |
| hechos sin nación      |       0 |
| pasos sin región       |       0 |
| pasos sin ningún hecho |       0 |

## Q03b · CALIDAD · Verificación nativa de SQLite: sin filas = ninguna violación de clave foránea · responde la pregunta 5

(sin filas: ninguna violación)

## Q04 · CALIDAD · Conciliación con los totales oficiales publicados (comunicados de la Subsecretaría de Turismo y SIET) · responde la pregunta 5

| indicador                                       |   suma_tabla |   total_oficial |   diferencia |
|:------------------------------------------------|-------------:|----------------:|-------------:|
| Total 2017 (máximo de la base, 2013-2025)       |      6449883 |         6449883 |            0 |
| Total 2022                                      |      2030479 |         2030479 |            0 |
| Total 2023                                      |      3730507 |         3730507 |            0 |
| Total 2024                                      |      5239233 |         5239233 |            0 |
| Total 2025                                      |      6004567 |         6004567 |            0 |
| Acumulado ene-may 2026 (oficial SIET 2.287.859) |      2287859 |         2287859 |            0 |
| Ene-nov 2024 (Barómetro: 4.591.490)             |      4591490 |         4591490 |            0 |

## Q04b · CALIDAD · Conciliación por región: SIET (ene-nov 2024) contra el Barómetro de Turismo. Solo muestra las regiones que NO coinciden · responde la pregunta 5

| region   |   siet_ene_nov_2024 |   barometro |   diferencia |
|:---------|--------------------:|------------:|-------------:|
| Maule    |               22020 |       20020 |         2000 |

## Q05 · VIEW reutilizable · Hechos con todas las dimensiones y la fecha

(vista creada)

## Q06 · LAG + subconsulta · Llegadas por año completo, variación interanual e índice contra 2019 (2026 se excluye: solo tiene ene-jul) · responde la pregunta 2

|   anio |         llegadas |   var_interanual_pct |   indice_2019_igual_100 |
|-------:|-----------------:|---------------------:|------------------------:|
|   2013 |      3.5762e+06  |                nan   |                    79.2 |
|   2014 |      3.67439e+06 |                  2.7 |                    81.3 |
|   2015 |      4.47834e+06 |                 21.9 |                    99.1 |
|   2016 |      5.6407e+06  |                 26   |                   124.9 |
|   2017 |      6.44988e+06 |                 14.3 |                   142.8 |
|   2018 |      5.72293e+06 |                -11.3 |                   126.7 |
|   2019 |      4.51796e+06 |                -21.1 |                   100   |
|   2020 |      1.11909e+06 |                -75.2 |                    24.8 |
|   2021 | 190022           |                -83   |                     4.2 |
|   2022 |      2.03048e+06 |                968.5 |                    44.9 |
|   2023 |      3.73051e+06 |                 83.7 |                    82.6 |
|   2024 |      5.23923e+06 |                 40.4 |                   116   |
|   2025 |      6.00457e+06 |                 14.6 |                   132.9 |

## Q07 · CASE WHEN · ¿Por dónde entran? Llegadas por tipo de paso (años completos y ene-jul) · responde la pregunta 1

| tipo_paso          |   a2019 |   a2024 |   a2025 |   pct_2025 |   ene_jul_2025 |   ene_jul_2026 |   var_2026_pct |
|:-------------------|--------:|--------:|--------:|-----------:|---------------:|---------------:|---------------:|
| Frontera Argentina | 1603672 | 2266256 | 2879593 |       48   |        1923381 |        1228489 |          -36.1 |
| Aeropuertos        | 2078889 | 2328797 | 2393197 |       39.9 |        1336028 |        1353064 |            1.3 |
| Frontera Norte     |  835401 |  644180 |  731777 |       12.2 |         402617 |         382383 |           -5   |

## Q08 · SUM() OVER · Los 10 países con más llegadas en 2025: participación y variación contra 2024 · responde la pregunta 2

| nacion    |   a2024 |   a2025 |   var_2025_pct |   participacion_pct |
|:----------|--------:|--------:|---------------:|--------------------:|
| ARGENTINA | 2088389 | 2856441 |           36.8 |                47.6 |
| BRASIL    |  787036 |  681649 |          -13.4 |                11.4 |
| BOLIVIA   |  468681 |  562729 |           20.1 |                 9.4 |
| PERU      |  365427 |  352353 |           -3.6 |                 5.9 |
| EEUU      |  251570 |  250460 |           -0.4 |                 4.2 |
| CHILE     |  238565 |  213323 |          -10.6 |                 3.6 |
| COLOMBIA  |  163682 |  149592 |           -8.6 |                 2.5 |
| ESPAÑA    |   75052 |   80821 |            7.7 |                 1.3 |
| ALEMANIA  |   66599 |   68405 |            2.7 |                 1.1 |
| FRANCIA   |   66900 |   65691 |           -1.8 |                 1.1 |

## Q09 · CTE + subconsulta escalar · Cambio de cada país entre enero-julio de 2025 y de 2026 (cambio mínimo de 3.000 llegadas) · responde la pregunta 2

| nacion     |   ene_jul_2025 |   ene_jul_2026 |   cambio |   pct_del_cambio_total |
|:-----------|---------------:|---------------:|---------:|-----------------------:|
| ARGENTINA  |        1931583 |        1164624 |  -766959 |                  109.9 |
| BOLIVIA    |         300224 |         276600 |   -23624 |                    3.4 |
| VENEZUELA  |          11336 |           8244 |    -3092 |                    0.4 |
| INGLATERRA |          32094 |          35338 |     3244 |                   -0.5 |
| COSTA RICA |           9000 |          13045 |     4045 |                   -0.6 |
| COLOMBIA   |          77456 |          82315 |     4859 |                   -0.7 |
| CHINA      |          22198 |          27839 |     5641 |                   -0.8 |
| PERU       |         197600 |         209176 |    11576 |                   -1.7 |
| EEUU       |         135041 |         148592 |    13551 |                   -1.9 |
| AUSTRALIA  |          21193 |          38881 |    17688 |                   -2.5 |

## Q09b · VERIFICACIÓN · El cambio total ene-jul 2026 contra 2025 debe dar -698090 (el mismo total que la tabla de pasos) · responde la pregunta 5

|   cambio_total |
|---------------:|
|        -698090 |

## Q10 · CASE WHEN (vista) · Peso de cada grupo de mercados: años completos y ene-jul de 2025 y 2026 (comparables) · responde la pregunta 3

| mercado                            |   pct_2022 |   pct_2024 |   pct_2025 |   pct_ene_jul_2025 |   pct_ene_jul_2026 |
|:-----------------------------------|-----------:|-----------:|-----------:|-------------------:|-------------------:|
| Argentina                          |       32.1 |       39.9 |       47.6 |               52.7 |               39.3 |
| Resto de Sudamérica                |       22.2 |       21.1 |       16.5 |               15.2 |               19   |
| Bolivia y Perú                     |       16.2 |       15.9 |       15.2 |               13.6 |               16.4 |
| Europa                             |       10.6 |        8.4 |        7.7 |                6.7 |                9   |
| América del Norte                  |        9.2 |        6.8 |        5.9 |                5.2 |                7   |
| Chilenos residentes en el exterior |        6.7 |        4.6 |        3.6 |                3.5 |                4.4 |
| Otros mercados                     |        3   |        3.4 |        3.5 |                3   |                4.9 |

## Q11 · CTE + SUM() OVER · Curva de concentración (Pareto) de países en 2025 · responde la pregunta 2

| nacion    |   llegadas |   participacion_pct |   acumulado_pct |
|:----------|-----------:|--------------------:|----------------:|
| ARGENTINA |    2856441 |                47.6 |            47.6 |
| BRASIL    |     681649 |                11.4 |            58.9 |
| BOLIVIA   |     562729 |                 9.4 |            68.3 |
| PERU      |     352353 |                 5.9 |            74.2 |
| EEUU      |     250460 |                 4.2 |            78.3 |
| CHILE     |     213323 |                 3.6 |            81.9 |
| COLOMBIA  |     149592 |                 2.5 |            84.4 |
| ESPAÑA    |      80821 |                 1.3 |            85.7 |

## Q12 · CTE + LEFT JOIN (autounión) · Llegadas mensuales de Argentina y variación interanual (2025 y 2026) · responde la pregunta 3

| periodo   |   llegadas |   mismo_mes_anio_anterior |   var_interanual_pct |
|:----------|-----------:|--------------------------:|---------------------:|
| 2013-01   |     235644 |                       nan |                nan   |
| 2013-02   |     150403 |                       nan |                nan   |
| 2013-03   |     149602 |                       nan |                nan   |
| 2013-04   |      86644 |                       nan |                nan   |
| 2013-05   |      66680 |                       nan |                nan   |
| 2013-06   |      59256 |                       nan |                nan   |
| 2013-07   |      86801 |                       nan |                nan   |
| 2013-08   |      83660 |                       nan |                nan   |
| 2013-09   |      81836 |                       nan |                nan   |
| 2013-10   |     112011 |                       nan |                nan   |
| 2013-11   |     112349 |                       nan |                nan   |
| 2013-12   |     137866 |                       nan |                nan   |
| 2014-01   |     237253 |                    235644 |                  0.7 |
| 2014-02   |     146589 |                    150403 |                 -2.5 |
| 2014-03   |     125954 |                    149602 |                -15.8 |
| 2014-04   |      89766 |                     86644 |                  3.6 |
| 2014-05   |      76129 |                     66680 |                 14.2 |
| 2014-06   |      48706 |                     59256 |                -17.8 |
| 2014-07   |      75302 |                     86801 |                -13.2 |
| 2014-08   |      76526 |                     83660 |                 -8.5 |
| 2014-09   |      73095 |                     81836 |                -10.7 |
| 2014-10   |     104175 |                    112011 |                 -7   |
| 2014-11   |     103628 |                    112349 |                 -7.8 |
| 2014-12   |     168380 |                    137866 |                 22.1 |
| 2015-01   |     279798 |                    237253 |                 17.9 |
| 2015-02   |     219889 |                    146589 |                 50   |
| 2015-03   |     161426 |                    125954 |                 28.2 |
| 2015-04   |     132478 |                     89766 |                 47.6 |
| 2015-05   |     109423 |                     76129 |                 43.7 |
| 2015-06   |      98167 |                     48706 |                101.6 |
| 2015-07   |     120851 |                     75302 |                 60.5 |
| 2015-08   |     104580 |                     76526 |                 36.7 |
| 2015-09   |     120135 |                     73095 |                 64.4 |
| 2015-10   |     150651 |                    104175 |                 44.6 |
| 2015-11   |     172719 |                    103628 |                 66.7 |
| 2015-12   |     276759 |                    168380 |                 64.4 |
| 2016-01   |     444062 |                    279798 |                 58.7 |
| 2016-02   |     361207 |                    219889 |                 64.3 |
| 2016-03   |     270110 |                    161426 |                 67.3 |
| 2016-04   |     178370 |                    132478 |                 34.6 |
| 2016-05   |     142148 |                    109423 |                 29.9 |
| 2016-06   |     124442 |                     98167 |                 26.8 |
| 2016-07   |     204247 |                    120851 |                 69   |
| 2016-08   |     165171 |                    104580 |                 57.9 |
| 2016-09   |     202864 |                    120135 |                 68.9 |
| 2016-10   |     231722 |                    150651 |                 53.8 |
| 2016-11   |     225712 |                    172719 |                 30.7 |
| 2016-12   |     350654 |                    276759 |                 26.7 |
| 2017-01   |     647955 |                    444062 |                 45.9 |
| 2017-02   |     464664 |                    361207 |                 28.6 |
| 2017-03   |     273083 |                    270110 |                  1.1 |
| 2017-04   |     251266 |                    178370 |                 40.9 |
| 2017-05   |     172919 |                    142148 |                 21.6 |
| 2017-06   |     130277 |                    124442 |                  4.7 |
| 2017-07   |     224896 |                    204247 |                 10.1 |
| 2017-08   |     173472 |                    165171 |                  5   |
| 2017-09   |     205592 |                    202864 |                  1.3 |
| 2017-10   |     215627 |                    231722 |                 -6.9 |
| 2017-11   |     230973 |                    225712 |                  2.3 |
| 2017-12   |     333047 |                    350654 |                 -5   |
| 2018-01   |     532043 |                    647955 |                -17.9 |
| 2018-02   |     397664 |                    464664 |                -14.4 |
| 2018-03   |     284310 |                    273083 |                  4.1 |
| 2018-04   |     201948 |                    251266 |                -19.6 |
| 2018-05   |     138282 |                    172919 |                -20   |
| 2018-06   |      73543 |                    130277 |                -43.5 |
| 2018-07   |     141010 |                    224896 |                -37.3 |
| 2018-08   |     108318 |                    173472 |                -37.6 |
| 2018-09   |     111942 |                    205592 |                -45.6 |
| 2018-10   |     112482 |                    215627 |                -47.8 |
| 2018-11   |     132106 |                    230973 |                -42.8 |
| 2018-12   |     188587 |                    333047 |                -43.4 |
| 2019-01   |     269245 |                    532043 |                -49.4 |
| 2019-02   |     181507 |                    397664 |                -54.4 |
| 2019-03   |     156007 |                    284310 |                -45.1 |
| 2019-04   |     120809 |                    201948 |                -40.2 |
| 2019-05   |      83091 |                    138282 |                -39.9 |
| 2019-06   |      67628 |                     73543 |                 -8   |
| 2019-07   |     109673 |                    141010 |                -22.2 |
| 2019-08   |      78373 |                    108318 |                -27.6 |
| 2019-09   |      82051 |                    111942 |                -26.7 |
| 2019-10   |      92253 |                    112482 |                -18   |
| 2019-11   |      76197 |                    132106 |                -42.3 |
| 2019-12   |     118633 |                    188587 |                -37.1 |
| 2020-01   |     194314 |                    269245 |                -27.8 |
| 2020-02   |     169187 |                    181507 |                 -6.8 |
| 2020-03   |      46734 |                    156007 |                -70   |
| 2020-11   |        830 |                     76197 |                -98.9 |
| 2020-12   |       3392 |                    118633 |                -97.1 |
| 2021-01   |       2572 |                    194314 |                -98.7 |
| 2021-02   |       1999 |                    169187 |                -98.8 |
| 2021-03   |       2036 |                     46734 |                -95.6 |
| 2021-10   |       1243 |                       nan |                nan   |
| 2021-11   |       3644 |                       830 |                339   |
| 2021-12   |       9418 |                      3392 |                177.7 |
| 2022-01   |      22622 |                      2572 |                779.5 |
| 2022-02   |      21315 |                      1999 |                966.3 |
| 2022-03   |      17726 |                      2036 |                770.6 |
| 2022-04   |      24514 |                       nan |                nan   |
| 2022-05   |      37194 |                       nan |                nan   |
| 2022-06   |      35503 |                       nan |                nan   |
| 2022-07   |      41779 |                       nan |                nan   |
| 2022-08   |      45073 |                       nan |                nan   |
| 2022-09   |      73304 |                       nan |                nan   |
| 2022-10   |      98210 |                      1243 |               7801   |
| 2022-11   |      93815 |                      3644 |               2474.5 |
| 2022-12   |     141042 |                      9418 |               1397.6 |
| 2023-01   |     239268 |                     22622 |                957.7 |
| 2023-02   |     155694 |                     21315 |                630.4 |
| 2023-03   |     102093 |                     17726 |                476   |
| 2023-04   |      95876 |                     24514 |                291.1 |
| 2023-05   |      74873 |                     37194 |                101.3 |
| 2023-06   |      49798 |                     35503 |                 40.3 |
| 2023-07   |      58865 |                     41779 |                 40.9 |
| 2023-08   |      51583 |                     45073 |                 14.4 |
| 2023-09   |      63106 |                     73304 |                -13.9 |
| 2023-10   |      93412 |                     98210 |                 -4.9 |
| 2023-11   |      90237 |                     93815 |                 -3.8 |
| 2023-12   |     130857 |                    141042 |                 -7.2 |
| 2024-01   |     205678 |                    239268 |                -14   |
| 2024-02   |     169192 |                    155694 |                  8.7 |
| 2024-03   |     185408 |                    102093 |                 81.6 |
| 2024-04   |     185848 |                     95876 |                 93.8 |
| 2024-05   |     151700 |                     74873 |                102.6 |
| 2024-06   |      81761 |                     49798 |                 64.2 |
| 2024-07   |     151222 |                     58865 |                156.9 |
| 2024-08   |     109500 |                     51583 |                112.3 |
| 2024-09   |     139521 |                     63106 |                121.1 |
| 2024-10   |     195041 |                     93412 |                108.8 |
| 2024-11   |     208309 |                     90237 |                130.8 |
| 2024-12   |     305209 |                    130857 |                133.2 |
| 2025-01   |     517976 |                    205678 |                151.8 |
| 2025-02   |     393021 |                    169192 |                132.3 |
| 2025-03   |     284115 |                    185408 |                 53.2 |
| 2025-04   |     257386 |                    185848 |                 38.5 |
| 2025-05   |     191511 |                    151700 |                 26.2 |
| 2025-06   |     107649 |                     81761 |                 31.7 |
| 2025-07   |     179925 |                    151222 |                 19   |
| 2025-08   |     145854 |                    109500 |                 33.2 |
| 2025-09   |     165291 |                    139521 |                 18.5 |
| 2025-10   |     179852 |                    195041 |                 -7.8 |
| 2025-11   |     193269 |                    208309 |                 -7.2 |
| 2025-12   |     240592 |                    305209 |                -21.2 |
| 2026-01   |     369830 |                    517976 |                -28.6 |
| 2026-02   |     239262 |                    393021 |                -39.1 |
| 2026-03   |     152573 |                    284115 |                -46.3 |
| 2026-04   |     133342 |                    257386 |                -48.2 |
| 2026-05   |     108593 |                    191511 |                -43.3 |
| 2026-06   |      74391 |                    107649 |                -30.9 |
| 2026-07   |      86633 |                    179925 |                -51.9 |

## Q13 · CASE WHEN · Argentina contra el resto del mundo, ene-jul de cada año · responde la pregunta 3

|   anio |            total |        argentina |            resto |   pct_argentina |
|-------:|-----------------:|-----------------:|-----------------:|----------------:|
|   2022 | 737066           | 200653           | 536413           |            27.2 |
|   2023 |      2.10066e+06 | 776467           |      1.32419e+06 |            37   |
|   2024 |      2.84968e+06 |      1.13081e+06 |      1.71887e+06 |            39.7 |
|   2025 |      3.66203e+06 |      1.93158e+06 |      1.73044e+06 |            52.7 |
|   2026 |      2.96394e+06 |      1.16462e+06 |      1.79931e+06 |            39.3 |

## Q14 · RANK() · Los 3 países con más llegadas por tipo de paso en 2025 · responde la pregunta 1

| tipo_paso          |   posicion | nacion    |   llegadas |
|:-------------------|-----------:|:----------|-----------:|
| Aeropuertos        |          1 | BRASIL    |     589844 |
| Aeropuertos        |          2 | ARGENTINA |     426079 |
| Aeropuertos        |          3 | EEUU      |     218512 |
| Frontera Argentina |          1 | ARGENTINA |    2419574 |
| Frontera Argentina |          2 | BRASIL    |      83687 |
| Frontera Argentina |          3 | CHILE     |      65908 |
| Frontera Norte     |          1 | BOLIVIA   |     531526 |
| Frontera Norte     |          2 | PERU      |     147135 |
| Frontera Norte     |          3 | ARGENTINA |      10788 |

## Q15 · ROW_NUMBER() · El paso principal de cada región en 2025 y su peso dentro de la región · responde la pregunta 1 y 4

| region             | paso_principal                             |   llegadas |   pct_de_la_region |
|:-------------------|:-------------------------------------------|-----------:|-------------------:|
| Metropolitana      | Aeropuerto C. Arturo Merino Benítez        |    2368213 |              100   |
| Valparaíso         | Sistema Cristo Redentor (Los Libertadores) |    1119198 |               99.9 |
| Los Lagos          | Cardenal Antonio Samoré                    |     397994 |               82   |
| Tarapacá           | Colchane                                   |     381710 |               99.7 |
| La Araucanía       | Pino Hachado                               |     193145 |               44.7 |
| Arica y Parinacota | Concordia (Chacalluta)                     |     191695 |               60.7 |
| Magallanes         | Dorotea                                    |     124342 |               30.7 |
| Antofagasta        | Jama                                       |      95634 |               47.4 |
| Maule              | Pehuenche                                  |      71653 |               98.2 |
| Aysén              | Rio Jeinimeni                              |      71196 |               55.8 |
| Coquimbo           | Juntas del Toro                            |      56448 |               99.8 |
| Los Ríos           | Hua Hum                                    |      16105 |               87.2 |
| Atacama            | San Francisco                              |       9269 |               99.9 |
| Biobío             | Pichachén                                  |       7251 |               96.4 |

## Q16 · AVG() OVER · Índice estacional 2023-2025: Argentina contra el resto (mes / promedio mensual del año, promediado) · responde la pregunta 3

|   mes |   indice_argentina |   indice_resto |
|------:|-------------------:|---------------:|
|     1 |               1.91 |           1.18 |
|     2 |               1.39 |           0.95 |
|     3 |               1.09 |           0.98 |
|     4 |               1.03 |           0.8  |
|     5 |               0.81 |           0.7  |
|     6 |               0.47 |           0.74 |
|     7 |               0.74 |           1.12 |
|     8 |               0.59 |           1.05 |
|     9 |               0.71 |           0.91 |
|    10 |               0.94 |           1.04 |
|    11 |               0.97 |           1.16 |
|    12 |               1.36 |           1.37 |

## Q17 · Subconsulta escalar · Países que crecieron en ene-jul 2026 más que el resto del mundo sin Argentina (mínimo 10.000 llegadas en 2025) · responde la pregunta 2

| nacion     |    a25 |    a26 |   var_pct |
|:-----------|-------:|-------:|----------:|
| AUSTRALIA  |  21193 |  38881 |      83.5 |
| CHINA      |  22198 |  27839 |      25.4 |
| PARAGUAY   |  13031 |  15152 |      16.3 |
| INGLATERRA |  32094 |  35338 |      10.1 |
| CANADA     |  24197 |  26612 |      10   |
| EEUU       | 135041 | 148592 |      10   |
| HOLANDA    |  11103 |  12206 |       9.9 |
| FRANCIA    |  35723 |  38350 |       7.4 |

## Q18 · JOIN entre fuentes + RANK · Entradas por región (SIET 2025) y ocupación del alojamiento (EMAT, nov-2024) · responde la pregunta 4

| region             | macrozona   |   entradas_2025 |   pct_entradas |   ocupacion_eat_nov24 |   ranking_entradas |
|:-------------------|:------------|----------------:|---------------:|----------------------:|-------------------:|
| Metropolitana      | Centro      |         2368675 |           39.4 |                  76   |                  1 |
| Valparaíso         | Centro      |         1120230 |           18.7 |                  34   |                  2 |
| Los Lagos          | Sur         |          485254 |            8.1 |                  40.2 |                  3 |
| La Araucanía       | Sur         |          432035 |            7.2 |                  35.8 |                  4 |
| Magallanes         | Austral     |          405627 |            6.8 |                  50.9 |                  5 |
| Tarapacá           | Norte       |          382734 |            6.4 |                  40.2 |                  6 |
| Arica y Parinacota | Norte       |          315671 |            5.3 |                  40.6 |                  7 |
| Antofagasta        | Norte       |          201910 |            3.4 |                  55.4 |                  8 |

## Q19 · NTILE · Cuartiles de países según llegadas de 2025 ¿qué parte del flujo explica cada cuartil de países? (la respuesta al 75 % está en Q11: 4 países llegan a 74,2 % y 5 a 78,3 %) · responde la pregunta 2

|   cuartil |   paises |        llegadas |   pct_del_total |
|----------:|---------:|----------------:|----------------:|
|         1 |       35 |     5.91483e+06 |            98.6 |
|         2 |       35 | 76857           |             1.3 |
|         3 |       35 |  5024           |             0.1 |
|         4 |       34 |   815           |             0   |

## Q20 · Comparación contra 2024 · Argentina, enero a julio de 2023 a 2026 · responde la pregunta 3

|   anio |   ene_jul |
|-------:|----------:|
|   2023 |    776467 |
|   2024 |   1130809 |
|   2025 |   1931583 |
|   2026 |   1164624 |

## Q21 · CTE + CASE WHEN · Cambio ene-jul 2026 contra 2025 por tipo de paso, separando argentinos del resto · responde la pregunta 1 y 2

| tipo_paso          | grupo           |   ene_jul_2025 |   ene_jul_2026 |   cambio |   var_pct |
|:-------------------|:----------------|---------------:|---------------:|---------:|----------:|
| Aeropuertos        | Argentinos      |         270630 |         204580 |   -66050 |     -24.4 |
| Aeropuertos        | Resto del mundo |        1065398 |        1148484 |    83086 |       7.8 |
| Frontera Argentina | Argentinos      |        1653280 |         953676 |  -699604 |     -42.3 |
| Frontera Argentina | Resto del mundo |         270101 |         274813 |     4712 |       1.7 |
| Frontera Norte     | Argentinos      |           7673 |           6368 |    -1305 |     -17   |
| Frontera Norte     | Resto del mundo |         394944 |         376015 |   -18929 |      -4.8 |

## Q22 · CTE + subconsulta escalar · Aporte de cada región de entrada a la caída de ene-jul 2026 · responde la pregunta 4

| region       |   ene_jul_2025 |   ene_jul_2026 |   cambio |   var_pct |   pct_del_cambio_total |
|:-------------|---------------:|---------------:|---------:|----------:|-----------------------:|
| Valparaíso   |         772664 |         425281 |  -347383 |     -45   |                   49.8 |
| Los Lagos    |         313408 |         206546 |  -106862 |     -34.1 |                   15.3 |
| La Araucanía |         276496 |         175483 |  -101013 |     -36.5 |                   14.5 |
| Aysén        |          89827 |          52966 |   -36861 |     -41   |                    5.3 |
| Maule        |          59139 |          24998 |   -34141 |     -57.7 |                    4.9 |
| Magallanes   |         243503 |         220936 |   -22567 |      -9.3 |                    3.2 |
| Coquimbo     |          48765 |          28576 |   -20189 |     -41.4 |                    2.9 |
| Tarapacá     |         199930 |         182523 |   -17407 |      -8.7 |                    2.5 |

## Q23 · Comparación contra 2024 · Argentina, marzo a julio de 2024 y 2026 · responde la pregunta 3

|   anio |   mar_jul |
|-------:|----------:|
|   2024 |    755939 |
|   2026 |    555532 |
