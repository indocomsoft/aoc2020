input(Stream, []) :- at_end_of_stream(Stream).
input(Stream, [X|Xs]) :-
  read_line_to_string(Stream, Line),
  string_concat(Command, ArgString, Line),
  string_length(Command, 1),
  number_string(Arg, ArgString),
  X = [Command, Arg],
  input(Stream, Xs).

dir_index("N", 0).
dir_index("E", 1).
dir_index("S", 2).
dir_index("W", 3).

lat_dir_multiplier("N", 1).
lat_dir_multiplier("S", -1).
lat_dir_multiplier("W", 0).
lat_dir_multiplier("E", 0).

long_dir_multiplier("N", 0).
long_dir_multiplier("S", 0).
long_dir_multiplier("W", 1).
long_dir_multiplier("E", -1).

turn(["R", Angle], Dir, NewDir) :-
  dir_index(Dir, Index),
  NewIndex is (Index + (Angle // 90)) mod 4,
  dir_index(NewDir, NewIndex).
turn(["L", Angle], Dir, NewDir) :-
  dir_index(Dir, Index),
  NewIndex is (Index - (Angle // 90)) mod 4,
  dir_index(NewDir, NewIndex).

move(["N", Arg], _Dir, Lat, Long, NewLat, Long) :- NewLat is Lat + Arg.
move(["S", Arg], _Dir, Lat, Long, NewLat, Long) :- NewLat is Lat - Arg.
move(["W", Arg], _Dir, Lat, Long, Lat, NewLong) :- NewLong is Long + Arg.
move(["E", Arg], _Dir, Lat, Long, Lat, NewLong) :- NewLong is Long - Arg.
move(["F", Arg], Dir, Lat, Long, NewLat, NewLong) :-
  lat_dir_multiplier(Dir, LatMultiplier),
  long_dir_multiplier(Dir, LongMultiplier),
  NewLat is Lat + (Arg * LatMultiplier),
  NewLong is Long + (Arg * LongMultiplier).

part1(Xs, Ans) :- part1(Xs, "E", 0, 0, Ans).

part1([], _, Lat, Long, Ans) :- Ans is abs(Lat) + abs(Long).
part1([[Command, Arg]|Xs], Dir, Lat, Long, Ans) :-
  ((Command = "L"; Command = "R") ->
    turn([Command, Arg], Dir, NewDir),
    part1(Xs, NewDir, Lat, Long, Ans)
  ; move([Command, Arg], Dir, Lat, Long, NewLat, NewLong),
    part1(Xs, Dir, NewLat, NewLong, Ans)
  ).

part2(Xs, Ans) :- part2(Xs, 0, 0, 1, -10, Ans).

turn_way(["R", 0], WLat, WLong, WLat, WLong).
turn_way(["R", 90], WLat, WLong, WLong, NewWLong) :- NewWLong is -WLat.
turn_way(["R", 180], WLat, WLong, NewWLat, NewWLong) :- NewWLat is -WLat, NewWLong is -WLong.
turn_way(["R", 270], WLat, WLong, NewWLat, WLat) :- NewWLat is -WLong.
turn_way(["R", 360], WLat, WLong, WLat, WLong).

turn_way(["L", 0], WLat, WLong, WLat, WLong).
turn_way(["L", 90], WLat, WLong, NewWLat, WLat) :- NewWLat is -WLong.
turn_way(["L", 180], WLat, WLong, NewWLat, NewWLong) :- NewWLat is -WLat, NewWLong is -WLong.
turn_way(["L", 270], WLat, WLong, WLong, NewWLong) :- NewWLong is -WLat.
turn_way(["L", 360], WLat, WLong, WLat, WLong).

part2([], Lat, Long, _, _, Ans) :- Ans is abs(Lat) + abs(Long).
part2([[Command, Arg]|Xs], Lat, Long, WLat, WLong, Ans) :-
  ((Command = "L"; Command = "R") ->
    turn_way([Command, Arg], WLat, WLong, NewWLat, NewWLong),
    part2(Xs, Lat, Long, NewWLat, NewWLong, Ans)
  ; (Command = "F") ->
    NewLat is Lat + WLat * Arg,
    NewLong is Long + WLong * Arg,
    part2(Xs, NewLat, NewLong, WLat, WLong, Ans)
  ; move([Command, Arg], _, WLat, WLong, NewWLat, NewWLong),
    part2(Xs, Lat, Long, NewWLat, NewWLong, Ans)
  ).

main :-
  input(current_input, Xs),
  part1(Xs, Ans1),
  writeln(Ans1),
  part2(Xs, Ans2),
  writeln(Ans2).
