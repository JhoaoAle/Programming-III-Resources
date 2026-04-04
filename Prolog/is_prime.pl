divisible(X, Y) :- 
    0 is X mod Y.

% Base case: 2 is a prime number
is_prime(2).

% Check if a number X is prime
is_prime(X) :-
    X > 2,
    not(divisible_by_any(X, 2)).

% Check if X is divisible by any number between Y and X
divisible_by_any(X, Y) :-
    Y*Y =< X,     % We only need to check divisibility up to the square root of X.
    (divisible(X, Y); 
     Y1 is Y + 1, 
     divisible_by_any(X, Y1)).

% Check if 43 is prime
property_43_prime :-
    is_prime(43),
    write('43 is a prime number.').