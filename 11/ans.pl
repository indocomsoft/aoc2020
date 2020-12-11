input([]) :- at_end_of_stream(current_input).
input([X|Xs]) :-
  read_line_to_codes(current_input, X),
  input(Xs).

% dynamically defines layout/3.
def_layout(Xs) :- def_layout(Xs, 1, 1).
def_layout([], _, _).
def_layout([[]|Rows], Row, _Col) :-
  NewRow is Row + 1,
  def_layout(Rows, NewRow, 1).
def_layout([[Cell|Cols]|Rows], Row, Col) :-
  assertz(layout(Row, Col, Cell)),
  NewCol is Col + 1,
  def_layout([Cols|Rows], Row, NewCol).

w_empty(_Row, 1).
w_empty(Row, Col) :- WCol is Col - 1, layout(Row, WCol, Cell), Cell \= 35.
e_empty(_Row, NumCols, NumCols).
e_empty(Row, Col, _NumCols) :- ECol is Col + 1, layout(Row, ECol, Cell), Cell \= 35.
n_empty(1, _Col).
n_empty(Row, Col) :- NRow is Row - 1, layout(NRow, Col, Cell), Cell \= 35.
s_empty(NumRows, _Col, NumRows).
s_empty(Row, Col, _NumRows) :- SRow is Row + 1, layout(SRow, Col, Cell), Cell \= 35.
nw_empty(1, _).
nw_empty(_, 1).
nw_empty(Row, Col) :- NRow is Row - 1, WCol is Col - 1, layout(NRow, WCol, Cell), Cell \= 35.
ne_empty(1, _, _).
ne_empty(_, NumCols, NumCols).
ne_empty(Row, Col, _NumCols) :- NRow is Row - 1, ECol is Col + 1, layout(NRow, ECol, Cell), Cell \= 35.
sw_empty(NumRows, _, NumRows).
sw_empty(_, 1, _).
sw_empty(Row, Col, _NumRows) :- SRow is Row + 1, WCol is Col - 1, layout(SRow, WCol, Cell), Cell \= 35.
se_empty(NumRows, _, NumRows, _).
se_empty(_, NumCols, _, NumCols).
se_empty(Row, Col, _NumRows, _NumCols) :- SRow is Row + 1, ECol is Col + 1, layout(SRow, ECol, Cell), Cell \= 35.

no_occupied_seats_adjacent(NumRows, NumCols, Row, Col) :-
  n_empty(Row, Col),
  s_empty(Row, Col, NumRows),
  e_empty(Row, Col, NumCols),
  w_empty(Row, Col),
  nw_empty(Row, Col),
  ne_empty(Row, Col, NumCols),
  sw_empty(Row, Col, NumRows),
  se_empty(Row, Col, NumRows, NumCols).

four_or_more_adjacent_occupied(NumRows, NumCols, Row, Col) :-
  (n_empty(Row, Col) -> N is 0 ; N is 1),
  (s_empty(Row, Col, NumRows) -> S is 0 ; S is 1),
  (e_empty(Row, Col, NumCols) -> E is 0 ; E is 1),
  (w_empty(Row, Col) -> W is 0 ; W is 1),
  (nw_empty(Row, Col) -> NW is 0 ; NW is 1),
  (ne_empty(Row, Col, NumRows) -> NE is 0 ; NE is 1),
  (sw_empty(Row, Col, NumRows) -> SW is 0 ; SW is 1),
  (se_empty(Row, Col, NumRows, NumCols) -> SE is 0 ; SE is 1),
  Sum is N + S + E + W + NE + NW + SE + SW,
  Sum >= 4.

perform_round(NumRows, NumCols, Row, Col) :-
  layout(Row, Col, Cell),
  ( Cell is 76, no_occupied_seats_adjacent(NumRows, NumCols, Row, Col) ->
    assertz(newlayout(Row, Col, 35))
  ; Cell is 35, four_or_more_adjacent_occupied(NumRows, NumCols, Row, Col) ->
    assertz(newlayout(Row, Col, 76))
  ; assertz(newlayout(Row, Col, Cell))
  ),
  (Col is NumCols ->
    NewRow is Row + 1, NewCol is 1
  ; NewRow is Row, NewCol is Col + 1
  ),
  perform_round(NumRows, NumCols, NewRow, NewCol).
perform_round(NumRows, _NumCols, Row, _Col) :- Row > NumRows.

part1(Xs, Ans) :-
  length(Xs, NumRows),
  [X|_] = Xs,
  length(X, NumCols),
  retractall(layout(_, _, _)),
  retractall(newlayout(_, _, _)),
  def_layout(Xs),
  part1(NumRows, NumCols, Ans).

part1(NumRows, NumCols, Ans) :-
  findall(X, layout(_, _, X), Xs),
  perform_round(NumRows, NumCols, 1, 1),
  findall(Y, newlayout(_, _, Y), Ys),
  (Xs = Ys ->
    include(=(35), Ys, OccList),
    length(OccList, Ans)
  ; retractall(layout(_, _, _)),
    copy_predicate_clauses(newlayout(_, _, _), layout(_, _, _)),
    retractall(newlayout(_, _, _)),
    part1(NumRows, NumCols, Ans)
  ).

w_empty2(_Row, 1).
w_empty2(Row, Col) :-
  WCol is Col - 1,
  layout(Row, WCol, Cell),
  (Cell is 46 ->
    w_empty2(Row, WCol) % floor
  ; Cell \= 35
  ).
