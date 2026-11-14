"""
Ejecuta las celdas de cells_notebook.py en un intérprete persistente (sin Jupyter) y guarda un .ipynb (nbformat 4)
con las salidas REALES: texto, tablas, gráficos (PNG en base64). Falla y muestra el error si una celda se rompe.
"""
import ast, io, json, base64, contextlib, traceback, sys, importlib
import matplotlib; matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

SALIDA = "turismo_chile_dependencia_y_coyuntura.ipynb"
mod = importlib.import_module("cells_notebook"); CELLS = mod.CELLS
REC = open("recomendaciones.md", encoding="utf8").read().strip() if len(sys.argv) > 1 and sys.argv[1] == "final" else "(pendiente)"
RESP = open("respuestas.md", encoding="utf8").read().strip() if len(sys.argv) > 1 and sys.argv[1] == "final" else "(pendiente)"

def lines(t): return t.splitlines(keepends=True)
ns = {"__name__": "__main__"}; nb_cells = []; n_exec = 0
for kind, src in CELLS:
    src = src.replace("__RECOMENDACIONES__", REC).replace("__RESPUESTAS__", RESP)
    if kind == "markdown":
        nb_cells.append({"cell_type": "markdown", "metadata": {}, "source": lines(src)}); continue
    n_exec += 1; buf = io.StringIO(); outputs = []; val = None
    tree = ast.parse(src); last = None
    if tree.body and isinstance(tree.body[-1], ast.Expr): last = ast.Expression(tree.body.pop().value)
    try:
        with contextlib.redirect_stdout(buf):
            exec(compile(tree, "<celda>", "exec"), ns)
            if last is not None: val = eval(compile(last, "<celda>", "eval"), ns)
    except Exception:
        print("ERROR en celda", n_exec); print(src[:400]); traceback.print_exc(); sys.exit(1)
    if buf.getvalue(): outputs.append({"output_type": "stream", "name": "stdout", "text": lines(buf.getvalue())})
    if val is not None:
        data = {"text/plain": lines(repr(val) if not isinstance(val, pd.DataFrame) else val.to_string())}
        if isinstance(val, pd.DataFrame): data["text/html"] = lines(val.to_html())
        outputs.append({"output_type": "execute_result", "execution_count": n_exec, "data": data, "metadata": {}})
    for num in plt.get_fignums():
        fb = io.BytesIO(); plt.figure(num).savefig(fb, format="png", dpi=110, bbox_inches="tight")
        outputs.append({"output_type": "display_data", "metadata": {},
                        "data": {"image/png": base64.b64encode(fb.getvalue()).decode(), "text/plain": ["<Figure>"]}})
    plt.close("all")
    nb_cells.append({"cell_type": "code", "execution_count": n_exec, "metadata": {}, "outputs": outputs, "source": lines(src)})
nb = {"cells": nb_cells, "nbformat": 4, "nbformat_minor": 4,
      "metadata": {"kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"},
                   "language_info": {"name": "python", "version": sys.version.split()[0]}}}
json.dump(nb, open(SALIDA, "w", encoding="utf8"), ensure_ascii=False, indent=1)
print("Notebook guardado:", SALIDA, "| celdas de código ejecutadas:", n_exec)
