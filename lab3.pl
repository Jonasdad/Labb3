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
% AG - For every single path from S in the Graph, F is ALWAYS true. Action: Implement DFS.
check(T, L, S, U, ag(F)):- member(S,U).
check(T, L, S, U, ag(F)) :- \+member(S, U), 
                        append([S], U, U2),
                        [Head|Next] = List,!, 
                        checkag(T, L, List, U2, ag(F)),
                        check(T, L, S, U2, F).
checkag(_,_,[],_,_).
checkag(T,L,[S|R],U,F):-check(T,L,S,U,F),checkag(T,L,R,U,F).


% EG - For some path from S, F becomes true and stays true from that point on.

% EF - For some future path P from S, F becomes true. 

% AF - For all future paths from S, F becomes true.