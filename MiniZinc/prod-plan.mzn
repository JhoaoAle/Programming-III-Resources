% Items
enum ITEMS;

%Profit per unit for each item
array[ITEMS] of float: profit;

%resources
enum RESOURCES;

%Amount of each resource availability
array[RESOURCES] of float: capacity;

%Units of each resource (cost) required to produce 1 unit of product
%      1 unit of product
array[ITEMS, RESOURCES] of float: consumption; 

%Variables: How much to be made/acquired of each item:
array[ITEMS] of var int: produce;

%Must produce a non-negative amount
constraint forall(item in ITEMS)(produce[item] >= 0);

%Production/Acquisition/Usage can only use the available resources:
constraint forall(resource in RESOURCES)(
  sum(item in ITEMS)(consumption[item,resource]*produce[item]) <= capacity[resource]
);

solve maximize sum(item in ITEMS)(produce[item]*profit[item]);

output ["\(i) : \(produce[i])\n" | i in ITEMS] ++
["PROFIT: \(sum(item in ITEMS)(produce[item]*profit[item]))"];