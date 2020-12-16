:- use_module(library(clpfd)).

input(Stream, []) :- at_end_of_stream(Stream).
input(Stream, [Line|Lines]) :-
  read_line_to_string(Stream, Line),
  input(Stream, Lines).

parse_constraint(Constraint, Low, High) :-
  split_string(Constraint, "-", "", Nums),
  maplist(number_string, [Low, High], Nums).

parse(Lines, Xs) :-
  parse_fields(Lines, Fields, LinesAfterFields),
  parse_your(LinesAfterFields, YourTicket, LinesAfterYour),
  parse_nearby(LinesAfterYour, NearbyTickets),
  Xs = [Fields, YourTicket, NearbyTickets].

parse_fields(["", "your ticket:"|Xs], [], Xs).
parse_fields([X|Xs], [Field|Fields], LinesAfterFields) :-
  split_string(X, ":", " ", [FieldName, Constraint]),
  sub_string(Constraint, Before, _, After, " or "),
  sub_string(Constraint, 0, Before, _, Constraint1),
  sub_string(Constraint, _, After, 0, Constraint2),
  maplist(parse_constraint, [Constraint1, Constraint2], [Lo1, Lo2], [Hi1, Hi2]),
  F in Lo1..Hi1 \/ Lo2..Hi2,
  Field = FieldName-F,
  parse_fields(Xs, Fields, LinesAfterFields).

parse_your([Line, "", "nearby tickets:"|Xs], Ans, Xs) :-
  split_string(Line, ",", "", NumString),
  maplist(number_string, Ans, NumString).

parse_nearby([], []).
parse_nearby([X|Xs], [Ticket|Tickets]) :-
  split_string(X, ",", "", TicketString),
  maplist(number_string, Ticket, TicketString),
  parse_nearby(Xs, Tickets).

part1(Lines, Ans) :-
  parse(Lines, [Fields, _, Tickets]),
  do_part1(Tickets, Fields, 0, Ans).

in_range([_-F|_], Num) :- copy_term(F, G, Goals), maplist(call, Goals), G #= Num.
in_range([_|Fields], Num) :- in_range(Fields, Num).

do_part1([], _, Ans, Ans).
do_part1([Ticket|Tickets], Fields, Counter, Ans) :-
  exclude(in_range(Fields), Ticket, FailingTickets),
  sum_list(FailingTickets, Sum),
  NewCounter #= Sum + Counter,
  do_part1(Tickets, Fields, NewCounter, Ans).

invalid_ticket(Fields, NumList) :-
  length(NumList, Length),
  length(FieldsList, Length),
  maplist(=(Fields), FieldsList),
  \+ concurrent_maplist(in_range, FieldsList, NumList).

get_field_constraint(_-F, F).

valid_permutation(Fields, Tickets) :-
  transpose(Tickets, Transposed),
  maplist(get_field_constraint, Fields, FieldConstraints),
  concurrent_maplist(valid_field, FieldConstraints, Transposed).

valid_field(_, []).
valid_field(F, [Num|Nums]) :-
  copy_term(F, G, Goals),
  maplist(call, Goals),
  G #= Num,
  valid_field(F, Nums).

part2(Lines, Ans) :-
  parse(Lines, [Fields, YourTicket, NearbyTickets]),
  exclude(invalid_ticket(Fields), NearbyTickets, ValidNearbyTickets),
  %%
  %length(ValidNearbyTickets, LengthValidNearbyTickets),
  %print([LengthValidNearbyTickets, ValidNearbyTickets]), nl,
  %%
  permutation(Fields, PermutedFields),
  %%
  %print(PermutedFields), nl,
  %%
  valid_permutation(PermutedFields, ValidNearbyTickets),
  get_sum_departure(PermutedFields, YourTicket, 0, Ans).

get_sum_departure([], [], Ans, Ans).
get_sum_departure([FieldName-_|Fields], [Num|Nums], Counter, Ans) :-
  (sub_string(FieldName, 0, _, _, "departure") ->
    NewCounter #= Counter + Num
  ; NewCounter = Counter
  ),
  get_sum_departure(Fields, Nums, NewCounter, Ans).

main :-
  input(current_input, Lines),
  part1(Lines, Ans1),
  writeln(Ans1).

main2 :-
  input(current_input, Lines),
  part2(Lines, Ans2),
  writeln(Ans2).
