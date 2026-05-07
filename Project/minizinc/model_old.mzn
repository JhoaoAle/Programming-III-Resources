include "globals.mzn";

% ---------- PARAMETERS ----------
int: num_subjects;
int: num_semestre;
int: num_precedences;
int: num_simultaneo;
int: num_electivas1;
int: num_electivas2;

set of int: SUBJECTS = 1..num_subjects;
set of int: SEMESTRES = 1..num_semestre;

array[SUBJECTS] of string: subjects;
array[SUBJECTS] of int: creditos;

array[1..num_precedences, 1..2] of int: precedence;
array[1..num_simultaneo,1..2] of int: simultaneo;
array[1..num_electivas1,1..2] of int: electivas1;
array[1..num_electivas2,1..2] of int: electivas2;

% ---------- VARIABLES ----------
array[SUBJECTS] of var SEMESTRES: semestre;

% ---------- PREDICATES ----------
predicate prec(int:x , int: y) =
    semestre[x] < semestre[y];

predicate simul(int:x , int: y) =
    semestre[x] = semestre[y];

predicate elec(int:x) =
    semestre[x] >= 8;

predicate elec2(int:x) =
    semestre[x] >= 9;

% ---------- CONSTRAINTS ----------

% Precedences
constraint forall(p in 1..num_precedences)(
    prec(precedence[p,1], precedence[p,2])
);

% Simultaneous courses
constraint forall(s in 1..num_simultaneo)(
    simul(simultaneo[s,1], simultaneo[s,2])
);

% Electives constraints
constraint forall(e in 1..num_electivas1)(
    elec(electivas1[e,1])
);

constraint forall(e in 1..num_electivas2)(
    elec2(electivas2[e,1])
);

% ---------- SOLVE ----------
solve satisfy;

% ---------- OUTPUT ----------
output [
    "semestre " ++ show(semestre[t]) ++
    " -> creditos: " ++ show(creditos[t]) ++
    " -> materia: " ++ subjects[t] ++ "\n"
    | t in SUBJECTS
];