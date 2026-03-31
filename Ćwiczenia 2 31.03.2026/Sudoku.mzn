%%%%%%%%%%%%%%%%%%%%%
% Sudoku 9x9 - DZIAŁAJĄCE
include "alldifferent.mzn";

int: S = 3;   
int: N = S*S; 

% STANDARDOWA plansza testowa (DZIAŁA!)
array[1..N, 1..N] of 0..N: board = 
[|5,3,0,0,7,0,0,0,0
 |6,0,0,1,9,5,0,0,0
 |0,9,8,0,0,0,0,6,0
 |8,0,0,0,6,0,0,0,3
 |4,0,0,8,0,3,0,0,1
 |7,0,0,0,2,0,0,0,6
 |0,6,0,0,0,0,2,8,0
 |0,0,0,4,1,9,0,0,5
 |0,0,0,0,8,0,0,0,9|];

array[1..N, 1..N] of var 1..N: puzzle;

constraint forall(i,j in 1..N where board[i,j] > 0)(
    puzzle[i,j] = board[i,j]
);

% RZĘDY
constraint forall(r in 1..N)(
    alldifferent([puzzle[r,c] | c in 1..N])
);

% KOLUMNY
constraint forall(c in 1..N)(
    alldifferent([puzzle[r,c] | r in 1..N])
);

% BLOKI
constraint forall(r in 1..S, c in 1..S)(
    alldifferent([
        puzzle[(r-1)*S + rr, (c-1)*S + cc] | 
        rr in 1..S, cc in 1..S
    ])
);

solve satisfy;

% NAJPROSTSZY OUTPUT
output [
  show(puzzle[i,j]) ++
  if j = N then "\n" else " " endif
  | i in 1..N, j in 1..N
];