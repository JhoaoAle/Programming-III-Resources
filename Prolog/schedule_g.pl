:- use_module(library(clpfd)).
:- use_module(library(lists)).

% ══════════════════════════════════════════════════════════════
%  PARAMETERS
% ══════════════════════════════════════════════════════════════

num_subjects(60).
num_semestre(15).

subjects([
    "Deportes1","Desarrollo_del_pensamiento_logico","Matematicas1",
    "Introduccion_a_la_informatica","Programacion1","Humanidades1",
    "Deportes2","Laboratorio_fisica1","Fisica1","Matematicas2",
    "Algebra_lineal","Programacion2","Laboratorio_fisica2","Fisica2",
    "Matematicas3","Logica","Estructura_de_datos","Humanidades2",
    "Laboratorio_de_electronica","Fundamentos_de_electronica",
    "Fisica3","Laboratorio_fisica3","Matematicas4","Programacion3",
    "Teoria_de_sistemas","Laboratorio_electronica_digital",
    "electronica_digital","administracion_de_empresas","estadistica",
    "programacion4","gramatica_y_lenguajes_formales",
    "tecnicas_de_la_comunicacion","arquitectura_de_computadores",
    "investigacion_de_operaciones","computacion_grafica",
    "estadisticas_especiales","bases_de_datos1",
    "sistemas_operativos1","comunicaciones1",
    "inteligencia_artificial","ingenieria_de_software1",
    "compiladores","comunicaciones2","computacion_blanda",
    "gerencia_de_proyecto","legislacion_y_etica",
    "sistemas_distribuidos","ingenieria_de_software2",
    "arquitectura_clienteservidor",
    "administracion_proyectos_de_software",
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

% ══════════════════════════════════════════════════════════════
%  SHARED HELPERS
% ══════════════════════════════════════════════════════════════

pairs_to_list([], []).
pairs_to_list([X,Y|Rest], [[X,Y]|T]) :- pairs_to_list(Rest, T).

sum_credits([], 0).
sum_credits([C-_|Rest], Tot) :-
    sum_credits(Rest, T2),
    Tot is C + T2.

print_result(AgentName, Cap, Assigned, Credits, Subjs) :-
    format("~n========================================~n"),
    format("  ~w~n", [AgentName]),
    format("  Credit cap per semester: ~w~n", [Cap]),
    format("========================================~n~n"),
    findall(S, member(_-S, Assigned), Sems0),
    sort(Sems0, Sems),
    forall(member(S, Sems), (
        findall(C-Subj, (
            member(I-S, Assigned),
            nth1(I, Subjs, Subj),
            nth1(I, Credits, C)
        ), Pairs),
        format("--- Semester ~w ---~n", [S]),
        maplist([C-Subj]>>format("  ~w cr  ~w~n", [C, Subj]), Pairs),
        sum_credits(Pairs, Tot),
        format("  [Total: ~w credits]~n~n", [Tot])
    )).

% ══════════════════════════════════════════════════════════════
%  CLP(FD) OPTIMAL SCHEDULE  (minimizes graduation semester)
% ══════════════════════════════════════════════════════════════

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

% Reified equality: B = 1 iff Sem =:= S
% (#<=> is not a defined operator in SWI-Prolog 9; use #\ instead)
indicator(Sem, S, B) :-
    B in 0..1,
    Sem #= S  #\ (B #= 0),
    Sem #\= S #\ (B #= 1).

credits_in_semester_acc([], [], _S, Acc, Acc).
credits_in_semester_acc([Sem|Sems], [C|Cs], S, Acc, Total) :-
    indicator(Sem, S, B),
    Contrib #= B * C,
    NewAcc #= Acc + Contrib,
    credits_in_semester_acc(Sems, Cs, S, NewAcc, Total).

apply_credit_cap_one(Semesters, Credits, MaxCredits, S) :-
    credits_in_semester_acc(Semesters, Credits, S, 0, Total),
    Total #=< MaxCredits.

apply_credit_cap(Semesters, Credits, MaxSem, MaxCredits) :-
    numlist(1, MaxSem, SemNums),
    maplist(apply_credit_cap_one(Semesters, Credits, MaxCredits), SemNums).

schedule(Semesters) :-
    num_subjects(N),
    length(Semesters, N),
    num_semestre(MaxSem),
    Semesters ins 1..MaxSem,
    precedence(PrecPairs),
    pairs_to_list(PrecPairs, PrecList),
    maplist(prec_constraint(Semesters), PrecList),
    simultaneo(SimPairs),
    pairs_to_list(SimPairs, SimList),
    maplist(simul_constraint(Semesters), SimList),
    electivas1(E1),
    maplist(elec1_constraint(Semesters), E1),
    electivas2(E2),
    maplist(elec2_constraint(Semesters), E2),
    creditos(Credits),
    apply_credit_cap(Semesters, Credits, MaxSem, 20),
    LatestSemester in 1..MaxSem,
    max_sem_constraint_list(Semesters, LatestSemester),
    labeling([min(LatestSemester)], [LatestSemester|Semesters]).

print_schedule_chronological(Semesters) :-
    subjects(Subjs),
    creditos(Creds),
    num_semestre(MaxSem),
    forall(
        between(1, MaxSem, S),
        print_semester(S, Semesters, Subjs, Creds)
    ).

print_semester(S, Semesters, Subjs, Creds) :-
    findall(C-Subj,
        (nth1(I, Semesters, S), nth1(I, Subjs, Subj), nth1(I, Creds, C)),
        Pairs),
    (   Pairs \= []
    ->  format("--- Semester ~w ---~n", [S]),
        sum_credits(Pairs, Total),
        maplist([C-Subj]>>format("  ~w cr  ~w~n", [C, Subj]), Pairs),
        format("  [Total: ~w credits]~n~n", [Total])
    ;   true
    ).

% Entry point for the CLP(FD) optimal solver
agent_schedule :-
    schedule(Semesters),
    print_schedule_chronological(Semesters).

% ══════════════════════════════════════════════════════════════
%  GREEDY AGENTS
%
%  Both agents proceed semester by semester (1, 2, 3, ...).
%  Each semester:
%    1. Collect eligible subjects (all prereqs in earlier sems, not yet taken).
%    2. Sort eligible by credits descending.
%    3. Greedily pick highest-credit subjects until the cap would be exceeded.
%       Simultaneous pairs (must share the same semester per the simultaneo
%       constraint) are treated as an indivisible unit: both are selected
%       together only if their combined credits still fit under the cap.
%
%  Agent 1 cap = 20 credits/semester
%  Agent 2 cap = 15 credits/semester
% ══════════════════════════════════════════════════════════════

prereqs_met(I, Assigned, PrecList, CurrentSem) :-
    forall(
        member([P, I], PrecList),
        (member(P-SP, Assigned), SP < CurrentSem)
    ).

eligible_subjects(AllSubjs, Assigned, PrecList, CurrentSem, Eligible) :-
    include(
        [I]>>(
            \+ member(I-_, Assigned),
            prereqs_met(I, Assigned, PrecList, CurrentSem)
        ),
        AllSubjs,
        Eligible
    ).

sort_by_credit_desc(Subjects, Credits, Sorted) :-
    maplist([I, C-I]>>(nth1(I, Credits, C)), Subjects, Pairs),
    msort(Pairs, Asc),
    reverse(Asc, DescPairs),
    pairs_values(DescPairs, Sorted).

% get_sim_partner(+I, +SimList, +Eligible, -J)
% J is a simultaneous partner of I that is still eligible (not yet assigned).
get_sim_partner(I, SimList, Eligible, J) :-
    (member([I,J], SimList) ; member([J,I], SimList)),
    member(J, Eligible).

% pick_acc(+Sorted, +Credits, +Cap, +UsedSoFar, +Eligible, +SimList, +Acc, -Picked)
% Iterate over the sorted list, picking subjects greedily.
pick_acc([], _Credits, _Cap, _Used, _Elig, _Sim, Acc, Acc).
pick_acc([I|Rest], Credits, Cap, Used, Elig, Sim, Acc, Final) :-
    (   member(I, Acc)                              % already picked as a sim partner
    ->  pick_acc(Rest, Credits, Cap, Used, Elig, Sim, Acc, Final)
    ;   nth1(I, Credits, CI),
        (   get_sim_partner(I, Sim, Elig, J), \+ member(J, Acc)
        ->  nth1(J, Credits, CJ),                  % I has an unpicked sim partner J
            Combined is Used + CI + CJ,
            (   Combined =< Cap                    % take both or skip both
            ->  pick_acc(Rest, Credits, Cap, Combined, Elig, Sim, [I,J|Acc], Final)
            ;   pick_acc(Rest, Credits, Cap, Used,     Elig, Sim, Acc,        Final)
            )
        ;   NewUsed is Used + CI,                  % no sim partner required
            (   NewUsed =< Cap
            ->  pick_acc(Rest, Credits, Cap, NewUsed, Elig, Sim, [I|Acc], Final)
            ;   pick_acc(Rest, Credits, Cap, Used,    Elig, Sim, Acc,     Final)
            )
        )
    ).

% greedy_loop/9 - recursive semester-by-semester assignment
greedy_loop(CurrentSem, _MaxSem, AllSubjs, Assigned, _Prec, _Sim, _Credits, _Cap, Assigned) :-
    length(AllSubjs, Total),
    length(Assigned, Total), !,       % all subjects assigned: done
    ActualMax is CurrentSem - 1,
    format("Completed in ~w semesters.~n", [ActualMax]).
greedy_loop(CurrentSem, MaxSem, _AllSubjs, Assigned, _Prec, _Sim, _Credits, _Cap, Assigned) :-
    CurrentSem > MaxSem, !,           % ran out of semesters
    length(Assigned, Done),
    format("WARNING: Only ~w subjects assigned after ~w semesters.~n", [Done, MaxSem]).
greedy_loop(CurrentSem, MaxSem, AllSubjs, Assigned, PrecList, SimList, Credits, Cap, FinalAssigned) :-
    eligible_subjects(AllSubjs, Assigned, PrecList, CurrentSem, Eligible),
    sort_by_credit_desc(Eligible, Credits, Sorted),
    pick_acc(Sorted, Credits, Cap, 0, Eligible, SimList, [], PickedList),
    sort(PickedList, PickedAll),
    maplist([I, I-CurrentSem]>>true, PickedAll, NewPairs),
    append(Assigned, NewPairs, NewAssigned),
    NextSem is CurrentSem + 1,
    greedy_loop(NextSem, MaxSem, AllSubjs, NewAssigned, PrecList, SimList, Credits, Cap, FinalAssigned).

% greedy_schedule(+Cap, -Assigned)
greedy_schedule(Cap, Assigned) :-
    numlist(1, 60, All),
    precedence(PF), pairs_to_list(PF, PrecList),
    simultaneo(SF), pairs_to_list(SF, SimList),
    creditos(Credits),
    num_semestre(MaxSem),
    greedy_loop(1, MaxSem, All, [], PrecList, SimList, Credits, Cap, Assigned).

% ══════════════════════════════════════════════════════════════
%  ENTRY POINT: run both greedy agents and compare
% ══════════════════════════════════════════════════════════════

run_agents :-
    creditos(Credits),
    subjects(Subjs),
    format("~n*** AGENT 1: Greedy highest-credit first, cap = 20 cr/semester ***~n"),
    greedy_schedule(20, A20),
    print_result("AGENT 1", 20, A20, Credits, Subjs),
    format("~n*** AGENT 2: Greedy highest-credit first, cap = 15 cr/semester ***~n"),
    greedy_schedule(15, A15),
    print_result("AGENT 2", 15, A15, Credits, Subjs).