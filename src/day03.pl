
:- ['src/util.pl'].

max_batteries(0, _, 0).
max_batteries(N, Batteries, Joltage):-
    length(Batteries, L),
    FrontLength is L - N + 1,
    length(Front, FrontLength),
    append(Front, _, Batteries),
    max_list(Front, FrontDigit),
    nth1(FrontDigitIndex, Front, FrontDigit),
    RestLength is L - FrontDigitIndex,
    length(Rest, RestLength),
    append(_, Rest, Batteries),
    succ(N1, N),
    max_batteries(N1, Rest, JoltageRest),
    Joltage is 10 ^ (N - 1) * FrontDigit + JoltageRest.

string_to_digits(String, Digits):-
    string_chars(String, DigitChars),
    maplist(char_code, DigitChars, Codes),
    maplist(plus(-48), Codes, Digits).

main:-
    Filename = 'inputs/day03.txt',
    read_file_to_strings(Filename, BankStrings),
    maplist(string_to_digits, BankStrings, Banks),

    maplist(max_batteries(2), Banks, Joltages),
    sum_list(Joltages, Result1),
    write("Part 1: "), write(Result1), nl,

    maplist(max_batteries(12), Banks, Joltages2),
    sum_list(Joltages2, Result2),
    write("Part 2: "), write(Result2), nl,

    halt.

:- initialization(main).
