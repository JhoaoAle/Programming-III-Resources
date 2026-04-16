int: N = 7;
int: D = 10;

set of int: Nurses = 1..N;
set of int: Days = 1..D;

array[Nurses, Days] of var 0..2: shift;

% Daily staffing requirements
constraint
  forall(d in Days) (
    sum(n in Nurses)(bool2int(shift[n,d] = 1)) = 3 /\
    sum(n in Nurses)(bool2int(shift[n,d] = 2)) = 2
  );


% At least 2 night shifts per nurse
constraint
  forall(n in Nurses) (
    sum(d in Days)(bool2int(shift[n,d] = 2)) >= 2
  );


% No 3 consecutive night shifts
constraint
  forall(n in Nurses, d in 1..D-2) (
    not (shift[n,d] = 2 /\ shift[n,d+1] = 2 /\ shift[n,d+2] = 2)
  );


% At least one OFF in any 4-day window
constraint
  forall(n in Nurses, d in 1..D-3) (
    sum(i in d..d+3)(bool2int(shift[n,i] = 0)) >= 1
  );

solve satisfy;