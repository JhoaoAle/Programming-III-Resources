%1. print all elements of a list ?-print_list([a,b,c]). a b c
print_list([]):-nl. %nl = newline
print_list([H|T]):-write(H),write(' '),print_list(T).

%2. reverse all elements of a list ?-reversex([a,b,c],X). X=[c,b,a]
addtoend(H,[],[H]).
addtoend(X,[H|T],[H|T1]):-addtoend(X,T,T1).
reversex([],[]).
reversex([H|T],Y):-
    write('Reversing: '), write([H|T]), nl,
    reversex(T,T1),
    write('Adding '), write(H), write(' to '), write(T1), nl,
    addtoend(H,T1,Y).

%3. create list ?-create_list(5,12,S). S=[5,6,7,8,9,10,11,12]
create_list(X,X,[X]).
create_list(A,X,[A|T]):- AA is A+1, create_list(AA,X,T).

%4. mean value [1,2,3,4,5] => 3
sum_list([],0,0).
sum_list([H|T],Length,Sum):-sum_list(T,L1,S1), Length is L1+1, Sum is S1+H.
mean(L,M):-sum_list(L,Length,Sum), M is Sum/Length.

%5. detect whether list contains a number [a,b,c,d,e,1,f] => T
numberinlist([X|_]) :-
    number(X).

numberinlist([_|T]) :-
    numberinlist(T).

%6. increment elements of list [5,6,7,8] => [6,7,8,9]
increment([],[]).
increment([H|T],[X|Y]):-increment(T,Y),X is H+1.


%8. implement append function [a,1,2,b,c], [b,c,d,e] => [a,1,2,b,c,b,c,d,e]
appendx([],A,A).
appendx([H|T],A,[H|U]):-appendx(T,A,U).

%9. encapsulate list elements [a,b,1,d,e] => [[a],[b],[1],[d],[e]]
encapsulate([],[]).
encapsulate([H|T],[[H]|Y]):-encapsulate(T,Y).

%10. insert zeros [1,2,3,4,5] => [1,0,2,0,3,0,4,0,5,0]
insert_zeros([],[]).
insert_zeros([H|T],[H,0|Y]):-insert_zeros(T,Y).

%11. clone list [g,6,7] => [[g,6,7][g,6,7]]
clone_list(T,[T,T]).