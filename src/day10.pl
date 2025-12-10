:- ['src/util.pl'].
:- initialization(main).

main:-
    phrase_from_file(input(Machines), 'test_inputs/day10_test.txt'),
    % write("Part 1: "), write(Result1), nl,
    % write("Part 2: "), write(Result2), nl,
    halt.

input([Machine|Rest]) -->
    machine(Machine),
    "\n",
    input(Rest).
input([Machine]) --> machine(Machine).

machine(Machine) -->
    lights(Lights),
    " ",
    buttons(Buttons),
    " ",
    joltages(Joltages),
    { Machine = (Lights, Buttons, Joltages)}.

lights(Lights) --> "[", lights_inner(Lights), "]".
lights_inner([0|R]) --> ".", lights_inner(R).
lights_inner([1|R]) --> "#", lights_inner(R).
lights_inner([]) --> [].

buttons([Button|Rest]) -->
    button(Button), " ", buttons(Rest).
buttons([Button]) --> button(Button).

button(Button) --> "(", numbers(Button) ,")".

numbers([A|R]) --> number_dcg(A), ",", numbers(R).
numbers([A]) --> number_dcg(A).

joltages(Joltages) --> "{", numbers(Joltages), "}".