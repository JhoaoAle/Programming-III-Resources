:- use_module(library(clpfd)).

% ---------- PARAMETERS ----------
num_subjects(60).
num_semestre(15).

subjects([
    "Deportes1","Desarrollo_del_pensamiento_logico","Matemáticas1",
    "Introducción_a_la_informatica","Programacion1","Humanidades1",
    "Deportes2","Laboratorio_fisica1","Fisica1","Matematicas2",
    "Algebra_lineal","Programacion2","Laboratorio_fisica2","Fisica2",
    "Matematicas3","Lógica","Estructura_de_datos","Humanidades2",
    "Laboratorio_de_electronica","Fundamentos_de_electronica",
    "Fisica3","Laboratorio_fisica3","Matematicas4","Programacion3",
    "Teoría_de_sistemas","Laboratorio_electronica_digital",
    "electronica_digital","administración_de_empresas","estadística",
    "programacion4","gramática_y_lenguajes_formales",
    "técnicas_de_la_comunicacion","arquitectura_de_computadores",
    "investigación_de_operaciones","computación_grafica",
    "estadísticas_especiales","bases_de_datos1",
    "sistemas_operativos1","comunicaciones1",
    "inteligencia_artificial","ingeniería_de_software1",
    "compiladores","comunicaciones2","computación_blanda",
    "gerencia_de_proyecto","legislación_y_etica",
    "sistemas_distribuidos","ingeniería_de_software2",
    "arquitectura_clienteservidor",
    "administración_proyectos_de_software",
    "laboratorio_software","proyecto_de_grado1",
    "constitucion_politica","auditoria_de_sistemas",
    "emprendimiento","proyecto_de_grado2",
    "electivaA1","electivaA2","electivaB1","electivaB2"
]).

creditos([
    1,2,5,3,5,2,1,2,4,5,3,4,2,4,4,3,4,2,3,4,4,2,3,3,2,3,4,3,2,3,
    5,4,4,3,3,2,4,4,3,4,4,3,3,5,3,2,3,4,4,3,3,2,1,3,3,6,3,3,3,3
]).

precedence([
    1,7, 4,16, 3,10, 3,9, 3,8, 3,11, 6,18, 5,12,
    10,15, 10,14, 10,25, 10,13, 12,17, 12,24,
    16,31, 14,21, 14,20, 14,19, 13,22, 24,35,
    11,35, 15,21, 15,23, 15,34, 15,29, 23,39,
    23,35, 21,39, 20,27, 19,26, 31,42, 17,30,
    17,37, 30,40, 29,36, 27,33, 33,38, 37,41,
    38,47, 39,43, 40,44, 41,48, 47,49,
    45,50, 41,51, 41,52, 48,55, 50,54,
    52,56
]).

simultaneo([
    9,8,
    14,13,
    20,19,
    21,22
]).

electivas1([57,58]).
electivas2([59,60]).

% ---------- CONSTRAINTS HELPERS ----------
prec_constraint(Semesters, [X,Y]) :-
    nth1(X, Semesters, SX),
    nth1(Y, Semesters, SY),
    SX #< SY.

simul_constraint(Semesters, [X,Y]) :-
    nth1(X, Semesters, SX),
    nth1(Y, Semesters, SY),
    SX #= SY.

elec1_constraint(Semesters, X) :-
    nth1(X, Semesters, SX),
    SX #>= 8.

elec2_constraint(Semesters, X) :-
    nth1(X, Semesters, SX),
    SX #>= 9.

max_sem_constraint_list([], _Max) :- true.
max_sem_constraint_list([S|Ss], Max) :-
    S #=< Max,
    max_sem_constraint_list(Ss, Max).

pairs_to_list([], []).
pairs_to_list([X,Y|Rest], [[X,Y]|PairsRest]) :-
    pairs_to_list(Rest, PairsRest).

