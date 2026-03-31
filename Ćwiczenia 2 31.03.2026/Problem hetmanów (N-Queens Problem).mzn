% Use this editor as a MiniZinc scratch book
int: N; %rozmiar szachownicy
array[1..N] of var 1..N: rows; %rows[i] numer wiersa w którym stoi hetman w kolumnie i
% np. rows = [4, 2, 7, ...] w kolumnie 1 hetman w wierszu 4, w kolumnie 2 hetman w wierszy 2, itd
include "alldifferent.mzn";
constraint
% żadnych dwóch hetmanów nie może być w tej samej kolumnie
alldifferent(rows)
/\
%alldifferent(rows) - żaden wiersz się nie powtarza
% żadnych dwóch hetmanów nie może być na tej samej przekątnej do góry
alldifferent([rows[i] + i | i in 1..N])
/\
% żadnych dwóch hetmanów nie może być na tej samej przekątnej do dołu
alldifferent([rows[i] - i | i in 1..N]);
% rows[i] + i to numer przekątnej w kierunku z lewej górnej do prawej dolnej
% rows[i] - i to numer przekątnej w kierunku z prawej górnej do lewej dolnej 

solve satisfy;

output
["rows = \(rows)\n"] ++
[if j = fix(rows[i]) then "H" else "." endif ++
 if j = N then "\n" else " " endif | i in 1..N, j in 1..N] ++
["----------\n"];