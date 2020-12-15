input(Stream, Xs) :-
  read_line_to_string(Stream, Line),
  split_string(Line, ",", "", NumStringList),
  maplist(number_string, Xs, NumStringList).

part1(Xs, Ans) :-
  retractall(turn(_, _)),
  do_part1(Xs, _, 1, 2021, Ans),
  retractall(turn(_, _)).

do_part1([], Number, Turn, Turn, Number).
do_part1([], Number, Turn, StopSpoken, Ans) :-
  (turn(Number, NumberTurn) ->
    retractall(turn(Number, NumberTurn)),
    NewNumber is Turn - NumberTurn - 1
  ; NewNumber = 0
  ),
  StoredTurn is Turn - 1,
  assertz(turn(Number, StoredTurn)),
  NewTurn is Turn + 1,
  do_part1([], NewNumber, NewTurn, StopSpoken, Ans).
do_part1([X|Xs], _, Turn, StopSpoken, Ans) :-
  NewTurn is Turn + 1,
  assertz(turn(X, Turn)),
  do_part1(Xs, X, NewTurn, StopSpoken, Ans).

part2(Xs, Ans) :-
  retractall(turn(_, _)),
  once(do_part1(Xs, _, 1, 30000001, Ans)),
  retractall(turn(_, _)).

main :-
  input(current_input, Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
