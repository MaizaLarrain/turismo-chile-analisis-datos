"""
DATOS REALES (oficiales y agregados) transcritos de publicaciones públicas. NO son sintéticos.
Fuentes:
 [SIET]  Sernatur, reporte de series temporales de llegadas de turistas extranjeros (datosturismo.sernatur.cl/siet/reporteTempPDI)
 [BAR]   Subsecretaría de Turismo / Sernatur, "Barómetro de Turismo - Diciembre 2024" (publicado 08-01-2025):
         llegadas por país, continente y región de entrada (PDI), alojamiento EAT (INE-EMAT), empleo ACT (INE-ENE), viajes internos (Big Data Turismo Interno)
 [COM]   Subsecretaría de Turismo, comunicados de prensa (totales anuales 2017, 2022-2025)
Las cifras se transcribieron a mano: los controles de cuadratura al final verifican que coinciden con los totales oficiales.
"""
import pandas as pd

# --- Llegadas mensuales de turistas extranjeros (total nacional) ---
m24=[506231,419183,451176,395615,335372,281837,460267,397988,381702,456569,505550,647743]   # [BAR] (dic: comunicado)
m25=[846821,648904,535489,465080,373593,299195,492944,428512,398038,437746,486453,591792]   # [SIET]
m26=[710346,508281,446702,344615,277915,265864,410213]                                       # [SIET] ene-jul 2026
rows=[]
for y,v,f in [(2024,m24,"BAR/COM"),(2025,m25,"SIET"),(2026,m26,"SIET")]:
    for i,x in enumerate(v,1): rows.append((f"{y}-{i:02d}-01",y,i,x,f))
pd.DataFrame(rows,columns=["fecha","anio","mes","llegadas","fuente"]).to_csv("llegadas_mensuales_nacional.csv",index=False)

# --- Serie enero-noviembre 2013-2024 (miles) [BAR] ---
yrs=list(range(2013,2025))
tot=[3201.6,3236.1,3913.1,4982.9,5757.2,5165.0,4086.8,1085.8,117.9,1653.5,3290.9,4591.5]
resto=[1976.7,2079.0,2242.9,2432.8,2766.5,2931.3,2770.0,674.8,106.4,1142.5,2216.1,2808.3]
arg=[1224.9,1157.1,1670.1,2550.1,2990.7,2233.6,1316.8,411.1,11.5,511.1,1074.8,1783.2]
pd.DataFrame({"anio":yrs,"total_miles":tot,"argentina_miles":arg,"resto_mundo_miles":resto}).to_csv("serie_ene_nov_2013_2024.csv",index=False)

# --- Llegadas por país, enero-noviembre 2024 [BAR] ---
paises=[("Argentina",1783180),("Brasil",729673),("Bolivia",409735),("Perú",329617),("Estados Unidos",212614),("Colombia",142489),
("España",65110),("Francia",58800),("Alemania",57130),("México",54007),("Inglaterra",48121),("Canadá",37007),("Italia",36095),
("Australia",31652),("China",30440),("Suiza",14831),("Corea del Sur",14364),("Japón",9391),("Israel",6209),("Otros (tres grupos 'Otros' del Barómetro)",138015+101797+281213)]
pd.DataFrame(paises,columns=["pais","llegadas_ene_nov_2024"]).to_csv("llegadas_pais_ene_nov_2024.csv",index=False)
cont=[("América del Sur",3532709,52.2),("América del Norte",303628,8.4),("Europa",381884,16.5),("Asia",69900,47.5),("Oceanía",39457,33.8),("África",3379,23.5),("Resto del Mundo",260533,-7.9)]
pd.DataFrame(cont,columns=["continente","llegadas_ene_nov_2024","var_interanual_pct"]).to_csv("llegadas_continente_ene_nov_2024.csv",index=False)

