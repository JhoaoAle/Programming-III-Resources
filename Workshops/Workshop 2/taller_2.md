**1.** Considere los archivos fuente adjuntos: `Sudoku4.dzn` y `Sudoku5.dzn`. Elabore un modelo que permita resolver ambos escenarios de Sudoku, y que, de manera similar, sea escalable a diferentes tamaños válidos de Sudoku.

**2.** Un banco desea automatizar la decisión de aprobación de préstamos personales. Para ello, evalúa a cada solicitante con base en múltiples criterios financieros y de riesgo.

Cada persona es evaluada según:

- Variables del solicitante:
- Edad (años)
- Ingreso mensual (COP)
- Deuda mensual existente (COP)
- Puntaje de crédito (300 a 850)
- Años de empleo continuo
- Número de dependientes
- Historial de moras (0 = No, 1 = Sí)
- Monto del préstamo solicitado (COP)

Un solicitante es elegible si cumple TODAS estas condiciones:

- Edad entre 21 y 65 años.
- Ingreso mensual $\geq$  2.5 veces (deuda actual + cuota estimada del préstamo).
- Ratio de endeudamiento (deuda / ingreso) $\leq$  0.4
- Puntaje de crédito $\geq$  650
- Al menos 1 año de empleo continuo
- No tener moras recientes
- La cuota estimada del préstamo se calcula como: `cuota = préstamo / 12`.

Construya un modelo que pueda leer los datos del archivo `loan_data.dzn` y determine si el usuario es elegible para un préstamo, y cuál es el valor estimado de sus cuotas mensuales (ignorando intereses).

**Bonus:** Modifique el archivo `.dzn` para que contenga un array de solicitantes de préstamo con su correspondiente información y permita que el modelo itere sobre el array y retorne los resultados de cada cliente en orden.