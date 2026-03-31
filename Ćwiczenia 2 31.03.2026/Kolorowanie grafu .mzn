%%%%%%%%%%%%%%%%%%%%%
%kolorowanie wierzchołków grafu
int: nodesNumber = 5;
int: m = 6; %liczba krawędzi
int: k = 3; %liczba dostępnych kolorów

% Lista krawędzi - poprawna składnia MiniZinc
array[1..m, 1..2] of int: edgeList = 
[|1,2|1,5|2,3|3,4|4,5|5,3|];

% Kolory wierzchołków
array[1..nodesNumber] of var 1..k: nodes;

% Minimalna liczba kolorów
var 1..nodesNumber: colorsNumber = max(nodes);

constraint
% dla każdej krawędzi (u,v) z edgeList: nodes[u] != nodes[v]
forall(i in 1..m) (
    nodes[edgeList[i,1]] != nodes[edgeList[i,2]]
);

solve minimize colorsNumber;

output 
[show(colorsNumber), " colors\n"] ++
["Kolory: ", show(nodes), "\n"] ++
["Krawędzie: ", show(edgeList), "\n"];