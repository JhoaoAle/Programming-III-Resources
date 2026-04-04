:- table fib/2.

fib(0, 1) :- !.
fib(1, 1) :- !.
fib(N, Result):-	N1 is N - 1,
    				N2 is N - 2, 
    				fib(N1, Result1), fib(N2, Result2), 
    				Result is Result1 + Result2.



fact(0, 1) :- !.
fact(N, Result) :-
    N1 is N - 1,
    fact(N1, R1),
    Result is N * R1.


countdown(0) :- !.
countdown(N) :-
    write(N), nl,
    N1 is N - 1,
    countdown(N1).

