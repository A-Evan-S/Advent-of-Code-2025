:- ['src/util.pl'].
:- initialization(main).

main:-
    phrase_from_file(input(Points), 'inputs/day09.txt'),
    solve_1(Points, Result1),
    write("Part 1: "), write(Result1), nl,
    solve_2(Points, Result2),
    write("Part 2: "), write(Result2), nl,
    halt.

solve_2(Points, Result):-
    findall((I1, I2, P1, P2), (nth0(I1, Points, P1), nth0(I2, Points, P2), I1 < I2), PointPairs),
    [H|T] = Points,
    append(T, [H], ShiftedPoints),
    maplist([P1, P2, R]>>(R = (P1, P2)), Points, ShiftedPoints, LineSegs),
    include(valid_part_2_rect(LineSegs), PointPairs, ValidPointPairs),
    maplist([(_, _, P1, P2), A]>>rectangle_area((P1, P2), A), ValidPointPairs, Areas),
    max_list(Areas, Result).

valid_part_2_rect(LineSegs, (I1, I2, X1-Y1, X2-Y2)):-
    write((I1, I2)), nl,
    sort([X1, X2], [MinX, MaxX]),
    sort([Y1, Y2], [MinY, MaxY]),
    all(no_intersects_rect(MinX, MaxX, MinY, MaxY), LineSegs).

no_intersects_rect(MinX, MaxX, MinY, MaxY, (X1-Y1, X2-Y2)):-
    (X1 =< MinX, X2 =< MinX), !.
no_intersects_rect(MinX, MaxX, MinY, MaxY, (X1-Y1, X2-Y2)):-
    (Y1 =< MinY, Y2 =< MinY), !.
no_intersects_rect(MinX, MaxX, MinY, MaxY, (X1-Y1, X2-Y2)):-
    (X1 >= MaxX, X2 >= MaxX), !.
no_intersects_rect(MinX, MaxX, MinY, MaxY, (X1-Y1, X2-Y2)):-
    (Y1 >= MaxY, Y2 >= MaxY), !.

solve_1(Points, Result):-
    findall((P1, P2), (member(P1, Points), member(P2, Points)), PointPairs),
    maplist(rectangle_area, PointPairs, Areas),
    max_list(Areas, Result).

rectangle_area((X1-Y1, X2-Y2), Area):-
    Area is (abs(X2 - X1) + 1) * (abs(Y2 - Y1) + 1).

input([Point|Rest]) -->
    point_dcg(Point),
    "\n",
    input(Rest).
input([Point]) --> point_dcg(Point).

point_dcg(Point) --> 
    number_dcg_codes(X),
    ",",
    number_dcg_codes(Y),
    { Point = X-Y }.

number_dcg_codes(N) -->
    digits_codes(Digits),
    { number_codes(N, Digits) }.

digits_codes([D|Rest]) --> [D], { code_type(D, digit) }, digits_codes(Rest).
digits_codes([D]) --> [D], { code_type(D, digit) }.