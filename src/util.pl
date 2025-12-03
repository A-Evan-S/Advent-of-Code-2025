read_file_to_strings(Filename, Input):-
    open(Filename, read, InputStream),
    read_stream_to_strings(InputStream, Input),
    close(InputStream).

read_stream_to_strings(InputStream, Input):-
    read_line_to_string(InputStream, Line),
    (Line == end_of_file -> Input = [];
     Input = [Line|Rest], read_stream_to_strings(InputStream, Rest)).