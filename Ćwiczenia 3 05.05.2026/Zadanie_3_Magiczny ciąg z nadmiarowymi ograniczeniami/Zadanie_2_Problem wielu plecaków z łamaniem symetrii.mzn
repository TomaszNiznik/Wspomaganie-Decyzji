include "globals.mzn";

% Parametry wczytywane z plików .dzn
int: items_n;
int: knapsacks_n;
int: capacity;
array[1..items_n] of int: values;
array[1..items_n] of int: weights;

% Decyzje modelu
% assignment[i] = j oznacza, że przedmiot i trafia do plecaka j. 
% 0 oznacza, że przedmiot nie został wybrany.
array[1..items_n] of var 0..knapsacks_n: assignment;

% Pomocnicza macierz binarna dla łamania symetrii
array[1..knapsacks_n, 1..items_n] of var 0..1: taken = 
    array2d(1..knapsacks_n, 1..items_n, [bool2int(assignment[j] == i) | i in 1..knapsacks_n, j in 1..items_n]);

% 1. Ograniczenie pojemności dla każdego plecaka
constraint forall(k in 1..knapsacks_n) (
    sum(i in 1..items_n where assignment[i] == k) (weights[i]) <= capacity
);

% 2. ŁAMANIE SYMETRII (lex_less)
% Skoro plecaki są identyczne, wymuszamy porządek leksykograficzny, 
% aby solver nie sprawdzał zamiany całych plecaków miejscami.
constraint forall(k in 1..knapsacks_n-1) (
    lex_less([taken[k, i] | i in 1..items_n], [taken[k+1, i] | i in 1..items_n])
);

% Cel: Maksymalizacja sumy wartości wybranych przedmiotów
var int: total_value = sum(i in 1..items_n where assignment[i] > 0) (values[i]);

solve maximize total_value;

% Wyjście
output [
    "Całkowita wartość: ", show(total_value), "\n",
    "Przypisanie (przedmiot: plecak): ", show(assignment), "\n"
] ++ [
    "Plecak " ++ show(k) ++ " waga: " ++ 
    show(sum(i in 1..items_n where assignment[i] == k) (weights[i])) ++ "\n"
    | k in 1..knapsacks_n
];