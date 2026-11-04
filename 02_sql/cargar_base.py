import sqlite3, os, pandas as pd, unicodedata
D="../datos_oficiales/"; DB="turismo_chile_siet.db"
if os.path.exists(DB): os.remove(DB)
con=sqlite3.connect(DB); con.executescript(open("01_esquema.sql",encoding="utf8").read())
def ins(t,df): df=df.astype(object).where(df.notna(),None); con.executemany(f"INSERT INTO {t} VALUES ({','.join('?'*df.shape[1])})",df.values.tolist())
r=pd.read_csv(D+"regiones_indicadores_2024.csv"); r.insert(0,"region_id",range(1,len(r)+1))
ins("regiones",r[["region_id","region","macrozona"]]); ins("llegadas_ext_barometro",r[["region_id","llegadas_ext_ene_nov24","var_llegadas_ext_pct"]])
ins("eat_region",r[["region_id","eat_llegadas_nov24","eat_var_llegadas_pct","eat_pernoct_nov24","eat_var_pernoct_pct","eat_ocupacion_pct","eat_var_ocupacion_pp"]])
ins("empleo_act_region",r[["region_id","empleo_act_miles_son24","empleo_var_pct"]])
ins("viajes_internos_region",r[["region_id","viajes_emitidos_ene_oct24","viajes_emit_var_pct","viajes_recibidos_ene_oct24","viajes_recib_var_pct"]])
rid={n:i for i,n in zip(r.region_id,r.region)}
def norm(s): return "".join(c for c in unicodedata.normalize("NFD",s.lower()) if unicodedata.category(c)!="Mn")
MAP={"arica":"Arica y Parinacota","tarapaca":"Tarapacá","antofagasta":"Antofagasta","atacama":"Atacama","coquimbo":"Coquimbo","valparaiso":"Valparaíso","maule":"Maule",
     "bio":"Biobío","araucania":"La Araucanía","rios":"Los Ríos","lagos":"Los Lagos","aysen":"Aysén","magallanes":"Magallanes","metropolitana":"Metropolitana"}
d=pd.read_csv(D+"siet/llegadas_detalle_paso_nacion_mes.csv")
def region(s):
    n=norm(s)
    for k,v in MAP.items():
        if k in n: return v
    raise ValueError(s)
d["region_nombre"]=d.region.map(region); d["region_id"]=d.region_nombre.map(rid)
paso=d[["paso","tipo_paso","region_id"]].drop_duplicates().reset_index(drop=True); paso.insert(0,"paso_id",range(1,len(paso)+1))
ins("dim_paso",paso)
# continente más frecuente por nación (solo O. CARIBE tiene 2 etiquetas)
nac=d.groupby("nacion").agg(nacion_grupo=("nacion_grupo","first"),continente=("continente",lambda s: s.value_counts().index[0])).reset_index()
nac.insert(0,"nacion_id",range(1,len(nac)+1)); ins("dim_nacion",nac)
d=d.merge(paso,on=["paso","tipo_paso","region_id"]).merge(nac[["nacion_id","nacion"]],on="nacion")
# La fuente entrega varias filas para una misma clave (paso, nación, año, mes). Se suman porque así cuadran los totales oficiales.
dup=d.duplicated(["paso_id","nacion_id","anio","mes"]).sum()
print("filas en el detalle:",len(d),"| filas que se suman a otra:",dup,"| filas en la base:",len(d)-dup,"| filas idénticas en todas las columnas:",d.duplicated().sum())
f=d.groupby(["paso_id","nacion_id","anio","mes"],as_index=False).llegadas.sum(); f["llegadas"]=f.llegadas.round().astype(int)
ins("llegadas_siet",f[["paso_id","nacion_id","anio","mes","llegadas"]]); con.commit()
print("FK:",con.execute("PRAGMA foreign_key_check").fetchall())
for t in ["regiones","dim_paso","dim_nacion","llegadas_siet","eat_region"]: print(t,con.execute(f"select count(*) from {t}").fetchone()[0])
print("total 2025:",con.execute("select sum(llegadas) from llegadas_siet where anio=2025").fetchone())
