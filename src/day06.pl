:- ['src/util.pl'].
:- initialization(main).

main:-
    read_file_to_strings('inputs/day06.txt', Lines),

    parse_input_1(Lines, Vals, Ops),
    maplist(solve, Ops, Vals, Nums),
    sumlist(Nums, Result1),
    write("Part 1: "), write(Result1), nl,

    parse_input_2(Lines, Vals2, Ops2),
    maplist(solve, Ops2, Vals2, Nums2),
    sumlist(Nums2, Result2),
    write("Part 2: "), write(Result2), nl,

    halt.

solve("+", Vals, Result):- sum_list(Vals, Result).
solve("*", Vals, Result):- prod_list(Vals, Result).

parse_input_1(Lines, Vals, Ops):-
    maplist([S]>>split_string(S, " ", " "), Lines, SplitLines),
    last(SplitLines, Ops),
    append(ValStrings, [Ops], SplitLines),
    maplist(maplist(string_number), ValStrings, ValRows),
    transpose(ValRows, Vals).

parse_input_2(Lines, Vals, Ops):-
    last(Lines, OpsString),
    append(OrigValStrings, [OpsString], Lines),
    split_string(OpsString, " ", " ", Ops),
    maplist(string_chars, OrigValStrings, Chars),
    transpose(Chars, FlippedChars),
    maplist(exclude(=(' ')), FlippedChars, FilteredChars),
    maplist(reverse(string_chars), FilteredChars, FlippedStrings),
    split_list(FlippedStrings, "", ValStrings),
    maplist(maplist(string_number), ValStrings, Vals).