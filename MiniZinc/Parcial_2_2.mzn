int: num_dias;
set of int: dias = 1..num_dias;

int: ingreso_semanal;

int: costo_arriendo;
int: costo_lavanderia;

array[1..3] of int: costo_comida;
array[1..2] of int: costo_esparcimiento;

array[1..3] of int: satisfaccion_comida;
array[1..2] of int: satisfaccion_esparcimiento;

int: satisfaccion_estudiar;

int: min_lavanderia;
int: min_esparcimiento;
int: max_dias_sin_estudiar;
int: ultimo_dia_arriendo;

% -------------------------
% VARIABLES
% -------------------------
set of int: acciones = 1..4; % 1 arriendo, 2 estudiar, 3 lavandería, 4 esparcimiento

array[dias] of var acciones: accion;
array[dias] of var 1..3: comida;
array[dias] of var 1..2: tipo_esparcimiento;

% -------------------------
% RESTRICCIONES
% -------------------------

% Arriendo
constraint sum(d in dias)(accion[d] == 1) = 1;
constraint forall(d in dias where d > ultimo_dia_arriendo)(accion[d] != 1);

% Lavandería
constraint sum(d in dias)(accion[d] == 3) >= min_lavanderia;
constraint forall(d in 1..num_dias-1)(not (accion[d] == 3 /\ accion[d+1] == 3));
constraint forall(d in dias)(not (accion[d] == 3 /\ accion[d] == 1));

% Estudio
constraint
  forall(d in 1..num_dias - max_dias_sin_estudiar)(
    sum(i in d..d + max_dias_sin_estudiar)(accion[i] == 2) >= 1
  );

% Esparcimiento
constraint sum(d in dias)(accion[d] == 4) >= min_esparcimiento;

constraint
  forall(d in dias)(
    if accion[d] == 4 then tipo_esparcimiento[d] in 1..2
    else tipo_esparcimiento[d] = 1
    endif
  );

% Máximo 2 veces
constraint sum(d in dias)(comida[d] == 1) <= 2;

% No consecutiva
constraint forall(d in 1..num_dias-1)(
  not (comida[d] == 1 /\ comida[d+1] == 1)
);

constraint forall(d in 1..num_dias-2)(
  not (
    comida[d] == comida[d+1] /\
    comida[d+1] == comida[d+2]
  )
);

% -------------------------
% COSTO
% -------------------------
var int: costo_total =
    sum(d in dias)(costo_comida[comida[d]]) +
    sum(d in dias)(if accion[d] == 1 then costo_arriendo else 0 endif) +
    sum(d in dias)(if accion[d] == 3 then costo_lavanderia else 0 endif) +
    sum(d in dias)(
      if accion[d] == 4 then costo_esparcimiento[tipo_esparcimiento[d]] else 0 endif
    );

constraint costo_total <= ingreso_semanal;

% -------------------------
% SATISFACCIÓN
% -------------------------
var int: satisfaccion_total =
    sum(d in dias)(satisfaccion_comida[comida[d]]) +
    sum(d in dias)(
      if accion[d] == 4 then satisfaccion_esparcimiento[tipo_esparcimiento[d]] else 0 endif
    );

var int: ahorro = ingreso_semanal - costo_total;
solve maximize satisfaccion_total + 0.1*ahorro;

output [
  "Acciones = ", show(accion), "\n",
  "Comida = ", show(comida), "\n",
  "Tipo esparcimiento = ", 
  show([ if accion[d] == 4 then tipo_esparcimiento[d] else 0 endif | d in dias ]),
  "\n",
  "Costo = ", show(costo_total), "\n",
  "Ahorro = ", show(ahorro), "\n",
  "Satisfaccion = ", show(satisfaccion_total), "\n"
];