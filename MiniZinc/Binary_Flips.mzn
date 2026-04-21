int: n = 50;        
int: m = 10;      

array[1..n, 1..m] of var 0..1: x;

constraint
  forall(i, j in 1..n where i < j) (
    sum(k in 1..m)(bool2int(x[i,k] != x[j,k])) >= 2
  );
 
constraint
  forall(i in 1..n) (
    sum(k in 1..m)(x[i,k]) >= m-2
  );

solve satisfy;

