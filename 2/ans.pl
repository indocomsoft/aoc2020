input([]) :- at_end_of_stream(current_input).
input([X|Xs]) :-
  read_line_to_string(current_input, Line),
  split_string(Line, ' ', ':', [Range, LetterString, PasswordString]),
  split_string(Range, '-', '-', [LoString, HiString]),
  number_codes(Lo, LoString),
  number_codes(Hi, HiString),
  string_chars(PasswordString, Password),
  string_chars(LetterString, [Letter]),
  X = [Lo, Hi, Letter, Password],
  input(Xs).

count(_, [], 0).
count(X, [X|Xs], Ans) :- count(X, Xs, NewAns), Ans is NewAns + 1, !.
count(X, [_|Xs], Ans) :- count(X, Xs, Ans).

part1([], 0).
part1([[Lo, Hi, Letter, Password]|Xs], Ans) :-
  part1(Xs, NewAns),
  count(Letter, Password, Count),
  incrementIfInRange(Lo, Hi, Count, NewAns, Ans).

incrementIfInRange(Lo, Hi, X, Count, NewCount) :-
  X >= Lo,
  X =< Hi,
  !,
  NewCount is Count + 1.
incrementIfInRange(_, _, _, Count, Count).

part2([], 0).
part2([[Lo, Hi, Letter, Password]|Xs], Ans) :-
  part2(Xs, NewAns),
  LoIndex is Lo - 1,
  HiIndex is Hi - 1,
  nth0(LoIndex, Password, LoLetter),
  nth0(HiIndex, Password, HiLetter),
  count(Letter, [LoLetter, HiLetter], Count),
  incrementIfOne(Count, NewAns, Ans).

incrementIfOne(1, Count, NewCount) :- NewCount is Count + 1.
incrementIfOne(_, Count, Count).

main :-
  input(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
