%%%%%%%%%%%%%%%%%%%%%
%Magiczny kwadrat 3x3
include "alldifferent.mzn";

int: n = 3;
int: n2 = n*n;
array[1..n, 1..n] of var 1..n2: square;
int: magic_sum = n*(n2+1) div 2; % 3*(9+1)/2 = 15

% Wszystkie liczby 1..9 dokładnie raz
constraint alldifferent([square[i,j] | i,j in 1..n]);

constraint
% suma wierszy = magic_sum
forall(i in 1..n) (
    sum([square[i,j] | j in 1..n]) = magic_sum
)
/\
% suma kolumn = magic_sum
forall(j in 1..n) (
    sum([square[i,j] | i in 1..n]) = magic_sum
)
/\
% suma przekątnych = magic_sum
sum([square[i,i] | i in 1..n]) = magic_sum /\
sum([square[i,n+1-i] | i in 1..n]) = magic_sum;

solve satisfy;

output [
   if j=1 then "\n" else "" endif ++
   show(square[i,j]) ++
   if j=n then "\n" else " " endif 
   | i, j in 1..n
];