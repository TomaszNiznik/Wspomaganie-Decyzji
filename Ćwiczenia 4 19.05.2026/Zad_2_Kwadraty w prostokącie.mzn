% =====================================================================
% PLIKI POMOCNICZE / WARUNKI Z TREŚCI ZADANIA (Narzędzia)
% =====================================================================

% Warunek 1: Alldifferent
predicate alldifferent(array[int] of var int: x) =
    forall(i, j in index_set(x) where i < j)(x[i] != x[j]);

% Warunek 2: Inverse
predicate inverse(array[int] of var int: f, array[int] of var int: g) =
    let { int: n = length(f) } in
    forall(i in 1..n)(g[f[i]] = i) /\
    forall(j in 1..n)(f[g[j]] = j);

% Warunek 3: Diffn (brak nakładania się kwadratów)
predicate diffn(array[int] of var int: x,
                array[int] of var int: y,
                array[int] of int: dx,
                array[int] of int: dy) =
    forall(i, j in index_set(x) where i < j)(
        x[i] + dx[i] <= x[j] \/
        x[j] + dx[j] <= x[i] \/
        y[i] + dy[i] <= y[j] \/
        y[j] + dy[j] <= y[i]
    );

% Warunek 4: Cumulative (optymalizacja zasobów/przestrzeni)
predicate cumulative(array[int] of var int: s,  
                     array[int] of int: d,      
                     array[int] of int: r,      
                     var int: b) =                  
    forall(t in 0..sum(d)) (
        sum(i in index_set(s)) (
            bool2int(s[i] <= t /\ t < s[i] + d[i]) * r[i]
        ) <= b
    );

% Warunek 5: Dane wejściowe
int: n = 6;

% =====================================================================
% LOGIKA MODELU I ZMIENNE DECYZYJNE
% =====================================================================

% Rozmiary boków kwadratów (od 1 do n, czyli 1, 2, 3, 4, 5, 6)
array[1..n] of int: sizes = [i | i in 1..n];

% Maksymalny możliwy wymiar kontenera (suma wszystkich boków)
int: max_dim = sum(sizes);

var 1..max_dim: width;          % Szerokość kontenera
var 1..max_dim: height;         % Wysokość kontenera
var int: area = width * height; % Pole powierzchni, które minimalizujemy

% Współrzędne (x, y) lewego dolnego rogu każdego z kwadratów
array[1..n] of var 0..max_dim: x;
array[1..n] of var 0..max_dim: y;

% =====================================================================
% GŁÓWNE OGRANICZENIA GEOMETRYCZNE
% =====================================================================

% Kwadraty muszą w całości mieścić się wewnątrz kontenera
constraint forall(i in 1..n)(x[i] + sizes[i] <= width);
constraint forall(i in 1..n)(y[i] + sizes[i] <= height);

% Żaden kwadrat nie może nachodzić na inny
constraint diffn(x, y, sizes, sizes);

% Profile cumulative dla osi X i Y poprawiające wydajność poszukiwań
constraint cumulative(x, sizes, sizes, height);
constraint cumulative(y, sizes, sizes, width);

% =====================================================================
% DODATKOWE OGRANICZENIA PRZESTRZENNE (Zadanie 2)
% =====================================================================

% Ograniczenie 1: Największy kwadrat (indeks n=6) przylega do lewej krawędzi
constraint x[n] = 0;

% Ograniczenie 2: Co najmniej jeden kwadrat dotyka górnej krawędzi kontenera
constraint exists(i in 1..n)(y[i] + sizes[i] = height);

% =====================================================================
% FUNKCJA CELU I FORMATOWANIE WYNIKU
% =====================================================================

% Szukamy układu o jak najmniejszym polu powierzchni kontenera
solve minimize area;

output [
  "Kontener: " ++ show(width) ++ " x " ++ show(height) ++ " (Pole: " ++ show(area) ++ ")\n",
  "Pozycje kwadratów (lewy dolny róg x, y):\n"
] ++ 
[ "Kwadrat " ++ show(i) ++ "x" ++ show(i) ++ " na pozycji: (" ++ show(x[i]) ++ ", " ++ show(y[i]) ++ ")\n" | i in 1..n ];