% =====================================================
%  list_exercises_debug.pl
%  Prolog List Exercises with Debugging Output
%  Each predicate prints its internal recursive behavior
% =====================================================

% =====================================================
% 1. PRINT ALL ELEMENTS OF A LIST
% Example:
% ?- print_list([a,b,c]).
% =====================================================

print_list([]) :-
write('Reached end of list'), nl, nl.

print_list([H|T]) :-
write('Printing element: '), write(H), nl,
write(H), write(' '),
print_list(T).

% =====================================================
% 2. REVERSE A LIST (WITH DEBUGGING)
% Example:
% ?- reversex([a,b,c],X).
% X = [c,b,a]
% =====================================================

addtoend(H,[],[H]).

addtoend(X,[H|T],[H|T1]) :-
addtoend(X,T,T1).

reversex([],[]) :-
write('Reached base case (empty list)'), nl.

reversex([H|T],Y) :-
write('Reversing: '), write([H|T]), nl,
reversex(T,T1),
write('Adding '), write(H),
write(' to '), write(T1), nl,
addtoend(H,T1,Y).

% =====================================================
% 3. CREATE LIST FROM A TO X
% Example:
% ?- create_list(5,12,S).
% S = [5,6,7,8,9,10,11,12]
% =====================================================

create_list(A,X,[]) :-
A > X,
write('A > X, stopping recursion'), nl.

create_list(X,X,[X]) :-
write('Base case reached at: '), write(X), nl.

create_list(A,X,[A|T]) :-
A < X,
write('Adding element: '), write(A), nl,
AA is A + 1,
create_list(AA,X,T).

% =====================================================
% 4. MEAN VALUE OF A LIST
% Example:
% ?- mean([1,2,3,4,5],M).
% M = 3
% =====================================================

sum_list([],0,0) :-
write('End of list reached'), nl.

sum_list([H|T],Length,Sum) :-
write('Processing element: '), write(H), nl,
sum_list(T,L1,S1),
Length is L1 + 1,
Sum is S1 + H,
write('Current Length: '), write(Length),
write(' Current Sum: '), write(Sum), nl.

mean(L,M) :-
sum_list(L,Length,Sum),
write('Final Sum: '), write(Sum),
write(' Length: '), write(Length), nl,
M is Sum / Length.

% =====================================================
% 5. DETECT IF LIST CONTAINS A NUMBER
% Example:
% ?- numberinlist([a,b,c,1,d]).
% =====================================================

numberinlist([X|_]) :-
write('Checking: '), write(X), nl,
number(X),
write('Number found!'), nl.

numberinlist([H|T]) :-
write('Checking: '), write(H), nl,
+ number(H),
numberinlist(T).

% =====================================================
% 6. INCREMENT EACH ELEMENT OF LIST
% Example:
% ?- increment([5,6,7,8],X).
% X = [6,7,8,9]
% =====================================================

increment([],[]) :-
write('End of list reached'), nl.

increment([H|T],[X|Y]) :-
write('Incrementing: '), write(H), nl,
X is H + 1,
increment(T,Y).

% =====================================================
% 7. APPEND TWO LISTS
% Example:
% ?- appendx([a,1,2],[b,c],X).
% X = [a,1,2,b,c]
% =====================================================

appendx([],A,A) :-
write('First list empty, result is: '), write(A), nl.

appendx([H|T],A,[H|U]) :-
write('Keeping element: '), write(H), nl,
appendx(T,A,U).

% =====================================================
% 8. ENCAPSULATE EACH ELEMENT
% Example:
% ?- encapsulate([a,b,1,d],X).
% X = [[a],[b],[1],[d]]
% =====================================================

encapsulate([],[]) :-
write('Finished encapsulating'), nl.

encapsulate([H|T],[[H]|Y]) :-
write('Encapsulating: '), write(H), nl,
encapsulate(T,Y).

% =====================================================
% 9. INSERT ZERO AFTER EACH ELEMENT
% Example:
% ?- insert_zeros([1,2,3],X).
% X = [1,0,2,0,3,0]
% =====================================================

insert_zeros([],[]) :-
write('Finished inserting zeros'), nl.

insert_zeros([H|T],[H,0|Y]) :-
write('Inserting zero after: '), write(H), nl,
insert_zeros(T,Y).

% =====================================================
% 10. CLONE LIST
% Example:
% ?- clone_list([g,6,7],X).
% X = [[g,6,7],[g,6,7]]
% =====================================================

clone_list(T,[T,T]) :-
write('Cloning list: '), write(T), nl.

% =====================================================
% 11. REMOVE ALL OCCURRENCES OF ELEMENT
% Example:
% ?- remove_all(a,[a,b,a,c,a],X).
% X = [b,c]
% =====================================================

remove_all(_,[],[]) :-
write('End of list reached'), nl.

remove_all(X,[X|T],Y) :-
write('Removing: '), write(X), nl,
remove_all(X,T,Y).

remove_all(X,[H|T],[H|Y]) :-
X = H,
write('Keeping: '), write(H), nl,
remove_all(X,T,Y).

% =====================================================
% 12. CHECK IF LIST IS PALINDROME
% Example:
% ?- palindrome([r,a,d,a,r]).
% =====================================================

palindrome(L) :-
write('Checking palindrome for: '), write(L), nl,
reversex(L,R),
write('Reversed list: '), write(R), nl,
L = R.

% =====================================================
% 13. FLATTEN A NESTED LIST (ADVANCED)
% Example:
% ?- flattenx([a,[b,c],[d,[e]]],X).
% X = [a,b,c,d,e]
% =====================================================

flattenx([],[]) :-
write('Empty list encountered'), nl.

flattenx([H|T],R) :-
write('Processing: '), write(H), nl,
flattenx(H,R1),
flattenx(T,R2),
appendx(R1,R2,R).

flattenx(X,[X]) :-
X = [],
X = [*|*].

% =====================================================
% 14. FIBONACCI (RECURSIVE TRACE)
% Example:
% ?- fib(5,X).
% X = 5
% =====================================================

fib(0,0).
fib(1,1).

fib(N,F) :-
N > 1,
write('Calculating fib('), write(N), write(')'), nl,
N1 is N - 1,
N2 is N - 2,
fib(N1,F1),
fib(N2,F2),
F is F1 + F2.

% ===================== END OF FILE ====================
