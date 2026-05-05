% Parametry wczytywane z plików .dzn
int: nodesNumber;
int: minColorsNumber;
array[int] of int: maxClique; % Dodana deklaracja, aby uniknąć błędu "undefined identifier"
array[1..nodesNumber, 1..nodesNumber] of bool: edges;

% Decyzje modelu
array[1..nodesNumber] of var 1..nodesNumber: nodes;
var 1..nodesNumber: colorsNumber;

% 1. Główny warunek kolorowania: sąsiednie węzły muszą mieć różne kolory
constraint forall(i, j in 1..nodesNumber where i < j) (
    edges[i, j] -> nodes[i] != nodes[j]
);

% 2. Definicja liczby użytych kolorów (minimalizacja maksymalnego indeksu)
constraint colorsNumber = max(nodes);

% 3. ŁAMANIE SYMETRII
% Pierwsze węzły są przypisane do konkretnych kolorów (1..minColorsNumber)
constraint forall(i in 1..minColorsNumber) (
    nodes[i] = i
);

% Cel: Minimalizacja liczby kolorów
solve minimize colorsNumber;

% Wyjście
output ["Liczba kolorów: ", show(colorsNumber), "\nPrzypisanie: ", show(nodes)];