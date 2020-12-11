input([]) :- at_end_of_stream(current_input).
input([X|Xs]) :-
  read_line_to_codes(current_input, X),
  input(Xs).

bin(66, 1). % B = 1
bin(70, 0). % F = 0
bin(82, 1). % R = 1
bin(76, 0). % L = 0

to_decimal(Xs, Dec) :- reverse(Xs, RevXs), convert(RevXs, Dec).

convert([], 0).
convert([H|T], Dec) :-
  bin(H, HBin),
  convert(T, NextDec),
  Dec is NextDec * 2 + HBin.

seat_ids([], []).
seat_ids([X|Xs], [Ans|Rest]) :- to_decimal(X, Ans), seat_ids(Xs, Rest).

part1(SeatIds, Ans) :- max_list(SeatIds, Ans).

part2(SeatIds, Ans) :-
  max_list(SeatIds, Max),
  min_list(SeatIds, Min),
  numlist(Min, Max, List),
  subtract(List, SeatIds, [Ans]).

main :-
  input(Xs),
  seat_ids(Xs, SeatIds),
  part1(SeatIds, Ans1),
  writeln(Ans1),
  part2(SeatIds, Ans2),
  writeln(Ans2).
