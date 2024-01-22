implement main
    open core, stdio, file

domains
    course = оценка; группа; студбилет; увлечения.

class facts - footballDB
    группа : (integer Id_Group, string Group, integer Nomer_gr, integer God_post, integer Course) nondeterm.
    староста : (integer Id, string Group, integer Nomer_gr, integer God_post, integer Course, integer Studbilet) nondeterm.
    предмет : (integer Id, string Group, integer Course, string Nazvanie_pr) nondeterm.
    оценка : (integer Id, integer Studbilet, integer Otsenka) nondeterm.
    кружок : (integer Studbilet, string Uvlechenie) nondeterm.
    студент : (string Fio, integer Id_Group, integer Studbilet, integer Phone, integer Sem1, integer Sem2, integer Stipendia) nondeterm.

class predicates
    кто_успешнее : (string Fio, integer Sem1, integer Sem2, integer Stipendia) nondeterm anyflow.
clauses
    кто_успешнее(Fio, Sem1, Sem2, Stipendia) :-
        студент(Fio, _, _, _, Sem1, Sem2, Stipendia),
        Sem2 > Sem1,
        Stipendia = Sem2.

clauses
    run() :-
        consult("../student.txt", footballDB),
        fail.

    run() :-
        кто_успешнее(Fio, Sem1, Sem2, Stipendia),
        write(Fio),
        write(": "),
        write(Stipendia),
        nl,
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
