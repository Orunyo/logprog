
% Домены
domain(units, [few, alot, enough]).
:- use_module(library(clpfd)).

% Предикаты и правила

% Поиск доступных лекарств в аптеках
available(Pharm, Name) :-
    pharmacy(PharmId, Pharm, _, _, _),
    sells(PharmId, MedId, _, _),
    medicine(MedId, Name).

% Поиск аптеки по ID
searchByID(Id, Pharm, Location, Phone, Budget) :-
    pharmacy(Id, Pharm, Location, Phone, Budget).

% Поиск аптек, в которых доступно указанное лекарство
searchByMedicine(Name, Pharmacies) :-
    medicine(MedId, Name),
    sells(PharmId, MedId, _, _),
    pharmacy(PharmId, Pharm, _, _, _),
    \+ member(Pharm, Pharmacies),
    searchByMedicine(Name, [Pharm | Pharmacies]).
searchByMedicine(_, []).

% Получение сводки о бюджете аптек
budget_summary(TotalBudget) :-
    findall(Budget, pharmacy(_, _, _, _, Budget), Budgets),
    sum(Budgets, #=, TotalBudget).

% Запуск программы
run() :-
    available(P, T),
    write("Лекарство '", T, "' доступно в аптеке '", P, "'\n"),
    fail.

run() :-
    searchByID(Y, X, Z, W, _),
    write("Аптека ID:", Y, ", Название:", X, ", Адрес:", Z, ", Телефон:", W, "\n"),
    fail.

run() :-
    searchByMedicine(M, Pharmacies),
    write("Лекарство '", M, "' доступно в следующих аптеках: ", Pharmacies, "\n"),
    fail.

run() :-
    budget_summary(TotalBudget),
    write("Общий бюджет ап
