"""
Ejecuta 02_consultas.sql sobre turismo_chile_siet.db, imprime cada resultado y lo guarda en resultados/ (CSV) y
resultados_consultas.md. Python solo ejecuta el SQL: no calcula nada del análisis.
"""
import sqlite3, re, os, io, csv
import pandas as pd
pd.set_option("display.width",250); pd.set_option("display.max_columns",30); pd.set_option("display.max_rows",100)
con = sqlite3.connect("turismo_chile_siet.db"); con.execute("PRAGMA foreign_keys = ON")
con.execute("DROP VIEW IF EXISTS v_llegadas")
txt = open("02_consultas.sql",encoding="utf8").read()
bloques = re.split(r"(?m)^-- \[(Q\d+b?)\] ", txt)[1:]
os.makedirs("resultados",exist_ok=True); md=["# Resultados de las consultas (ejecución real)\n"]
n=0
for i in range(0,len(bloques),2):
    qid, cuerpo = bloques[i], bloques[i+1]
    titulo = cuerpo.splitlines()[0]
    sql = "\n".join(l for l in cuerpo.splitlines()[1:])
    stmt = sql.strip().rstrip(";")
    first = re.sub(r"(?m)^--.*$","",stmt).strip().upper()
    print(f"\n=== {qid} · {titulo}")
    if first.startswith("CREATE"):
        con.execute(stmt); con.commit(); print("(vista creada)"); md.append(f"## {qid} · {titulo}\n\n(vista creada)\n"); continue
    cur = con.execute(stmt); filas = cur.fetchall(); cols=[d[0] for d in cur.description] if cur.description else []
    df = pd.DataFrame(filas, columns=cols) if cols else pd.DataFrame()
    print(df.to_string(index=False) if len(df) else "(sin filas: ninguna violación)")
    df.to_csv(f"resultados/{qid}.csv",index=False,encoding="utf-8")
    md.append(f"## {qid} · {titulo}\n\n" + (df.to_markdown(index=False) if len(df) else "(sin filas: ninguna violación)") + "\n"); n+=1
open("resultados_consultas.md","w",encoding="utf8").write("\n".join(md)); print(f"\nConsultas ejecutadas: {n}")
