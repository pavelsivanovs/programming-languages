pp(A,B,C,D,E) :-
    is_list(A), is_list(B), is_list(C), is_list(D), is_list(E),
    conjunct(A,B,D), p2(A,B,C,E),
    p3(D,A), p4(E,A).

/**
 * Predikāts conjunction atgriež true tad un tikai tad,
 * kad saraksts C satur visus tos un tikai 
 * tos A saraksta elementus, kuri ir arī saraksta B elementi.
 */
conjunct([], _, []).
conjunct(_, [], []). 
conjunct(A, B, C) :- 
    does_not_have_excessive_elements(A,C),
    has_all_common_elements(A,B,C).

/**
 * Predikāts has_all_common_elements atgriež true tad un tikai tad,
 * kad visi saraksta A elementi, kas ir saraksta B elementi,
 * ir arī saraksta C elementi.
 */
has_all_common_elements([], _, []).
has_all_common_elements(_, [], []).
has_all_common_elements([A|ATail], B, C) :-
    (
        ( member(A,B), member(A,C) ) ; 
        ( \+ member(A,B), \+ member(A,C) )
    ), has_all_common_elements(ATail, B, C).
has_all_common_elements([A|[]], B, C) :-
    ( member(A,B), member(A,C) ) ; ( \+ member(A,B), \+ member(A,C) ). 

/**
 * Predikāts atgriež true tad un tikai tad, 
 * kad visi C saraksta elementi ir sastopami sarakstā A.
 */
does_not_have_excessive_elements(_, []).
does_not_have_excessive_elements(A, [C|CTail]) :-
    member(C,A), does_not_have_excessive_elements(A, CTail).
does_not_have_excessive_elements(A, [C|[]]) :- member(C,A).

/**
 * Predikāts p2 atgriež true tad un tikai tad, kad saraksts
 * E satur visus tos un tikai tos saraksta A elementus, kas nav
 * elementi sarakstā B, bet ir elementi sarakstā C.
 */
p2(A,B,C,E) :-
    does_not_have_excessive_elements(A,E),
    p2_main(A,B,C,E).

/**
 * Predikāts p2_main atgriež true tad un tikai tad,
 * kad saraksta A elementi, kas nav saraksta B elementi,
 * ir saraksta C elementi, ir arī saraksta E elementi.
 */
p2_main([],_,_,[]).
p2_main([A|[]],B,C,E) :- \+ member(A,B), member(A,C), member(A,E).
p2_main([A|[]],B,C,E) :- ( member(A,B) ; \+ member(A,C) ), \+ member(A,E).
p2_main([A|AS],B,C,E) :-
    \+ member(A,B), member(A,C), member(A,E),
    p2_main(AS,B,C,E).
p2_main([A|AS],B,C,E) :-
    ( member(A,B) ; \+ member(A,C) ), \+ member(A,E),
    p2_main(AS,B,C,E).

/**
 * Predikāts atgriež true tad un tikai tad, kad katrs D saraksta
 * elements X sastopas tik pat daudz reižu sarakstā A, cik elements X sarakstā D.
 */
p3([],_).
p3(D,A) :- check_elem_count(D,D,A,1).

/**
 * Predikāts atgriež true tad un tikai tad, kad katrs E saraksta
 * elements X sastopas trīs reizēs vairāk reižu sarakstā A, cik elements X sarakstā E.
 */
p4([],_).
p4(E,A) :- check_elem_count(E,E,A,3).

/**
 * Predikāts check_elem_count atgriež true tad un tikai tad, kad saraksta [X|XS]
 * X elements sastopas sarakstā B tik pat reizes, cik elements X sastopas sarakstā A
 * reiz Multiplier.
 */
check_elem_count([],_,_,_).
check_elem_count([X|XS],B,A,Multiplier) :-
    count_elem(X,B,CountB), count_elem(X,A,CountA),
    CountB is CountA * Multiplier,
    check_elem_count(XS,B,A,Multiplier).

/**
 * Predikāts count_elem atgriež Count argumenta vērtību, kas apzīmē
 * cik daudz X elements sastopas sarakstā [Head|Tail].
 */
count_elem(_,[],0).
count_elem(X,[Head|Tail],Count) :-
    ( X = Head, count_elem(X,Tail,Count1), Count is Count1 + 1 ) ;
    ( X \= Head, count_elem(X,Tail,Count)).
count_elem(X,[Head|[]],Count) :-
    ( X = Head, Count is 1) ;
    ( X \= Head, Count is 0).