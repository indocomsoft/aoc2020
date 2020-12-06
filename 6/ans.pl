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

process_raw_group_union([X], Ans) :- string_codes(X, Ans).
process_raw_group_union([X|Xs], Ans) :-
  process_raw_group_union(Xs, NewAns),
  string_codes(X, XCode),
  list_to_set(XCode, XCodeSet),
  union(NewAns, XCodeSet, Ans).

process_raw_groups_union([], []).
process_raw_groups_union([RawGroup|RawGroups], [Group|Groups]) :-
  process_raw_group_union(RawGroup, Group),
  process_raw_groups_union(RawGroups, Groups).

process_raw_group_intersection([X], Ans) :- string_codes(X, Ans).
process_raw_group_intersection([X|Xs], Ans) :-
  process_raw_group_intersection(Xs, NewAns),
  string_codes(X, XCode),
  list_to_set(XCode, XCodeSet),
  intersection(NewAns, XCodeSet, Ans).

process_raw_groups_intersection([], []).
process_raw_groups_intersection([RawGroup|RawGroups], [Group|Groups]) :-
  process_raw_group_intersection(RawGroup, Group),
  process_raw_groups_intersection(RawGroups, Groups).

count_sum_length([], 0).
count_sum_length([X|Xs], Ans) :-
  count_sum_length(Xs, NewAns),
  length(X, XLength),
  Ans #= NewAns + XLength.

part1(Xs, Ans) :-
  process_raw_groups_union(Xs, Groups),
  count_sum_length(Groups, Ans).

part2(Xs, Ans) :-
  process_raw_groups_intersection(Xs, Groups),
  count_sum_length(Groups, Ans).

main :-
  input(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
