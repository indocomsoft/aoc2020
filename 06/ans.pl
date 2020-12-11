:- use_module(library(clpfd)).

input(Xs) :-
  read_stream_to_codes(current_input, LineCodes),
  string_codes(Line, LineCodes),
  split_string(Line, '\n ', '', Entries),
  split_by_empty(Entries, Xs).

split_by_empty([], []).
split_by_empty(Input, [Ans|Rest]) :-
  append([Ans, [""], NewInput], Input),
  split_by_empty(NewInput, Rest).

process_raw_group([X], Ans, _) :- string_codes(X, Ans).
process_raw_group([X|Xs], Ans, Operator) :-
  process_raw_group(Xs, NewAns, Operator),
  string_codes(X, XCode),
  list_to_set(XCode, XCodeSet),
  call(Operator, NewAns, XCodeSet, Ans).

process_raw_groups([], [], _).
process_raw_groups([RawGroup|RawGroups], [Group|Groups], Operator) :-
  member(Operator, [union, intersection]),
  process_raw_group(RawGroup, Group, Operator),
  process_raw_groups(RawGroups, Groups, Operator).

count_sum_length([], 0).
count_sum_length([X|Xs], Ans) :-
  count_sum_length(Xs, NewAns),
  length(X, XLength),
  Ans #= NewAns + XLength.

part1(Xs, Ans) :-
  process_raw_groups(Xs, Groups, union),
  count_sum_length(Groups, Ans).

part2(Xs, Ans) :-
  process_raw_groups(Xs, Groups, intersection),
  count_sum_length(Groups, Ans).

main :-
  input(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
