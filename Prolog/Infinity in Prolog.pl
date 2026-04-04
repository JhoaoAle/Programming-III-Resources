brother(X,Y):-brother(Y,X).
brother(paul,peter).
%brother(X,Y):-brother(Y,X), !.
%brother(paul,peter).

brother_of(paul,peter).
brother_of(peter,adrian).
%brother_of(X,Y):- brother_of(X,Z),brother_of(Z,Y).
brother_of(X,Y):- brother_of(X,Z),brother_of(Z,Y),!.

