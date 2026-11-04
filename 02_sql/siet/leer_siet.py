"""Lee el Excel oficial del SIET (Sernatur) 'Cuadros de llegadas de turistas extranjeros' y lo deja en formato largo (una fila por nacionalidad y mes)."""
import pandas as pd, numpy as np, re, warnings; warnings.filterwarnings("ignore")
F="/mnt/user-data/uploads/202607-LLEGADAS-DE-TURISTAS-EXTRANJEROS-V20260828-PUBLICACION.xlsx"
raw=pd.read_excel(F,sheet_name="Cuadro por Nacionalidad",header=None,dtype=object)
yrs=raw.iloc[1]; mes=raw.iloc[2]
# columnas: para cada año hay 12 meses + 'Total AAAA'
cols=[]; y=None
for j in range(1,raw.shape[1]):
    v=yrs[j]
    if pd.notna(v) and str(v).strip().lower().startswith("variaci"): break   # fin de los datos: siguen columnas de variación %
    if pd.notna(v) and str(v).strip().isdigit(): y=int(v)
    m=mes[j]
    cols.append((j,y,m))
MES={"ene":1,"feb":2,"mar":3,"abr":4,"may":5,"jun":6,"jul":7,"ago":8,"sep":9,"oct":10,"nov":11,"dic":12}
rows=[]
for i in range(3,raw.shape[0]):
    nat=raw.iat[i,0]
    if pd.isna(nat) or not str(nat).strip(): continue
    for j,y,m in cols:
        if isinstance(m,str) and m.strip().lower() in MES:
            v=raw.iat[i,j]
            if pd.notna(v) and str(v).strip()!="":
                try: rows.append((str(nat).strip(),y,MES[m.strip().lower()],float(v)))
                except ValueError: pass
df=pd.DataFrame(rows,columns=["nacionalidad","anio","mes","llegadas"])
df=df[~((df.anio==2026)&(df.mes>7))].copy()   # 2026: el archivo llega hasta julio
df.to_csv("llegadas_nacionalidad_mes_largo.csv",index=False)
print(df.shape, df.anio.min(), df.anio.max())
print(df[df.nacionalidad=="Total general"].groupby("anio").llegadas.sum().tail(8))
print(sorted(df.nacionalidad.unique())[:80])
print(len(df.nacionalidad.unique()))
