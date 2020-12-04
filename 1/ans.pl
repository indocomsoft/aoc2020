:- use_module(library(clpfd)).

input_numbers([]) :- at_end_of_stream(current_input).
input_numbers([X|Xs]) :-
  read_line_to_string(current_input, Line),
  number_codes(X, Line),
  input_numbers(Xs).

powerset([], []).
powerset([_|Xs], Y) :- powerset(Xs, Y).
powerset([X|Xs], [X|Ys]) :- powerset(Xs, Ys).

part1(Xs, Ans) :-
  [A, B] = Subset,
  2020 #= A + B,
  powerset(Xs, Subset),
  Ans #= A * B.


part2(Xs, Ans) :-
  [A, B, C] = Subset,
  2020 #= A + B + C,
  powerset(Xs, Subset),
  Ans #= A * B * C.

main :-
  input_numbers(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
