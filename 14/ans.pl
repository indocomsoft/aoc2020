:- use_module(library(clpfd)).
:- dynamic mem/2 as private.

input(Stream, []) :- at_end_of_stream(Stream).
input(Stream, [X|Xs]) :-
  read_line_to_string(Stream, Line),
  split_string(Line, "=", " ", Tokens),
  process_tokens(Tokens, X),
  input(Stream, Xs).

process_tokens(["mask", RawMask], [mask, Mask]) :-
  string_codes(RawMask, RawMaskCodes),
  process_mask(RawMaskCodes, 36, Mask).
process_tokens([RawMem, ValueString], [mem, Address, Value]) :-
  number_string(Value, ValueString),
  sub_string(RawMem, 4, _, 1, AddressString),
  number_string(Address, AddressString).

process_mask([], _, []).
process_mask([88|Xs], Counter, Rest) :-
  NewCounter #= Counter - 1,
  process_mask(Xs, NewCounter, Rest).
process_mask([X|Xs], Counter, [Ans|Rest]) :-
  NewCounter #= Counter - 1,
  (X = 48 -> Value = 0 ; X = 49 -> Value = 1),
  Ans = [Counter, Value],
  process_mask(Xs, NewCounter, Rest).


dec_bin_length(N, Bs, Length) :-
  dec_bin(N, Bin),
  append(Zeroes, Bin, Bs),
  length(Bs, Length),
  maplist(=(0), Zeroes),
  !.
dec_bin(N, Bs) :- do_dec_bin(Bs, 0, N, N).
do_dec_bin([], N,N, _M) :- !.
do_dec_bin([B|Bs], N0, N, M) :-
   B in 0..1,
   N1 #= B + 2 * N0,
   M #>= N1,
   do_dec_bin(Bs, N1, N, M).

apply_mask(Value, Mask, Ans) :-
  dec_bin_length(Value, Bin, 36),
  do_apply_mask(Bin, Mask, 36, BinAns),
  dec_bin(Ans, BinAns),
  !.
do_apply_mask([], [], 0, []).
do_apply_mask([_|Bs], [[Counter, Mask]|Masks], Counter, [Mask|Rest]) :-
  NewCounter #= Counter - 1,
  do_apply_mask(Bs, Masks, NewCounter, Rest).
do_apply_mask([B|Bs], Masks, Counter, [B|Rest]) :-
  NewCounter #= Counter - 1,
  do_apply_mask(Bs, Masks, NewCounter, Rest).

part1(Xs, Ans) :-
  retractall(mem(_, _)),
  do_part1(Xs, [], Ans),
  retractall(mem(_, _)).

do_part1([], _, Ans) :- aggregate_all(sum(X), mem(_, X), Ans).
do_part1([[mask, Mask]|Xs], _, Ans) :- do_part1(Xs, Mask, Ans).
do_part1([[mem, Address, Value]|Xs], Mask, Ans) :-
  apply_mask(Value, Mask, MaskedValue),
  retractall(mem(Address, _)),
  (MaskedValue #\= 0 -> assertz(mem(Address, MaskedValue)) ; true),
  do_part1(Xs, Mask, Ans).

apply_addr_mask(Addr, Mask, Ans) :-
  dec_bin_length(Addr, AddrBin, 36),
  findall(X, do_apply_addr_mask(AddrBin, Mask, 36, X), Xs),
  maplist(dec_bin, Ans, Xs).

do_apply_addr_mask([], [], 0, []).
do_apply_addr_mask([B|Bs], [[Counter, Mask]|Masks], Counter, [Ans|Rest]) :-
  (Mask #= 0 -> Ans = B ; Mask #= 1 -> Ans = 1),
  NewCounter is Counter - 1,
  do_apply_addr_mask(Bs, Masks, NewCounter, Rest).
do_apply_addr_mask([_|Bs], Masks, Counter, [Ans|Rest]) :-
  ([[Index, _]|_] = Masks -> Index #\= Counter ; Masks = []),
  (Ans = 0 ; Ans = 1),
  NewCounter is Counter - 1,
  do_apply_addr_mask(Bs, Masks, NewCounter, Rest).

set_addresses([], _).
set_addresses([Address|Addresses], Value) :-
  retractall(mem(Address, _)),
  (Value #\= 0 -> assertz(mem(Address, Value)) ; true),
  set_addresses(Addresses, Value).

part2(Xs, Ans) :-
  retractall(mem(_, _)),
  do_part2(Xs, [], Ans),
  retractall(mem(_, _)).

do_part2([], _, Ans) :- aggregate_all(sum(X), mem(_, X), Ans).
do_part2([[mask, Mask]|Xs], _, Ans) :- do_part2(Xs, Mask, Ans).
do_part2([[mem, Address, Value]|Xs], Mask, Ans) :-
  apply_addr_mask(Address, Mask, MaskedAddresses),
  set_addresses(MaskedAddresses, Value),
  do_part2(Xs, Mask, Ans).

main :-
  input(current_input, Xs),
  concurrent(2, [part1(Xs, Ans1), part2(Xs, Ans2)], []),
  writeln(Ans1),
  writeln(Ans2).
