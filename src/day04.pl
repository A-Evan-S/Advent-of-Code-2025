:- ['src/util.pl'].
:- table contains_paper/3.

contains_paper(Grid, 0, Position):-
    Position = (RowIndex, ColIndex),
    nth0(RowIndex, Grid, Row),
    string_chars(Row, RowChars),
    nth0(ColIndex, RowChars, '@').

contains_paper(Grid, Step, Position):-
    succ(Step1, Step),
    contains_paper(Grid, Step1, Position),
    not(forkliftable(Grid, Step1, Position)).

forkliftable(Grid, Step, Position):-
    contains_paper(Grid, Step, Position),
    findall(Pos, neighbor(Position, Pos), Neighbors),
    count(contains_paper(Grid, Step), Neighbors, NeighborPaper),
    NeighborPaper < 4.

neighbor(Position1, Position2):-
    Position1 = (Row1, Col1),
    between(-1, 1, DR),
    between(-1, 1, DC),
    (DR, DC) \= (0, 0),
    Row2 is Row1 + DR,
    Col2 is Col1 + DC,
    Position2 = (Row2, Col2).

paper_removed(Grid, Step, PaperRemoved):-
    findall(Pos, contains_paper(Grid, 0, Pos), OriginalPaper),
    findall(Pos, contains_paper(Grid, Step, Pos), FinalPaper),
    length(OriginalPaper, OriginalCount),
    length(FinalPaper, FinalCount),
    PaperRemoved is OriginalCount - FinalCount.

main:-
    Filename = 'inputs/day04.txt',
    read_file_to_strings(Filename, Grid),
    paper_removed(Grid, 1, Result1),
    write("Part 1: "), write(Result1), nl,
    paper_removed(Grid, 100, Result2),
    write("Part 2: "), write(Result2), nl,
    halt.

:- initialization(main).