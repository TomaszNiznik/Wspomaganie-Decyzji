% Wersja 1: Model bez ograniczeń nadmiarowych
int: n; 
set of int: range = 0..n-1;

array[range] of var 0..n-1: magic;

% Główny warunek: magic[i] to liczba wystąpień i w ciągu
constraint forall(i in range) (
    magic[i] = sum(j in range) (bool2int(magic[j] == i))
);

solve satisfy;

output ["magic = ", show(magic)];