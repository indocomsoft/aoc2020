input(Stream, Input) :-
  read_line_to_string(Stream, Line1),
  read_line_to_string(Stream, Line2),
  Input = [Line1, Line2].

closest_departing(Bus, Target, Ans) :-
  Ans is ((Target div Bus) + 1) * Bus.

part1([Line1, Line2], Ans) :-
  number_string(Timestamp, Line1),
  split_string(Line2, ",", "", AllBusesString),
  exclude(=("x"), AllBusesString, BusesString),
  maplist(number_string, Buses, BusesString),
  do_part1([Timestamp, Buses], Ans).

do_part1([Timestamp, Buses], Ans) :-
  length(Buses, BusesLength),
  % create a list of timestamp with length of buses
  length(Targets, BusesLength),
  maplist(=(Timestamp), Targets),
  maplist(closest_departing, Buses, Targets, ClosestList),
  min_list(ClosestList, DepartingTime),
  nth0(Index, ClosestList, DepartingTime),
  nth0(Index, Buses, Bus),
  Ans is Bus * (DepartingTime - Timestamp).

process_line2("x", x).
process_line2(BusString, Bus) :- number_string(Bus, BusString).

filter_value(V, _-V).

part2([_, Line2], Ans) :-
  split_string(Line2, ",", "", AllBusesString),
  maplist(process_line2, AllBusesString, Buses),
  length(Buses, BusesLength),
  BusesLengthMinusOne is BusesLength - 1,
  numlist(0, BusesLengthMinusOne, List),
  maplist(crt_input, List, Buses, RawBusIndexList),
  exclude(filter_value(x), RawBusIndexList, BusIndexList),
  crt(BusIndexList, Ans).

crt_input(_, x, x-x).
crt_input(Counter, Bus, Ans) :- Remainder is Bus - Counter, Ans = Remainder-Bus.

product(A, B, C) :- C is A * B.

pair(X, Y, X-Y).

egcd(_, 0, 1, 0) :- !.
egcd(A, B, X, Y) :-
    divmod(A, B, Q, R),
    egcd(B, R, S, X),
    Y is S - Q*X.

modinv(A, B, X) :-
    egcd(A, B, X, Y),
    A*X + B*Y =:= 1.

crt_fold(A, M, P, R0, R1) :- % system of equations of (x = a) (mod m); p = M/m
    modinv(P, M, Inv),
    R1 is R0 + A*Inv*P.

crt(Pairs, N) :-
    maplist(pair, As, Ms, Pairs),
    foldl(product, Ms, 1, M),
    maplist(divmod(M), Ms, Ps, _), % p(n) <- M/m(n)
    foldl(crt_fold, As, Ms, Ps, 0, N0),
    N is N0 mod M.

main :-
  input(current_input, Input),
  part1(Input, Ans1),
  writeln(Ans1),
  part2(Input, Ans2),
  writeln(Ans2).
