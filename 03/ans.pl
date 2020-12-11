input([]) :- at_end_of_stream(current_input).
input([X|Xs]) :-
  read_line_to_codes(current_input, X),
  input(Xs).

check1([], _, _, _, 0).
check1([X|Xs], ColJump, Width, RawLoc, Ans) :-
  ( RawLoc + ColJump >= Width ->
    Loc is RawLoc + ColJump - Width
  ; Loc is RawLoc + ColJump
  ),
  check1(Xs, ColJump, Width, Loc, NewAns),
  nth0(Loc, X, Elem),
  (Elem =:= 35 -> Ans is NewAns + 1; Ans is NewAns).

check2([], _, _, _, 0).
check2([X|Xs], ColJump, Width, RawLoc, Ans) :-
  RawLoc2 is RawLoc + ColJump,
  ( RawLoc2 >= Width -> Loc is RawLoc2 - Width; Loc is RawLoc2),
  length(Xs, XsLength),
  (XsLength =< 1 ->
    NewAns is 0
  ; [_|NewXs] = Xs,
    check2(NewXs, ColJump, Width, Loc, NewAns)
  ),
  nth0(Loc, X, Elem),
  (Elem =:= 35 -> Ans is NewAns + 1; Ans is NewAns).

part1(Xs, Ans) :-
  [X|Map] = Xs,
  length(X, Width),
  check1(Map, 3, Width, 0, Ans).

part2(Xs, Ans) :-
  [X|Map1] = Xs,
  [_,_|Map2] = Xs,
  length(X, Width),
  check1(Map1, 1, Width, 0, Slope11),
  check1(Map1, 3, Width, 0, Slope31),
  check1(Map1, 5, Width, 0, Slope51),
  check1(Map1, 7, Width, 0, Slope71),
  check2(Map2, 1, Width, 0, Slope12),
  Ans is Slope11 * Slope31 * Slope51 * Slope71 * Slope12.

main :-
  input(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
