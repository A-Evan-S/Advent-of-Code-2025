parse_range(RangeString, Range):-
    split_string(RangeString, "-", "", RangeStrings),
    maplist(number_string, Range, RangeStrings).

find_invalids(IsInvalid, [RangeStart, RangeEnd], Invalids):-
    numlist(RangeStart, RangeEnd, Nums),
    include(IsInvalid, Nums, Invalids).

is_invalid_1(Num):-
    number_string(Num, NumString),
    string_concat(Prefix, Suffix, NumString),
    Prefix == Suffix.

is_invalid_2(Num):-
    number_string(Num, NumString),
    string_length(NumString, L),
    between(2, L, NumParts),
    0 is mod(L, NumParts),
    Before is div(L, NumParts),
    sub_string(NumString, 0, Before, _, Part),
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
    maplist(sum_list, Invalids, InvalidSums),
    sum_list(InvalidSums, Result1),
    write("Part 1: "), write(Result1), nl,

    maplist(find_invalids(is_invalid_2), Ranges, Invalids2),
    maplist(sum_list, Invalids2, InvalidSums2),
    sum_list(InvalidSums2, Result2),
    write("Part 2: "), write(Result2), nl,

    halt.

:- initialization(main).
