:- ['src/parsing_util.pl'].

parse_rotation(RotationString, Rotation):-
    string_chars(RotationString, Chars),
    Chars = [Direction|AmountChars],
    number_chars(Amount, AmountChars),
    (Direction == 'R' -> Rotation is Amount; Rotation is -Amount).

count_zeros([], 0, Acc, Zeros):- succ(Acc, Zeros).
count_zeros([], _, Acc, Acc).
count_zeros([R|Rest], 0, Acc, Zeros):-
    succ(Acc, Acc1),
    Position is mod(R, 100),
    count_zeros(Rest, Position, Acc1, Zeros).
count_zeros([R|Rest], Position, Acc, Zeros):-
    Position1 is mod(Position + R, 100),
    count_zeros(Rest, Position1, Acc, Zeros).

expand([], []).
expand([0|Rest], ExpandedRotations):- expand(Rest, ExpandedRotations).
expand([R|Rest], ExpandedRotations):-
    (R < 0 -> Term is -1 ; Term is 1),
    R1 is R - Term,
    expand([R1|Rest], ExpandedRest),
    ExpandedRotations = [Term|ExpandedRest].

main:-
    read_file_to_strings('inputs/day01.txt', Input),
    maplist(parse_rotation, Input, Rotations),
    count_zeros(Rotations, 50, 0, Result1),
    write("Part 1: "), write(Result1), nl,
    expand(Rotations, ExpandedRotations),
    count_zeros(ExpandedRotations, 50, 0, Result2),
    write("Part 2: "), write(Result2), nl,
    halt.

:- initialization(main).