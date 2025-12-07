:- initialization(main).

main:-
    phrase_from_file(input(StartingColumn, Rows), 'inputs/day07.txt'),

    foldl(process_line, Rows, ([StartingColumn], 0), (_, Result1)),
    write("Part 1: "), write(Result1), nl,

    list_to_assoc([StartingColumn-1], Beams),
    foldl(process_line2, Rows, Beams, TotalBeams),
    assoc_to_values(TotalBeams, BeamCounts),
    sum_list(BeamCounts, Result2),
    write("Part 2: "), write(Result2), nl,

    halt.

process_line2([], State, State).
process_line2([Splitter|Rest], Beams, ResBeams):-
    get_assoc(Splitter, Beams, Count),
    process_line2(Rest, Beams, RecBeams),
    succ(L, Splitter),
    succ(Splitter, R),
    (get_assoc(L, RecBeams, LCount) ; LCount = 0),
    (get_assoc(R, RecBeams, RCount) ; RCount = 0),
    del_assoc(Splitter, RecBeams, _, Beams1),
    LCountNew is LCount + Count,
    RCountNew is RCount + Count,
    put_assoc(L, Beams1, LCountNew, Beams2),
    put_assoc(R, Beams2, RCountNew, ResBeams).
process_line2([_|Rest], State, ResultingState):-
    process_line2(Rest, State, ResultingState).

process_line([], State, State).
process_line([Splitter|Rest], (Beams, Splits), (Beams1, Splits1)):-
    member(Splitter, Beams),
    process_line(Rest, (Beams, Splits), (RecBeams, RecSplits)),
    delete(RecBeams, Splitter, X),
    succ(L, Splitter),
    succ(Splitter, R),
    append(X, [L, R], Beams1),
    succ(RecSplits, Splits1).
process_line([_|Rest], State, ResultingState):-
    process_line(Rest, State, ResultingState).

% Parsing
input(StartingColumn, Rows) -->
    starting_column(StartingColumn, 0),
    "\n",
    rows(Rows).

starting_column(StartingColumn, Idx) -->
    ".",
    { succ(Idx, Idx1) },
    starting_column(StartingColumn, Idx1).
starting_column(StartingColumn, StartingColumn) -->
    "S",
    rest_of_line.

rest_of_line --> ".", rest_of_line ; [].

rows([Row]) -->
    row(Row, 0).
rows([Row|Rest]) -->
    row(Row, 0),
    "\n",
    rows(Rest).

row(Row, Idx) -->
    ".",
    { succ(Idx, Idx1) },
    row(Row, Idx1).
row(Row, Idx) -->
    "^",
    { succ(Idx, Idx1) },
    row(RowRest, Idx1),
    {Row = [Idx|RowRest]}.
row([], _) --> [].