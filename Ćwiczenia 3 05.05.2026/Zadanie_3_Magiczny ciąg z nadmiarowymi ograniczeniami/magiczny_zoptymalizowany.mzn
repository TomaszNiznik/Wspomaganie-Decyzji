% Wersja 2: Model z ograniczeniami nadmiarowymi (zgodnie z instrukcją)
int: n; 
set of int: range = 0..n-1;

array[range] of var 0..n-1: magic;

% 1. Warunek samoreferencyjny
constraint forall(i in range) (
    magic[i] = sum(j in range) (bool2int(magic[j] == i))
);

% 2. Ograniczenie sumy elementów (Nadmiarowe)
constraint sum(magic) = n;

% 3. Ograniczenie ważonej sumy (Nadmiarowe)
constraint sum(j in range) (magic[j] * j) = n;

solve satisfy;

output ["magic = ", show(magic)];