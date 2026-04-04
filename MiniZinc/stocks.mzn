enum STOCKS;
int: budget;
array[STOCKS] of int: expected_return;
array[STOCKS] of int: cost;

array[STOCKS] of var int: stocks_to_buy;

constraint forall(i in STOCKS)(stocks_to_buy[i] >= 0);
constraint sum(i in STOCKS)(stocks_to_buy[i]*cost[i]) <= budget;

solve maximize sum(i in STOCKS)(stocks_to_buy[i]*expected_return[i]);

output["Amount: ", show(stocks_to_buy), "\n"];
