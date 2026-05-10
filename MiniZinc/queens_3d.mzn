include "globals.mzn";

int: N = 8;

array[1..N] of var 1..N: x;
array[1..N] of var 1..N: y;
array[1..N] of var 1..N: z;

% Symmetry breaking
constraint x = [i | i in 1..N];

constraint alldifferent(y);
constraint alldifferent(z);

constraint
forall(i, j in 1..N where i < j) (
    let {
        var int: dx = abs(x[i] - x[j]),
        var int: dy = abs(y[i] - y[j]),
        var int: dz = abs(z[i] - z[j])
    } in
    not (
        (dx = 0 /\ dy = dz) \/
        (dy = 0 /\ dx = dz) \/
        (dz = 0 /\ dx = dy) \/
        (dx = dy /\ dy = dz)
    )
);

solve :: int_search(y ++ z, first_fail, indomain_min, complete)
satisfy;