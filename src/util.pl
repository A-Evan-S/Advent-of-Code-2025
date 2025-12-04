read_file_to_strings(Filename, Input):-
    open(Filename, read, InputStream),
    read_stream_to_strings(InputStream, Input),
    close(InputStream).

read_stream_to_strings(InputStream, Input):-
    read_line_to_string(InputStream, Line),
    (Line == end_of_file -> Input = [];
     Input = [Line|Rest], read_stream_to_strings(InputStream, Rest)).

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