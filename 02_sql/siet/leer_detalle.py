"""Lee la hoja CONSULTA_DESAGREGADA del Excel oficial del SIET: llegadas por región, paso fronterizo, nacionalidad, año y mes (2013-2026)."""
import pandas as pd, warnings; warnings.filterwarnings("ignore")
F="/mnt/user-data/uploads/202607-LLEGADAS-DE-TURISTAS-EXTRANJEROS-V20260828-PUBLICACION.xlsx"
d=pd.read_excel(F,sheet_name="CONSULTA_DESAGREGADA",usecols="A:K",dtype=object)
d.columns=["region","paso","tipo_paso","nacion","nacion_grupo","continente","zona","anio","mes","llegadas","pp"]
d=d.dropna(subset=["anio","mes","llegadas"]).copy()
MES={"ene":1,"feb":2,"mar":3,"abr":4,"may":5,"jun":6,"jul":7,"ago":8,"sep":9,"oct":10,"nov":11,"dic":12}
d["anio"]=d.anio.astype(int); d["mes"]=d.mes.astype(str).str.strip().str.lower().map(MES); d["llegadas"]=d.llegadas.astype(float)
for c in ["region","paso","tipo_paso","nacion","nacion_grupo","continente","zona","pp"]: d[c]=d[c].astype(str).str.strip()
assert d.mes.notna().all()
d.to_csv("llegadas_detalle_paso_nacion_mes.csv",index=False)
print(d.shape, d.anio.min(), d.anio.max())
print(d.groupby("anio").llegadas.sum().astype(int).to_dict())
print(d.region.unique()); print(d.tipo_paso.unique()); print(d.continente.unique()); print(d.pp.unique())
print("pasos:",d.paso.nunique()," naciones:",d.nacion.nunique())
