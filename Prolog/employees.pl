% Employees
employees([e1,e2,e3,e4,e5]).

% choose 2 distinct employees
two_distinct(E1,E2,List) :-
    member(E1,List),
    member(E2,List),
    E1 \= E2.

% no common element between two days
no_common([], _).
no_common([H|T], L) :-
    \+ member(H,L),
    no_common(T,L).

% flatten list of lists
flatten([],[]).
flatten([H|T],R) :-
    flatten(T,R1),
    append(H,R1,R).

% count occurrences
count(_,[],0).
count(X,[X|T],N) :-
    count(X,T,N1),
    N is N1+1.
count(X,[H|T],N) :-
    X \= H,
    count(X,T,N).

% check workload condition:
% exactly one employee works 2 days,
% all others work 3 days
valid_workload(All) :-
    employees(E),
    check_counts(E,All,TwoCount),
    TwoCount =:= 1.

check_counts([],_,0).
check_counts([H|T],All,TwoCount) :-
    count(H,All,N),
    ( N =:= 2 ->
        check_counts(T,All,C1),
        TwoCount is C1 + 1
    ; N =:= 3 ->
        check_counts(T,All,TwoCount)
    ).

% main schedule
schedule([D1,D2,D3,D4,D5,D6,D7]) :-
    employees(E),

    two_distinct(A1,A2,E), D1 = [A1,A2],

    two_distinct(B1,B2,E),
    D2 = [B1,B2],
    no_common(D1,D2),

    two_distinct(C1,C2,E),
    D3 = [C1,C2],
    no_common(D2,D3),

    two_distinct(D1a,D2a,E),
    D4 = [D1a,D2a],
    no_common(D3,D4),

    two_distinct(E1a,E2a,E),
    D5 = [E1a,E2a],
    no_common(D4,D5),

    two_distinct(F1,F2,E),
    D6 = [F1,F2],
    no_common(D5,D6),

    two_distinct(G1,G2,E),
    D7 = [G1,G2],
    no_common(D6,D7),

    flatten([D1,D2,D3,D4,D5,D6,D7],All),
    valid_workload(All).