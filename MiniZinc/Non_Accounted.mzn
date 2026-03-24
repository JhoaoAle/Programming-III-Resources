var 100..1240: hires;

constraint hires mod 5 = 2;
constraint hires mod 7 = 2;
constraint hires mod 12 = 1;

solve satisfy;