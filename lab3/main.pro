implement main
    open core, stdio, file

domains
    major = информатика; математика.

class facts - studentsDB
    студент : (integer StudencheskiyId, string Name, integer PhoneNumber, integer Age).
    группа : (integer GroupId, major Major, integer Course, string GroupName, integer CreationYear).
    учится_в : (integer GroupId, integer StudencheskiyId).
    староста : (integer GroupId, integer StudencheskiyId).
    предмет : (integer SubjectId, string Subject, major Major, integer Course).

class predicates  % Вспомогательные предикаты
    длина : (A*) -> integer N.
    сумма_элем : (real* List) -> real Sum.
    среднее_списка : (real* List) -> real Average determ.

clauses
    длина([]) = 0.
    длина([_ | T]) = длина(T) + 1.

    сумма_элем([]) = 0.
    сумма_элем([H | T]) = сумма_элем(T) + H.

    среднее_списка(L) = сумма_элем(L) / длина(L) :-
        длина(L) > 0.

class predicates
    средВозраст : (string GroupName) -> real N determ.
clauses
    средВозраст(GroupName) =
        среднее_списка(
            [ Age ||
                студент(StudencheskiyId, Name, _, Age),
                группа(GroupId, _, _, GroupName, _),
                учится_в(GroupId, StudencheskiyId)
            ]).

class predicates
    write_string : (string* Строки).
clauses
    write_string(L) :-
        foreach Элемент = list::getMember_nd(L) do
            write(Элемент, '; ')
        end foreach,
        write('\n').

class predicates
    колвоСтудентовВГруппе : (string GroupName) -> integer N determ.
clauses
    колвоСтудентовВГруппе(GroupName) = длина(студентыГруппы(GroupName)).

class predicates
    студентыГруппы : (string GroupName) -> string* Students determ.
clauses
    студентыГруппы(GroupName) = List :-
        группа(_, _, _, GroupName, _),
        !,
        List =
            [ Name ||
                студент(StudencheskiyId, Name, _, _),
                учится_в(Group_id, StudencheskiyId)
            ].

class predicates
    студенты2курса : (integer Course) -> string* Students determ.
clauses
    студенты2курса(Course) = List :-
        группа(GroupId, _, Course, _, _),
        !,
        List =
            [ Name ||
                студент(Stid, Name, _, _),
                учится_в(GroupId, Stid),
                группа(GroupId, _, Course, _, _)
            ].

clauses
    run() :-
        consult("../db.txt", studentsDB),
        fail.

    run() :-
        write("Студенты группы Инф-1-20:\n"),
        L = студентыГруппы("Инф-1-20"),
        write_string(L),
        nl,
        fail.
    run() :-
        write("Студенты 2 курса:\n"),
        N = студенты2курса(2),
        write_string(N),
        nl,
        nl,
        fail.
    run() :-
        write("Количество студентов группы Инф-1-20:\n"),
        Kolvo = колвоСтудентовВГруппе("Инф-1-20"),
        write(Kolvo),
        nl,
        nl,
        fail.
    run() :-
        write("Средний возраст студентов группы Инф-1-20:\n"),
        AvgAge = средВозраст("Инф-1-20"),
        write(AvgAge),
        nl,
        fail.
    run().

end implement main

goal
    console::runUtf8(main::run).
