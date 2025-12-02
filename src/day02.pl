parse_range(RangeString, Range):-
    split_string(RangeString, "-", "", RangeStrings),
    maplist(number_string, Range, RangeStrings).

find_invalids(IsInvalid, [RangeStart, RangeEnd], Invalids):-
    numlist(RangeStart, RangeEnd, Nums),
    include(IsInvalid, Nums, Invalids).

is_invalid_1(Num):-
    number_string(Num, NumString),
    string_length(NumString, L),
    PartLength is div(L, 2),
    sub_string(NumString, 0, PartLength, PartLength, Left),
    sub_string(NumString, PartLength, PartLength, 0, Right),
    Left == Right.

is_invalid_2(Num):-
    number_string(Num, NumString),
    string_length(NumString, L),
    between(2, L, NumParts),
    0 is mod(L, NumParts),
    Before is div(L, NumParts),
    After is L - Before,
    sub_string(NumString, 0, Before, After, Part),
    string_repeat(Part, NumString).

string_repeat(_, "").
string_repeat(Part, String):-
    string_concat(Part, Rest, String),
    string_repeat(Part, Rest).

main:-
    Filename = 'inputs/day02.txt',
    read_file_to_string(Filename, Input, []),
    split_string(Input, ",", "", RangeStrings),
    maplist(parse_range, RangeStrings, Ranges),

    maplist(find_invalids(is_invalid_1), Ranges, Invalids),
    flatten(Invalids, AllInvalids),
    sum_list(AllInvalids, Result1),
    write("Part 1: "), write(Result1), nl,

    maplist(find_invalids(is_invalid_2), Ranges, Invalids2),
    flatten(Invalids2, AllInvalids2),
    sum_list(AllInvalids2, Result2),
    write("Part 2: "), write(Result2), nl,

    halt.

:- initialization(main).
