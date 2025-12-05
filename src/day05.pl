:- ['src/util.pl'].

parse_range(RangeString, [Start, End]):-
    split_string(RangeString, "-", "", [A, B]),
    number_string(Start, A),
    number_string(End, B).

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

main:-
    Filename = 'inputs/day05.txt',
    read_file_to_strings(Filename, Lines),
    append(RangeStrings, [""|IDStrings], Lines),
    maplist(parse_range, RangeStrings, Ranges),
    maplist(string_number, IDStrings, IDs),

    include(in_ranges(Ranges), IDs, FreshIDs),
    length(FreshIDs, Result1),
    write("Part 1: "), write(Result1), nl,

    foldl(merge_range_rangelist, Ranges, [], MergedRanges),
    maplist(range_size, MergedRanges, RangeSizes),
    sumlist(RangeSizes, Result2),
    write("Part 2: "), write(Result2), nl,
    halt.

:- initialization(main).