# --- Regiones [BAR] ---
# nombre, macrozona(clasificación del analista), llegadas_ext(ene-nov24, var), EAT nov24(llegadas,var,pern,var,ocup,var_pp), empleo ACT SON24(miles,var), viajes ene-oct24(emit,var,recib,var)
R=[
("Arica y Parinacota","Norte",297533,9.9,13244,19.3,22446,12.1,40.6,0.82,7.44,14.0,336622,2.5,351087,-3.9),
("Tarapacá","Norte",248659,53.5,25592,19.1,57905,-36.8,40.2,-22.73,13.92,7.5,778256,3.8,900768,2.7),
("Antofagasta","Norte",155973,37.0,64730,11.2,149254,7.6,55.4,2.91,25.11,4.5,1805147,2.4,1652894,-1.1),
("Atacama","Norte",3638,64.7,24270,12.3,52206,4.2,40.6,-1.51,5.59,-42.1,1029291,-2.4,1013148,-6.7),
("Coquimbo","Norte",19658,-10.6,49989,17.8,100549,11.2,36.3,4.04,28.73,-1.0,2309960,8.7,3409205,3.5),
("Valparaíso","Centro",773466,67.5,126523,16.8,213151,13.4,34.0,3.98,61.19,-7.2,4595495,1.6,10019004,-2.4),
("Metropolitana","Centro",2068019,35.2,344345,28.8,597460,14.4,76.0,4.63,308.85,2.2,19039599,-8.2,8128050,-2.2),
("O'Higgins","Centro",None,None,24555,0.4,52395,-8.0,34.9,-0.88,20.42,-7.7,2974732,1.8,4541410,-4.9),
("Maule","Centro",20020,35.3,24609,19.6,45981,23.5,22.4,-0.60,27.02,2.5,3096306,0.4,3985407,-5.4),
("Ñuble","Centro",None,None,17045,31.0,29279,18.9,24.8,0.10,12.02,-2.9,1265491,-1.6,2152536,-1.5),
("Biobío","Sur",1914,16.5,48164,3.9,87368,19.4,42.6,0.83,40.05,-5.5,4876121,-0.7,4137508,1.2),
("La Araucanía","Sur",248841,68.7,44654,52.0,80447,39.6,35.8,6.86,27.66,14.8,3537460,17.6,4178251,7.7),
("Los Ríos","Sur",7513,0.9,26479,21.3,51716,24.2,38.3,6.67,13.06,0.7,1311196,13.3,2091768,2.4),
("Los Lagos","Sur",318635,55.6,79437,4.2,149355,1.9,40.2,1.91,28.40,-4.4,3054422,13.8,3353604,6.7),
("Aysén","Austral",95538,47.4,19923,21.1,41935,44.3,31.5,6.83,5.13,10.7,250741,-0.5,330898,-4.2),
("Magallanes","Austral",330083,15.1,45637,11.4,85182,20.3,50.9,1.98,11.05,10.9,331489,-3.5,346791,-11.5)]
cols=["region","macrozona","llegadas_ext_ene_nov24","var_llegadas_ext_pct","eat_llegadas_nov24","eat_var_llegadas_pct","eat_pernoct_nov24","eat_var_pernoct_pct",
"eat_ocupacion_pct","eat_var_ocupacion_pp","empleo_act_miles_son24","empleo_var_pct","viajes_emitidos_ene_oct24","viajes_emit_var_pct","viajes_recibidos_ene_oct24","viajes_recib_var_pct"]
d=pd.DataFrame(R,columns=cols); d.to_csv("regiones_indicadores_2024.csv",index=False)

# --- Controles de cuadratura con totales oficiales ---
chk=[("Suma meses 2024 = total oficial 5.239.233",sum(m24),5239233),("Suma meses 2025 = total oficial 6.004.567",sum(m25),6004567),
("Ene-may 2026 = acumulado oficial SIET 2.287.859",sum(m26[:5]),2287859),("Ene-jun 2025 = 1er semestre oficial 3.169.082",sum(m25[:6]),3169082),
("Ene-nov 2024 (meses) = 4.591.490",sum(m24[:11]),4591490),("Suma países = 4.591.490",sum(p[1] for p in paises),4591490),
("Suma continentes = 4.591.490",sum(c[1] for c in cont),4591490),("Suma EAT llegadas regiones = 979.196",int(d.eat_llegadas_nov24.sum()),979196),
("Suma EAT pernoctaciones regiones = 1.816.629",int(d.eat_pernoct_nov24.sum()),1816629),
("Viajes emitidos = 50.592.329",int(d.viajes_emitidos_ene_oct24.sum()),50592329),("Viajes recibidos = 50.592.329",int(d.viajes_recibidos_ene_oct24.sum()),50592329),
("Empleo ACT regiones (miles) ≈ 635,656",round(d.empleo_act_miles_son24.sum(),2),635.66),("Suma llegadas por región de entrada vs total ene-nov 2024",int(d.llegadas_ext_ene_nov24.sum()),4591490)]
for n,a,b in chk: print(("OK  " if a==b else "DIF "),n,a,b)
pd.DataFrame(chk,columns=["control","suma_transcrita","valor_oficial"]).to_csv("controles_cuadratura.csv",index=False)
