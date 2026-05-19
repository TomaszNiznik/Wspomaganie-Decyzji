include "alldifferent.mzn";

int: n = 16;
array[1..n] of var 1..n: rows;

% 1. Główne zasady gry w hetmany
constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in 1..n]);
constraint alldifferent([rows[i] - i | i in 1..n]);

% 2. Dodatkowe ograniczenia (Zadanie 1)
constraint rows[1] != 1;                        % Blokada lewego górnego rogu
constraint sum(i in 1..n)(rows[i] <= 8) = 8;    % Dokładnie 8 hetmanów w górnej połowie

solve satisfy;

% Proste wypisanie wyniku
output [show(rows)];