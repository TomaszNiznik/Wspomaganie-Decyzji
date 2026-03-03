% Use this editor as a MiniZinc scratch book
% Zadanie 2 - tablice

int: budget = 1505;

int: n = 6;
array[1..n] of string: name =
  ["Owoce", "Frytki", "Salatka", "Skrzydelka", "Paluszki", "Zestaw_probny"];
array[1..n] of int: price =
  [215, 275, 335, 355, 420, 580];

% ile sztuk kazdego produktu (nieujemne)
array[1..n] of var 0..(budget div min(price)): x;

constraint sum(i in 1..n)(price[i] * x[i]) = budget;

solve satisfy;

output [
  "budget=", show(budget), "\n",
  concat([ name[i] ++ "=" ++ show(x[i]) ++ " " | i in 1..n ]),
  "\n"
];