:- initialization(main).

main:-
    phrase_from_file(input(StartingColumn, Rows), 'inputs/day07.txt'),
    list_to_assoc([StartingColumn-1], Beams),
    foldl(process_line, Rows, (Beams, 0), (TotalBeams, Result1)),
    assoc_to_values(TotalBeams, BeamCounts),
    sum_list(BeamCounts, Result2),
    format('Part 1: ~w~n', [Result1]),
    format('Part 2: ~w~n', [Result2]),
    halt.

process_line([], State, State).
process_line([Splitter|Rest], (Beams, Splits), (ResBeams, Splits1)):-
    get_assoc(Splitter, Beams, _),
    process_line(Rest, (Beams, Splits), (RecBeams, RecSplits)),
    split_beams(Splitter, RecBeams, ResBeams),
    succ(RecSplits, Splits1).
process_line([_|Rest], State, ResultingState):-
    process_line(Rest, State, ResultingState).

split_beams(Splitter, Beams, ResBeams):-
    get_assoc(Splitter, Beams, Count),
    succ(L, Splitter),
    succ(Splitter, R),
    (get_assoc(L, Beams, LCount) ; LCount = 0),
    (get_assoc(R, Beams, RCount) ; RCount = 0),
    del_assoc(Splitter, Beams, _, Beams1),
    LCountNew is LCount + Count,
    RCountNew is RCount + Count,
    put_assoc(L, Beams1, LCountNew, Beams2),
    put_assoc(R, Beams2, RCountNew, ResBeams).

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

rows([Row]) --> row(Row, 0).
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