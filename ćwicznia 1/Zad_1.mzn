% Use this editor as a MiniZinc scratch book
% Zadanie 1
% Należy znaleźć liczbę posiłków, które można zamówić,
% aby ich łączny koszt wynosił 1505. Wszystkie liczby muszą być nieujemne.

var 0..100: o;   % owoce
var 0..100: f;   % frytki
var 0..100: sa;  % salatka
var 0..100: sk;  % skrzydelka
var 0..100: p;   % paluszki
var 0..100: zp;  % zestaw probny

constraint 215*o + 275*f + 335*sa + 355*sk + 420*p + 580*zp = 1505;


solve satisfy;

output [
  "o=", show(o), " f=", show(f), " sa=", show(sa),
  " sk=", show(sk), " p=", show(p), " zp=", show(zp), "\n"
];
