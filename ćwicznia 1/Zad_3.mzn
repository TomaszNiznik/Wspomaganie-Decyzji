% Use this editor as a MiniZinc scratch book
% Zadanie 3 - dane zewnętrzne (.dzn)

int: budget;
int: n;
array[1..n] of string: name;
array[1..n] of int: price;

array[1..n] of var 0..100: x;

constraint sum(i in 1..n)(price[i] * x[i]) = budget;

solve satisfy;

output [
  concat([ name[i] ++ "=" ++ show(x[i]) ++ " " | i in 1..n ]),
  "\n"
];
