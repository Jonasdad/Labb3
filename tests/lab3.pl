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
check(_, L, S, [], X) :- member([S, List], L), member(X, List).
check(_, L, S, [], neg(X)) :- member([S, List], L), \+member(X, List).
% And
check(T, L, S, [], and(F,G)) :- check(T, L, S, [], F), check(T, L, S, [], G).
% Or
check(T, L, S, [], or(F,G)) :- check(T, L, S, [], F); check(T, L, S, [], G).
% AX
check(T, L, S, [], ax(F)) :- member([S, List], T), check(T, L, List, [], F).
% EX
check(T, L, S, [], ex(F)) :- member([S, List], T), member(X, List), check(T, L, X, [], F).
% AG
check(T, L, S, [], ag(F)) :- check(T, L, S, [], F), check(T, L, S, [], ax(ag(F))).
% EG
check(T, L, S, [], eg(F)) :- check(T, L, S, [], F), check(T, L, S, [], ex(eg(F))).
% EF
check(T, L, S, [], ef(F)) :- check(T, L, S, [], F); check(T, L, S, [], ex(ef(F))).
% AF
check(T, L, S, [], af(F)) :- check(T, L, S, [], F); check(T, L, S, [], ax(af(F))).