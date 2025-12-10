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

transpose([], []).
transpose([L], R):-
    maplist([X, V]>>(V = [X]), L, R).
transpose([H|T], R):-
    transpose(T, RecResult),
    maplist([X,Y,Z]>>(Z = [X|Y]), H, RecResult, R).

split_list(List, Delimiter, Result):-
    split_list(List, Delimiter, [], Result).
split_list([], _, Acc, [Acc]).
split_list([Delimiter], Delimiter, Acc, [Acc, []]).
split_list([Delimiter|T], Delimiter, Acc, Result):-
    split_list(T, Delimiter, [], Result1),
    Result = [Acc|Result1].
split_list([H|T], Delimiter, Acc, Result):-
    Acc1 = [H|Acc],
    split_list(T, Delimiter, Acc1, Result).

prod_list(List, Result):-
    foldl([A,B,C]>>(C is A * B), List, 1, Result).

reverse(F, A, B):- call(F, B, A).

all(_, []).
all(Pred, [H|T]):-
    apply(Pred, [H]),
    all(Pred, T).

any(Pred, [H|T]):-
    apply(Pred, [H]), ! ; any(Pred, T).

number_dcg(N) -->
    digits(Digits),
    { number_codes(N, Digits) }.

digits([D|Rest]) --> [D], { code_type(D, digit) }, digits(Rest).
digits([D]) --> [D], { code_type(D, digit) }.