% ---------- MAX CREDITS PER SEMESTER ----------
% For each semester S, the sum of credits of subjects assigned to S must be =< 20.
% indicator/3: B = 1 iff Sem =:= S, using CLP(FD) negation (#\) since #<=>
% is not a defined operator in SWI-Prolog 9.

indicator(Sem, S, B) :-
    B in 0..1,
    Sem #= S  #\ (B #= 0),   % Sem = S  implies B != 0, i.e. B = 1
    Sem #\= S #\ (B #= 1).   % Sem != S implies B != 1, i.e. B = 0

credits_in_semester(Semesters, Credits, S, Total) :-
    credits_in_semester_acc(Semesters, Credits, S, 0, Total).

credits_in_semester_acc([], [], _S, Acc, Acc).
credits_in_semester_acc([Sem|Sems], [C|Cs], S, Acc, Total) :-
    indicator(Sem, S, B),     % B = 1 if this subject is in semester S, else 0
    Contrib #= B * C,
    NewAcc #= Acc + Contrib,
    credits_in_semester_acc(Sems, Cs, S, NewAcc, Total).

apply_credit_cap(Semesters, Credits, MaxSem, MaxCredits) :-
    numlist(1, MaxSem, SemNums),
    maplist(apply_credit_cap_one(Semesters, Credits, MaxCredits), SemNums).

apply_credit_cap_one(Semesters, Credits, MaxCredits, S) :-
    credits_in_semester(Semesters, Credits, S, Total),
    Total #=< MaxCredits.

% ---------- SCHEDULE GENERATION ----------
schedule(Semesters) :-
    num_subjects(N),
    length(Semesters, N),
    num_semestre(MaxSem),
    Semesters ins 1..MaxSem,

    % Apply precedences
    precedence(PrecPairs),
    pairs_to_list(PrecPairs, PrecList),
    maplist(prec_constraint(Semesters), PrecList),

    % Apply simultaneo constraints
    simultaneo(SimPairs),
    pairs_to_list(SimPairs, SimList),
    maplist(simul_constraint(Semesters), SimList),

    % Apply electives
    electivas1(E1),
    maplist(elec1_constraint(Semesters), E1),
    electivas2(E2),
    maplist(elec2_constraint(Semesters), E2),

    % Apply max 20 credits per semester
    creditos(Credits),
    apply_credit_cap(Semesters, Credits, MaxSem, 20),

    % Compute graduation semester
    LatestSemester in 1..MaxSem,
    max_sem_constraint_list(Semesters, LatestSemester),

    % Minimize graduation semester
    labeling([min(LatestSemester)], [LatestSemester|Semesters]).

% ---------- OUTPUT ----------

% Print subjects grouped by semester, in chronological order.
print_schedule_chronological(Semesters) :-
    subjects(Subjs),
    creditos(Creds),
    num_semestre(MaxSem),
    forall(
        between(1, MaxSem, S),
        print_semester(S, Semesters, Subjs, Creds)
    ).

print_semester(S, Semesters, Subjs, Creds) :-
    % Collect subjects assigned to semester S
    findall(
        C-Subj,
        (nth1(I, Semesters, S), nth1(I, Subjs, Subj), nth1(I, Creds, C)),
        Pairs
    ),
    (   Pairs \= []
    ->  format('--- Semester ~w ---~n', [S]),
        sumlist_credits(Pairs, 0, Total),
        maplist(print_course, Pairs),
        format('Total credits: ~w~n~n', [Total])
    ;   true   % Skip empty semesters
    ).

sumlist_credits([], Acc, Acc).
sumlist_credits([C-_|Rest], Acc, Total) :-
    NewAcc is Acc + C,
    sumlist_credits(Rest, NewAcc, Total).

print_course(C-Subj) :-
    format('  Credits: ~w -> Course: ~w~n', [C, Subj]).

% ---------- MAIN ----------
agent_schedule :-
    schedule(Semesters),
    print_schedule_chronological(Semesters).