% For SICStus, uncomment line below: (needed for member/2)
:- use_module(library(lists)).
:- discontiguous check/5.
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
ok(_,_,[],_,_).
ok(T,L,[H|R],U,F):-check(T,L,H,U,F),ok(T,L,R,U,F).

check(_, L, S, [], X):- member([S, List], L), member(X, List),write('literal').
check(_, L, S, [], neg(X)):- member([S, List], L), \+member(X, List),write('neg').
% And
check(T, L, S, U, and(F,G)):- check(T, L, S, [], F), check(T, L, S, [], G),write('And').
% Or
check(T, L, S, U, or(F,G)):- check(T, L, S, [], F),write('Or(F)').
check(T, L, S, U, or(F,G)):- check(T, L, S, [], G),write('Or(G)').
% AX
check(T, L, S, [], ax(F)) :- member([S, List], T),
                        ok(T,L,List,[], F),write('Ax').
% EX
check(T, L, S, [], ex(F)) :- member([S, List], T), 
                        member(New, List), check(T,L,New,[],F),write('Ex').
% AG - For every single path from S in the Graph, F is ALWAYS true. Action: Implement DFS.


% 1. Check literal on current state, if true -> Proceed
% 2. Add current state to visited list
% 3. Step to neighbor
% 4. repeat 1-3
check(_, _, S, U, ag(_)) :- member(S, U). % Cycle detection
check(T, L, S, U, ag(F)) :- \+member(S,U),
    check(T, L, S, [], F),
    member([S,List], T),
    ok(T,L,P,[S|U],ag(F)),write('Ag').


% EG - For some path from S, F becomes true and stays true from that point on.
% 1. 
check(_, _, S, U, eg(_)):- member(S, U).
check(T,L,S,U,eg(F)):- \+member(S,U),
                        check(T,L,S,[],F),
                        member([S,P],T),
                        member(New,P),
                        check(T,L,New,[S|U],eg(F)),write('Eg').


% EF - For some future path P from S, F becomes true. 
check(T,L,S,U,ef(F)):- \+member(S,U), check(T,L,S,[],F).
check(T,L,S,U,ef(F)):- \+member(S,U), member([S,P],T),
                        member(S2,P),
                        check(T,L,S2,[S|U],ef(F)),write('ef').
% AF - For all future paths from S, F becomes true.
check(T,L,S,U,af(F)):- \+member(S,U),
                        check(T,L,S,[],F).
check(T,L,S,U,af(F)):- \+member(S,U),
                        member([S,List],T),
                        ok(T,L,List,[S|U], af(F)),write('af').