input(Xs) :-
  read_stream_to_codes(current_input, LineCodes),
  string_codes(Line, LineCodes),
  split_string(Line, '\n ', '', Entries),
  entry_to_kv(Entries, KVs),
  split_by_empty(KVs, Xs).

entry_to_kv([], []).
entry_to_kv([X|Xs], [KV|Rest]) :-
  split_string(X, ':', '', KV),
  entry_to_kv(Xs, Rest).

split_by_empty([], []).
split_by_empty(Input, [Ans|Rest]) :-
  append([Ans, [[""]], NewInput], Input),
  split_by_empty(NewInput, Rest).

keys([], []).
keys([[K,_V]|Xs], [K|Rest]) :- keys(Xs, Rest).

part1([], 0).
part1([X|Xs], Ans) :-
  part1(Xs, NewAns),
  (validate_fields_existence(X) -> Ans is NewAns + 1; Ans is NewAns).

part2([], 0).
part2([X|Xs], Ans) :-
  part2(Xs, NewAns),
  (validate(X) -> Ans is NewAns + 1 ; Ans is NewAns).

validate(X) :- validate_fields_content(X), validate_fields_existence(X).

validate_fields_existence(X) :-
  keys(X, Keys),
  Required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"],
  intersection(Keys, Required, Intersection),
  length(Required, RequiredLength),
  length(Intersection, IntersectionLength),
  RequiredLength =:= IntersectionLength.

validate_fields_content([]).
validate_fields_content([["byr", BirthYearString]|Xs]) :-
  string_length(BirthYearString, 4),
  number_string(BirthYear, BirthYearString),
  BirthYear >= 1920,
  BirthYear =< 2002,
  validate_fields_content(Xs).
validate_fields_content([["iyr", IssueYearString]|Xs]) :-
  string_length(IssueYearString, 4),
  number_string(IssueYear, IssueYearString),
  IssueYear >= 2010,
  IssueYear =< 2020,
  validate_fields_content(Xs).
validate_fields_content([["eyr", ExpirationYearString]|Xs]) :-
  string_length(ExpirationYearString, 4),
  number_string(ExpirationYear, ExpirationYearString),
  ExpirationYear >= 2020,
  ExpirationYear =< 2030,
  validate_fields_content(Xs).
validate_fields_content([["hgt", HeightString]|Xs]) :-
  sub_string(HeightString, _, 2, 0, Unit),
  sub_string(HeightString, 0, _, 2, HeightWithoutUnitString),
  number_string(HeightWithoutUnit, HeightWithoutUnitString),
  validate_height(HeightWithoutUnit, Unit),
  validate_fields_content(Xs).
validate_fields_content([["hcl", HairColorString]|Xs]) :-
  string_concat("#", Rest, HairColorString),
  string_codes(Rest, RestCodes),
  validate_hair(RestCodes),
  validate_fields_content(Xs).
validate_fields_content([["ecl", EyeColor]|Xs]) :-
  member(EyeColor, ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]),
  validate_fields_content(Xs).
validate_fields_content([["pid", PassportId]|Xs]) :-
  string_length(PassportId, 9),
  number_string(_, PassportId),
  validate_fields_content(Xs).
validate_fields_content([["cid", _]|Xs]) :- validate_fields_content(Xs).

validate_height(Height, "cm") :- Height >= 150, Height =< 193.
validate_height(Height, "in") :- Height >= 59, Height =< 76.

validate_hair([]).
validate_hair([X|Xs]) :-
  ((X >= 48, X =< 57); (X >= 97, X =< 102)),
  validate_hair(Xs).



main :-
  input(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
