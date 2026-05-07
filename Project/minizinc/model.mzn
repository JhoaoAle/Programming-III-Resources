include "globals.mzn";

% ============================================
% PARAMETERS
% ============================================

int: num_subjects;
set of int: SUBJECTS = 1..num_subjects;

array[SUBJECTS] of int: creditos;

int: current_semester;

array[SUBJECTS] of bool: completed;
array[SUBJECTS] of var bool: taking;

% ============================================
% RULE DATA
% ============================================

int: num_precedences;
array[1..num_precedences, 1..2] of int: precedence;

int: num_simultaneo;
array[1..num_simultaneo, 1..2] of int: simultaneo;

% FIX: electives must be declared if they exist in .dzn

int: num_electivas1;
array[1..num_electivas1, 1..2] of int: electivas1;

int: num_electivas2;
array[1..num_electivas2, 1..2] of int: electivas2;

% ============================================
% BASIC CONSTRAINTS
% ============================================

constraint forall(s in SUBJECTS)(
    completed[s] -> not taking[s]
);

% ============================================
% PRECEDENCE CONSTRAINTS
% ============================================

constraint forall(p in 1..num_precedences)(
    let {
        int: pre = precedence[p,1],
        int: post = precedence[p,2]
    } in
    taking[post] -> completed[pre]
);

% ============================================
% SIMULTANEOUS CONSTRAINTS
% ============================================

constraint forall(s in 1..num_simultaneo)(
    let {
        int: a = simultaneo[s,1],
        int: b = simultaneo[s,2]
    } in
    taking[a] <-> taking[b]
);

% ============================================
% ELECTIVES
% ============================================

constraint forall(i in 1..num_electivas1)(
    current_semester < 8 ->
    not taking[electivas1[i,1]]
);

constraint forall(i in 1..num_electivas2)(
    current_semester < 9 ->
    not taking[electivas2[i,1]]
);



var int: total_credits =
    sum(s in SUBJECTS)(
        creditos[s] * bool2int(taking[s])
    );

constraint total_credits >= 12;
constraint total_credits <= 20;


% ============================================
% SOLVE
% ============================================

solve satisfy;

% ============================================
% OUTPUT
% ============================================

output [
    show([s | s in SUBJECTS where fix(taking[s])])
];