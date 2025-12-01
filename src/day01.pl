:- ['src/parsing_util.pl'].

parse_rotation(RotationString, Rotation):-
    string_chars(RotationString, Chars),
    Chars = [Direction|_],
    sub_string(RotationString, 1, _, 0, AmountString),
    number_string(Amount, AmountString),
    (Direction == 'R' -> Rotation is Amount; Rotation is (-1) * Amount).

count_zeros_1([], 0, Acc, Zeros):- Zeros is Acc + 1.
count_zeros_1([], _, Acc, Acc).
count_zeros_1([R|Rest], 0, Acc, Zeros):-
    Acc1 is Acc + 1,
    Position is mod(R, 100),
    count_zeros_1(Rest, Position, Acc1, Zeros).
count_zeros_1([R|Rest], Position, Acc, Zeros):-
    Position1 is mod(Position + R, 100),
    count_zeros_1(Rest, Position1, Acc, Zeros).

expand([], []).
expand([0|Rest], ExpandedRotations):- expand(Rest, ExpandedRotations).
expand([R|Rest], ExpandedRotations):-
    (R < 0 -> Term is -1 ; Term is 1 ),
    R1 is R - Term,
    expand([R1|Rest], ExpandedRest),
    ExpandedRotations = [Term|ExpandedRest].

main:-
    read_file_to_strings('inputs/day01.txt', Input),
    maplist(parse_rotation, Input, Rotations),
    count_zeros_1(Rotations, 50, 0, Result1),
    write("Part 1: "), write(Result1), nl,
    expand(Rotations, ExpandedRotations),
    count_zeros_1(ExpandedRotations, 50, 0, Result2),
    write("Part 2: "), write(Result2), nl,
    halt.

:- initialization(main).