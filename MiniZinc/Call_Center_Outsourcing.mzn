int: budget;

var 0..500: North;
var 0..400: UQ;
var 0..200: Tell_US;
var 0..1000: Conprev;
var 0..100: Conducto;

constraint 13*North + 21*UQ + 25*Tell_US + 5*Conprev + 35*Conducto <= budget;

solve maximize 8*North + 15*UQ + 16*Tell_US + 6*Conprev + 25*Conducto ;

output ["North = \(North) ", 
"UQ = \(UQ) ",
"Tell_US = \(Tell_US) ",
"Conprev = \(Conprev) ",
"Conducto = \(Conducto) \n",
"Average calls per day = \(8*North + 15*UQ + 16*Tell_US + 6*Conprev + 25*Conducto) \n",
"Daily wage cost = \(13*North + 21*UQ + 25*Tell_US + 5*Conprev + 35*Conducto)",
];