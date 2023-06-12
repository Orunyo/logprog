implement main
    open core, stdio, file

domains
    dentist = string.
    patient = string.
    tooth = integer.
    treatment = string.

class predicates
    print_list : (string*) nondeterm.
    print_list : (main::dentalDb*) nondeterm.
    find_patients_by_dentist : (dentist Dentist, main::dentalDb* Patients) nondeterm.
    find_treatments_by_patient : (patient Patient, main::dentalDb* Treatments) nondeterm.
    count_tooth_conditions : (string Condition, main::dentalDb* ToothList, integer Count) determ.
    average_patient_age : (main::dentalDb* Patients, real Average) determ.

clauses
    print_list([]).
    print_list([X | Y]) :-
        write(X),
        nl,
        print_list(Y).

    find_patients_by_dentist(Dentist, Patients) :-
        Patients = [patient(Name, Age, Gender) || patient(Name, Age, Gender) : main::patient(Name, Age, Gender), main::dentist(Dentist, _, _) ].

    find_treatments_by_patient(Patient, Treatments) :-
        Treatments = [treatment(Name, Description, Duration) || treatment(Name, Description, Duration) : main::treatment(Name, Description, Duration), main::patient(Patient, _, _) ].

    count_tooth_conditions(Condition, ToothList, Count) :-
        Count = length([ tooth(Number, Location, Condition) || tooth(Number, Location, Condition) : main::tooth(Number, Location, Condition) in ToothList ]).

    average_patient_age(Patients, Average) :-
        Average = laverage([ Age || patient(_, Age, _) : main::patient(_, Age, _) in Patients ]).

clauses
    run() :-
        file::consult("facts.pl", dentalDb),
        fail.
    run() :-
        write("Patients for dentist:"),
        nl,
        find_patients_by_dentist("Dr. Smith", Patients),
        print_list(Patients),
        nl,
        write("Treatments for patient:"),
        nl,
        find_treatments_by_patient("John", Treatments),
        print_list(Treatments),
        nl,
        write("Count of healthy teeth:"),
        nl,
        count_tooth_conditions("Healthy", [ tooth(_, _, Condition) || tooth(_, _, Condition) ], Count),
        write(Count),
        nl,
        write("Average patient age:"),
        nl,
        average_patient_age([ patient(_, Age, _) || patient(_, Age, _) ], Average),
        write(Average),
        nl,
        fail.
    run() :-
        stdio::write("End test\n").

end implement main

goal
    console::runUtf8(main::run).
