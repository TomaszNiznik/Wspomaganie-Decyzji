include "globals.mzn";

int: N;
array[1..N] of var 1..N: rows; % rows[i] = wiersz królowej w kolumnie i
array[1..N] of var 1..N: cols; % cols[r] = kolumna królowej w wierszu r

%Odwrócenie ograniczeń ---
constraint inverse(rows, cols);

% Ograniczenia podstawowe (wystarczą na jednej tablicy, inverse przeniesie wiedzę)
constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in 1..N]);
constraint alldifferent([rows[i] - i | i in 1..N]);

solve satisfy;

output [
    "N = \(N)\n",
    "Rows: \(rows)\n",
    "Cols (perspektywa wierszy): \(cols)"
];