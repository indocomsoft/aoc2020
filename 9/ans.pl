:- use_module(library(clpfd)).

input([]) :- at_end_of_stream(current_input).
input([X|Xs]) :-
  read_line_to_string(current_input, Line),
  number_string(X, Line),
  input(Xs).

powerset([], []).
powerset([_|Xs], Y) :- powerset(Xs, Y).
powerset([X|Xs], [X|Ys]) :- powerset(Xs, Ys).

valid(X, Preamble) :-
  powerset(Preamble, [A, B]),
  X #= A + B,
  all_distinct([A, B]).

first_invalid(Xs, PreambleLength, Ans) :-
  length(Preamble, PreambleLength),
  append(Preamble, [X|_], Xs),
  (valid(X, Preamble) ->
    [_|T] = Xs,
    first_invalid(T, PreambleLength, Ans)
  ; Ans = X
  ).

part1(Xs, Ans) :- first_invalid(Xs, 25, Ans).

part2(X, Xs, Ans) :-
  SetLength #>= 2,
  length(Set, SetLength),
  append([_, Set, _], Xs),
  sum(Set, #=, X),
  min_list(Set, Min),
  max_list(Set, Max),
  Ans #= Min + Max.

main :-
  input(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Ans1, Xs, Ans2),
  writeln(Ans2).
