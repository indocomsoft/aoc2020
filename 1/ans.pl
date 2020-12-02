:- use_module(library(clpfd)).

input_numbers([]) :- at_end_of_stream(current_input).
input_numbers([X|Xs]) :-
  read_line_to_string(current_input, Line),
  number_codes(X, Line),
  input_numbers(Xs).

part1(Xs, Ans) :-
  2020 #= A + B,
  member(A, Xs),
  member(B, Xs),
  all_distinct([A, B]),
  Ans #= A * B.

part2(Xs, Ans) :-
  2020 #= A + B + C,
  member(A, Xs),
  member(B, Xs),
  member(C, Xs),
  all_distinct([A, B, C]),
  Ans #= A * B * C.

main :-
  input_numbers(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
