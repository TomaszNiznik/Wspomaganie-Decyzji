include "globals.mzn";

% --- PARAMETRY (Deklaracja) ---
int: n; 
array[1..n] of string: m_names;
array[1..n] of string: w_names;
array[1..n, 1..n] of int: m_ranks;
array[1..n, 1..n] of int: w_ranks;

% --- ZMIENNE DECYZYJNE ---
array[1..n] of var 1..n: wives;    % żona dla m
array[1..n] of var 1..n: husbands; % mąż dla w

% --- OGRANICZENIA GŁÓWNE ---

% 1. Spójność (kanałowanie)
constraint forall(m in 1..n)(husbands[wives[m]] = m);
constraint forall(w in 1..n)(wives[husbands[w]] = w);

% 2. Stabilność
% Jeśli m woli w bardziej niż swoją żonę, to w musi woleć swojego męża bardziej niż m.
constraint forall(m in 1..n, w in 1..n) (
    (m_ranks[m, w] < m_ranks[m, wives[m]]) -> (w_ranks[w, husbands[w]] < w_ranks[w, m])
);

% --- OGRANICZENIA NADMIAROWE ---
constraint alldifferent(wives);
constraint alldifferent(husbands);

solve satisfy;

% --- WYŚWIETLANIE WYNIKU ---
output [ m_names[m] ++ " + " ++ w_names[fix(wives[m])] ++ "\n" | m in 1..n ];