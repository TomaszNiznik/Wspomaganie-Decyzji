include "alldifferent.mzn";

int: N; % Parametr podawany przy uruchomieniu (8, 16, 32)
array[1..N] of var 1..N: rows;

% 1. Każda królowa w innym wierszu
constraint alldifferent(rows);

% 2. Przekątne (suma: wiersz + kolumna)
constraint alldifferent([rows[i] + i | i in 1..N]);

% 3. Przekątne (różnica: wiersz - kolumna)
constraint alldifferent([rows[i] - i | i in 1..N]);

solve satisfy;

output ["N = \(N)\nRows (kolumna -> wiersz): \(rows)"];