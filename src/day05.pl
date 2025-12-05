:- ['src/util.pl'].
:- initialization(main).

main:-
    parse_input('inputs/day05.txt', Ranges, IDs),

    include(in_ranges(Ranges), IDs, FreshIDs),
    length(FreshIDs, Result1),
    write("Part 1: "), write(Result1), nl,

    foldl(merge_range_rangelist, Ranges, [], MergedRanges),
    maplist(range_size, MergedRanges, RangeSizes),
    sumlist(RangeSizes, Result2),
    write("Part 2: "), write(Result2), nl,
    halt.

% Parsing
input(Ranges, IDs) -->
    ranges(Ranges),
    ['\n', '\n'],
    ids(IDs).

ranges([R|Rest]) --> range(R), ['\n'], ranges(Rest).
ranges([R]) --> range(R).

ids([ID|Rest]) --> id(ID), ['\n'], ids(Rest).
ids([ID]) --> id(ID).

range([Start, End]) -->
    number_dcg(Start),
    ['-'],
    number_dcg(End).

id(ID) --> number_dcg(ID).

parse_input(Filename, Ranges, IDs):-
    read_file_to_chars(Filename, InputChars),
    phrase(input(Ranges, IDs), InputChars).

% Solving
in_ranges(Ranges, ID):-
    member([Start, End], Ranges),
    between(Start, End, ID).

overlap([S1, E1], [S2, E2]):-
    S1 =< E2,
    S2 =< E1.

merge_range_rangelist(Range, RangeList, Result):-
    partition(overlap(Range), RangeList, OverlappingRanges, OtherRanges),
    flatten([Range|OverlappingRanges], EndPoints),
    min_list(EndPoints, Start),
    max_list(EndPoints, End),
    Result = [[Start, End]|OtherRanges].

range_size([A, B], RangeSize):-
    RangeSize is B - A + 1.