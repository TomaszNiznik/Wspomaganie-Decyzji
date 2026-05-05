include "globals.mzn";

% Wersja 3: Wykorzystanie globalnego ograniczenia distribute
int: n; 
array[0..n-1] of var 0..n-1: magic;

% Distribute automatycznie zlicza wystąpienia
constraint distribute(magic, array1d(0..n-1, [i | i in 0..n-1]), magic);

% Dodatkowe ograniczenia dla maksymalnej szybkości
constraint sum(magic) = n;
constraint sum(i in 0..n-1) (magic[i] * i) = n;

solve satisfy;


output ["magic = ", show(magic)];