e_empty2(_Row, NumCols, NumCols).
e_empty2(Row, Col, NumCols) :-
  ECol is Col + 1,
  layout(Row, ECol, Cell),
  (Cell is 46 ->
    e_empty2(Row, ECol, NumCols)
  ; Cell \= 35
  ).
n_empty2(1, _Col).
n_empty2(Row, Col) :-
  NRow is Row - 1,
  layout(NRow, Col, Cell),
  (Cell is 46 ->
    n_empty2(NRow, Col)
  ; Cell \= 35
  ).
s_empty2(NumRows, _Col, NumRows).
s_empty2(Row, Col, NumRows) :-
  SRow is Row + 1,
  layout(SRow, Col, Cell),
  (Cell is 46 ->
    s_empty2(SRow, Col, NumRows)
  ; Cell \= 35
  ).
nw_empty2(1, _).
nw_empty2(_, 1).
nw_empty2(Row, Col) :-
  NRow is Row - 1,
  WCol is Col - 1,
  layout(NRow, WCol, Cell),
  (Cell is 46 ->
    nw_empty2(NRow, WCol)
  ; Cell \= 35
  ).
ne_empty2(1, _, _).
ne_empty2(_, NumCols, NumCols).
ne_empty2(Row, Col, NumCols) :-
  NRow is Row - 1,
  ECol is Col + 1,
  layout(NRow, ECol, Cell),
  (Cell is 46 ->
    ne_empty2(NRow, ECol, NumCols)
  ; Cell \= 35
  ).
sw_empty2(NumRows, _, NumRows).
sw_empty2(_, 1, _).
sw_empty2(Row, Col, NumRows) :-
  SRow is Row + 1,
  WCol is Col - 1,
  layout(SRow, WCol, Cell),
  (Cell is 46 ->
    sw_empty2(SRow, WCol, NumRows)
  ; Cell \= 35
  ).
se_empty2(NumRows, _, NumRows, _).
se_empty2(_, NumCols, _, NumCols).
se_empty2(Row, Col, NumRows, NumCols) :-
  SRow is Row + 1,
  ECol is Col + 1,
  layout(SRow, ECol, Cell),
  (Cell is 46 ->
    se_empty2(SRow, ECol, NumRows, NumCols)
  ; Cell \= 35
  ).

five_or_more_adjacent_occupied(NumRows, NumCols, Row, Col) :-
  (n_empty2(Row, Col) -> N is 0 ; N is 1),
  (s_empty2(Row, Col, NumRows) -> S is 0 ; S is 1),
  (e_empty2(Row, Col, NumCols) -> E is 0 ; E is 1),
  (w_empty2(Row, Col) -> W is 0 ; W is 1),
  (nw_empty2(Row, Col) -> NW is 0 ; NW is 1),
  (ne_empty2(Row, Col, NumRows) -> NE is 0 ; NE is 1),
  (sw_empty2(Row, Col, NumRows) -> SW is 0 ; SW is 1),
  (se_empty2(Row, Col, NumRows, NumCols) -> SE is 0 ; SE is 1),
  Sum is N + S + E + W + NE + NW + SE + SW,
  Sum >= 5.

no_occupied_seats_adjacent2(NumRows, NumCols, Row, Col) :-
  n_empty2(Row, Col),
  s_empty2(Row, Col, NumRows),
  e_empty2(Row, Col, NumCols),
  w_empty2(Row, Col),
  nw_empty2(Row, Col),
  ne_empty2(Row, Col, NumCols),
  sw_empty2(Row, Col, NumRows),
  se_empty2(Row, Col, NumRows, NumCols).

perform_round2(NumRows, NumCols, Row, Col) :-
  layout(Row, Col, Cell),
  ( Cell is 76, no_occupied_seats_adjacent2(NumRows, NumCols, Row, Col) ->
    assertz(newlayout(Row, Col, 35))
  ; Cell is 35, five_or_more_adjacent_occupied(NumRows, NumCols, Row, Col) ->
    assertz(newlayout(Row, Col, 76))
  ; assertz(newlayout(Row, Col, Cell))
  ),
  (Col is NumCols ->
    NewRow is Row + 1, NewCol is 1
  ; NewRow is Row, NewCol is Col + 1
  ),
  perform_round2(NumRows, NumCols, NewRow, NewCol).
perform_round2(NumRows, _NumCols, Row, _Col) :- Row > NumRows.

part2(Xs, Ans) :-
  length(Xs, NumRows),
  [X|_] = Xs,
  length(X, NumCols),
  retractall(layout(_, _, _)),
  retractall(newlayout(_, _, _)),
  def_layout(Xs),
  part2(NumRows, NumCols, Ans).

part2(NumRows, NumCols, Ans) :-
  findall(X, layout(_, _, X), Xs),
  perform_round2(NumRows, NumCols, 1, 1),
  findall(Y, newlayout(_, _, Y), Ys),
  (Xs = Ys ->
    include(=(35), Ys, OccList),
    length(OccList, Ans)
  ; retractall(layout(_, _, _)),
    copy_predicate_clauses(newlayout(_, _, _), layout(_, _, _)),
    retractall(newlayout(_, _, _)),
    part2(NumRows, NumCols, Ans)
  ).

main :-
  input(Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
