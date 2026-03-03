% Zadanie 4 - optymalizacja smaku

int: budget = 1505;

int: n = 6;
array[1..n] of string: name =
  ["Owoce","Frytki","Salatka","Skrzydelka","Paluszki","Zestaw_probny"];
array[1..n] of int: price = [215, 275, 335, 355, 420, 580];
array[1..n] of int: yum   = [0,   0,   1,   1,   2,   3];

array[1..n] of var 0..100: x;

constraint sum(i in 1..n)(price[i] * x[i]) <= budget;

var int: total_yum = sum(i in 1..n)(yum[i] * x[i]);
solve maximize total_yum;

output [
  "total_yum=", show(total_yum), "\n",
  "spent=", show(sum(i in 1..n)(price[i] * x[i])), " / ", show(budget), "\n",
  concat([ name[i] ++ "=" ++ show(x[i]) ++ " " | i in 1..n ]),
  "\n"
];

