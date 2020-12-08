:- dynamic(visited/1).

input([]) :- at_end_of_stream(current_input).
input([X|Xs]) :-
  read_line_to_string(current_input, Line),
  split_string(Line, " ", "", [Op, ArgString]),
  number_string(Arg, ArgString),
  X = [Op, Arg],
  input(Xs).

% Defines insn/2 dynamically
def_insn(Xs) :- def_insn(Xs, 0).
def_insn([], _).
def_insn([X|Xs], Idx) :-
  assertz(insn(Idx, X)),
  NewIdx is Idx + 1,
  def_insn(Xs, NewIdx).

interpret(["jmp", Arg], Acc, OldPC, Acc, NewPC) :- NewPC is OldPC + Arg.
interpret(["nop", _], Acc, OldPC, Acc, NewPC) :- NewPC is OldPC + 1.
interpret(["acc", Arg], OldAcc, OldPC, NewAcc, NewPC) :-
  NewAcc is OldAcc + Arg,
  NewPC is OldPC + 1.

interpret_until_repetition(Xs, Ans) :-
  def_insn(Xs),
  interpret_until_repetition(0, 0, Ans),
  retractall(insn(_, _)).
interpret_until_repetition(Acc, PC, FinalAcc) :-
  visited(PC),
  FinalAcc = Acc,
  retractall(visited(_)).
interpret_until_repetition(Acc, PC, FinalAcc) :-
  assertz(visited(PC)),
  insn(PC, Insn),
  interpret(Insn, Acc, PC, NewAcc, NewPC),
  interpret_until_repetition(NewAcc, NewPC, FinalAcc).

interpret_until_end(Xs, Ans) :-
  def_insn(Xs),
  interpret_until_end(0, 0, Ans),
  retractall(insn(_, _)).
interpret_until_end(Acc, PC, FinalAcc) :-
  insn(PC, Insn),
  interpret(Insn, Acc, PC, NewAcc, NewPC),
  interpret_until_end(NewAcc, NewPC, FinalAcc).
interpret_until_end(Acc, _PC, Acc).

replace_jmp_nop([], []).
replace_jmp_nop([["jmp", Arg]|Xs], [["nop", Arg]|Xs]).
replace_jmp_nop([["nop", Arg]|Xs], [["jmp", Arg]|Xs]).
replace_jmp_nop([X|Xs], [X|Rest]) :- replace_jmp_nop(Xs, Rest).

find_terminating_input(Xs, Ans) :-
  replace_jmp_nop(Xs, Ans),
  \+ interpret_until_repetition(Ans, _).

part2(Xs, Ans) :-
  find_terminating_input(Xs, NewXs),
  interpret_until_end(NewXs, Ans).

main :-
  input(Xs),
  interpret_until_repetition(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
