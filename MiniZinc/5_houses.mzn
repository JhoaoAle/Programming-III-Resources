include "globals.mzn";

set of int: CASA = 1..5;

% Variables: posición de cada atributo

% Nacionalidades
var CASA: ingles;
var CASA: espanol;
var CASA: ucraniano;
var CASA: noruego;
var CASA: japones;

% Colores
var CASA: rojo;
var CASA: verde;
var CASA: marfil;
var CASA: amarillo;
var CASA: azul;

% Bebidas
var CASA: cafe;
var CASA: te;
var CASA: leche;
var CASA: jugo;
var CASA: agua;

% Mascotas
var CASA: perro;
var CASA: caracoles;
var CASA: zorro;
var CASA: caballo;
var CASA: cebra;

% Cigarros
var CASA: oldgold;
var CASA: kools;
var CASA: chesterfields;
var CASA: lucky;
var CASA: parliaments;

% Todos diferentes en cada categoría
constraint alldifferent([ingles, espanol, ucraniano, noruego, japones]);
constraint alldifferent([rojo, verde, marfil, amarillo, azul]);
constraint alldifferent([cafe, te, leche, jugo, agua]);
constraint alldifferent([perro, caracoles, zorro, caballo, cebra]);
constraint alldifferent([oldgold, kools, chesterfields, lucky, parliaments]);

% Restricciones del problema

constraint ingles = rojo;
constraint espanol = perro;
constraint cafe = verde;
constraint ucraniano = te;

constraint verde = marfil + 1;

constraint oldgold = caracoles;
constraint kools = amarillo;

constraint leche = 3;
constraint noruego = 1;

constraint abs(chesterfields - zorro) = 1;
constraint abs(kools - caballo) = 1;

constraint lucky = jugo;
constraint japones = parliaments;

constraint abs(noruego - azul) = 1;

solve satisfy;

output [
  "Agua la bebe en casa: \(agua)\n",
  "Cebra esta en casa: \(cebra)\n\n",

  "Noruego: \(noruego)\n",
  "Ucraniano: \(ucraniano)\n",
  "Ingles: \(ingles)\n",
  "Espanol: \(espanol)\n",
  "Japones: \(japones)\n"
];