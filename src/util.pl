read_file_to_strings(Filename, Input):-
    open(Filename, read, InputStream),
    read_stream_to_strings(InputStream, Input),
    close(InputStream).

read_stream_to_strings(InputStream, Input):-
    read_line_to_string(InputStream, Line),
    (Line == end_of_file -> Input = [];
     Input = [Line|Rest], read_stream_to_strings(InputStream, Rest)).

read_file_to_chars(Filename, InputChars):-
    read_file_to_string(Filename, InputString, []),
    string_chars(InputString, InputChars).

take(N, List, Prefix):-
    length(Prefix, N),
    append(Prefix, _, List).

drop(N, List, Suffix):-
    length(List, L),
    length(Suffix, S),
    N is L - S,
    append(_, Suffix, List).

count(Pred, List, Count):-
    include(Pred, List, Valid),
    length(Valid, Count).

string_number(S, N):-
    number_string(N, S).

number_dcg(N) --> digits(Digits), { number_chars(N, Digits) }.

digits([D|Rest]) --> [D], { char_type(D, digit) }, digits(Rest).
digits([D]) --> [D], { char_type(D, digit) }.