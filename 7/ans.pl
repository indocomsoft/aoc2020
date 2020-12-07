% Defines bag_content/2 dynamically
input :-
  at_end_of_stream(current_input),
  compile_predicates([bag_content/2]).
input :-
  read_line_to_string(current_input, Line),
  process_line(Line),
  input.

get_color(Bag, Color) :- string_concat(Color, " bags", Bag).
get_color(Bag, Color) :- string_concat(Color, " bag", Bag).

process_line(X) :-
  sub_string(X, BeforeLength, _, AfterLength, " contain "),
  sub_string(X, 0, BeforeLength, _, Bag),
  get_color(Bag, Color),
  sub_string(X, _, AfterLength, 0, After),
  split_string(After, ",", " .", RawContent),
  process_content(RawContent, Content),
  assertz(bag_content(Color, Content)).

process_content([], []).
process_content(["no other bags"], []).
process_content([X|Xs], [Ans|Rest]) :-
  split_string(X, " ", "", [NumString|_]),
  number_string(Num, NumString),
  string_concat(NumString, " ", NumStringWithSpace),
  string_concat(NumStringWithSpace, Bag, X),
  get_color(Bag, Color),
  Ans = [Num, Color],
  process_content(Xs, Rest).

content_contains(Color, [[_, Color]|_]).
content_contains(Color, [[_, _]|Xs]) :- content_contains(Color, Xs).

contains_shiny_gold([Color|Xs]) :-
  bag_content(Color, Content),
  colors_from_content(Content, Colors),
  once(
    content_contains("shiny gold", Content);
    contains_shiny_gold(Xs);
    contains_shiny_gold(Colors)
  ).

colors_from_content([], []).
colors_from_content([[_, Color]|Xs], [Color|Rest]) :- colors_from_content(Xs, Rest).

total_num_content([], 0).
total_num_content([[Num, Color]|Xs], Ans) :-
  total_num_content(Xs, NewAns),
  bag_content(Color, Content),
  total_num_content(Content, NumContent),
  Ans is NewAns + Num * NumContent + Num.

part1(Ans) :-
  findall(Color, bag_content(Color, _), Colors),
  part1_helper(Colors, Ans).

part1_helper([], 0).
part1_helper([Color|Xs], Ans) :-
  part1_helper(Xs, NewAns),
  (contains_shiny_gold([Color]) -> Ans is NewAns + 1; Ans is NewAns).

part2(Ans) :-
  total_num_content([[1, "shiny gold"]], AnsPlusOne),
  Ans is AnsPlusOne - 1.

main :-
  input,
  part1(Ans1),
  writeln(Ans1),
  part2(Ans2),
  writeln(Ans2).
