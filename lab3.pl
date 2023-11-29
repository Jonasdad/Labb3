% For SICStus, uncomment line below: (needed for member/2)
:- use_module(library(lists)).
% Load model, initial state and formula from file.
verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).
% check(T, L, S, U, F)
% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.
%
% Should evaluate to true iff the sequent below is valid.
%
% (T,L), S |- F
% U
% To execute: consult('your_file.pl'). verify('input.txt').
% Literals
check(_, L, S, U, X) :- member([S, List], L), member(X, List).
check(_, L, S, U, neg(X)) :- member([S, List], L), \+member(X, List).
% And
check(T, L, S, U, and(F,G)) :- check(T, L, S, U, F), check(T, L, S, U, G).
% Or
check(T, L, S, U, or(F,G)) :- check(T, L, S, U, F); check(T, L, S, U, G).
% AX
check(T, L, S, U, ax(F)) :- member([S, List], T), 
                        check(T, L, List, U, F).
% EX
check(T, L, S, U, ex(F)) :- member([S, List], T), 
                        member(X, List),   
                        check(T, L, X, U, F).
% AG
check(T, L, S, U, ag(F)) :- member([S, LList], L), 
                        member([S, List], T), 
                        \+member(S, U), 
                        append([S], U, U2), 
                        [Head|Next] = List,!, 
                        checkag(T, L, List, U2, ag(F)),
                        check(T, L, S, U2, F).

checkag(T, L, [], U, ag(F)).
checkag(T, L, [S|Rest], U, ag(F)):- (\+member(S,U); (check(T, L, Rest, U, ag(F)))), 
                                    append([S], U, U2),
                                    member([S, List], L),
                                    member(F, List),
                                    checkag(T, L, Rest, U2, ag(F)).
                                        
% EG

% EF

% AF