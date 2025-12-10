:- ['src/util.pl'].
:- initialization(main).
:- use_module(library(record)).
:- use_module(library(union_find)).

:- record point(x:integer=0, y:integer=0, z:integer=0).

main:-
    phrase_from_file(input(Points), 'inputs/day08.txt'), Merges = 1000,
    % phrase_from_file(input(Points), 'test_inputs/day08_test.txt'), Merges = 10,

    findall((D, P1, P2), point_pair(Points, P1, P2, D), PointPairs),
    sort(PointPairs, PointPairs1),
    maplist([(_, P1, P2), R]>>(nth1(I, Points, P1), nth1(J, Points, P2), R = (I, J)), PointPairs1, PointPairs2),

    solve_1(Points, PointPairs2, Merges, Result1),
    write("Part 1: "), write(Result1), nl,
    solve_2(Points, PointPairs2, Result2),
    write("Part 2: "), write(Result2), nl,

    halt.

solve_1(Points, PointPairs, Merges, Result):-
    take(Merges, PointPairs, PointPairs1),
    length(Points, N),
    union_find(UF, N),
    maplist([(P1, P2)]>>(union(UF, P1, P2)), PointPairs1),
    disjoint_sets(UF, DS),
    maplist(length, DS, Lengths),
    sort(Lengths, Lengths1),
    reverse(Lengths1, Lengths2),
    take(3, Lengths2, ToMult),
    prod_list(ToMult, Result).

solve_2(Points, PointPairs, Result):-
    length(Points, N),
    union_find(UF, N),
    solve_2_rec(UF, PointPairs, (A, B)),
    nth1(A, Points, P1),
    nth1(B, Points, P2),
    point_x(P1, X1),
    point_x(P2, X2),
    Result is X1 * X2.

solve_2_rec(UF, [(P1, P2)|_], LastPair):-
    disjoint_sets(UF, DS),
    length(DS, L),
    L == 2,
    find(UF, P1, R1),
    find(UF, P2, R2), 
    R1 =\= R2,
    LastPair = (P1, P2).
solve_2_rec(UF, [(P1, P2)|Pairs], LastPair):-
    union(UF, P1, P2),
    solve_2_rec(UF, Pairs, LastPair).

point_pair(Points, P1, P2, Distance):-
    member(P1, Points), member(P2, Points),
    distance_sq(P1, P2, Distance),
    Distance =\= 0,
    point_x(P1, X1), point_y(P1, Y1), point_z(P1, Z1),
    point_x(P2, X2), point_y(P2, Y2), point_z(P2, Z2),
    (X1 > X2 ; (X1 == X2, Y1 > Y2) ; (X1 == X2, Y1 == Y2, Z1 > Z2)).

distance_sq(Point1, Point2, Distance):-
    point_x(Point1, X1), point_y(Point1, Y1), point_z(Point1, Z1),
    point_x(Point2, X2), point_y(Point2, Y2), point_z(Point2, Z2),
    Distance is (X1 - X2)^2 + (Y1 - Y2)^2 + (Z1 - Z2)^2.

input([Point|Rest]) -->
    point_dcg(Point),
    "\n",
    input(Rest).
input([Point]) --> point_dcg(Point).

point_dcg(Point) --> 
    number_dcg(X),
    ",",
    number_dcg(Y),
    ",",
    number_dcg(Z),
    { make_point([x(X), y(Y), z(Z)], Point) }.