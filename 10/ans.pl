input([]) :- at_end_of_stream(current_input).
input([X|Xs]) :-
  read_line_to_string(current_input, Line),
  number_string(X, Line),
  input(Xs).

part1(Sorted, Ans) :-
  part1_helper(Sorted, 0, NumOneJolt, NumThreeJolt),
  Ans is NumOneJolt * NumThreeJolt.

part1_helper([], _, 0, 1).
part1_helper([X|Xs], Current, NumOneJolt, NumThreeJolt) :-
  Diff is X - Current,
  part1_helper(Xs, X, NewNumOneJolt, NewNumThreeJolt),
  (Diff is 1 ->
    NumOneJolt is NewNumOneJolt + 1
  ; NumOneJolt is NewNumOneJolt
  ),
  (Diff is 3 ->
    NumThreeJolt is NewNumThreeJolt + 1
  ; NumThreeJolt is NewNumThreeJolt
  ).

:- table(num_valid_arrangement/2).
num_valid_arrangement([], 1).
num_valid_arrangement([X|Xs], Ans) :-
  % Get result for the immediately next one
  num_valid_arrangement(Xs, Ans1),
  % Try for a further 2 after the immediately next one.
  % Beyond 3 from current, it is guaranteed there will be no element within 3
  % from the current jolt.
  ([_,X2|T2] = Xs, X2 - X =< 3 ->
    num_valid_arrangement([X2|T2], Ans2),
    ([X3|T3] = T2, X3 - X =< 3 ->
      num_valid_arrangement([X3|T3], Ans3),
      Ans is Ans1 + Ans2 + Ans3
    ; Ans is Ans1 + Ans2
    )
  ; Ans is Ans1
  ).

part2(Sorted, Ans) :-
  max_list(Sorted, Max),
  End is Max + 3,
  append([[0], Sorted, [End]], Input),
  num_valid_arrangement(Input, Ans).

main :-
  input(Xs),
  sort(Xs, Sorted),
  part1(Sorted, Ans1),
  writeln(Ans1),
  part2(Sorted, Ans2),
  writeln(Ans2).
