:-dynamic contador/1.%guarda resultado consulta 1
:-dynamic tgrupos/1.%total de grupos consulta 2
:-dynamic scoords/1.%lista con los tomaños de tods coords consul 3
:-dynamic tsizes/1.%lista de tamagnos consulta 2
:-dynamic gcoords/1.%coords de cada grupo consulta 2
:-dynamic casilla/3.
:-dynamic coords/1.%coords de todos los grupos sin repetir consulta 2
:-dynamic tcoords/1.%total coords de todos los grupos consulta 3
:-dynamic conectado/2.
:- dynamic usada/1.%para no repetir coords usadas
contador(0).
tsizes([]).
tgrupos(0).
gcoords([]).
coords([]).
tcoords([]).
usada([]).
scoords([]).
%-----------------------------------------------

%-----------------------------------------------
camino(Cx,Cy, Cx1, Cy1):-
    conectado(casilla(Cx,Cy,1), casilla(Cx1,Cy1,1));
    conectado(casilla(Cx1,Cy1,1), casilla(Cx,Cy,1)).

agregar(X, L, [X|L]).

tamagno2(Cx, Cy, Ruta, Res):-
    contador(X),
    N is X+1,
    retractall(contador(_)),
    assert(contador(N)),
    gcoords(Coords),
    agregar([Cx|Cy], Coords, Lnueva),
    retractall(gcoords(_)),
    assert(gcoords(Lnueva)),
    camino(Cx,Cy,Cx1,Cy1),
    not(member([Cx1|Cy1],Ruta)),
    tamagno2(Cx1,Cy1, [[Cx|Cy]|Ruta],Res).

tamagno2(_,_,[],_).

%c1: consulta 1
c1(Cx,Cy,0,[]):-
    (conectado(casilla(Cx,Cy,0),_);
    conectado(_,casilla(Cx,Cy,0))),!.

c1(Cx,Cy,N, Gcoords):-
    retractall(contador(_)),
    assert(contador(0)),
    tamagno2(Cx,Cy,[],_),
    contador(X),
    N is X,
    retractall(contador(_)),
    assert(contador(0)),
    gcoords(Gcoords),
    retractall(gcoords(_)),
    assert(gcoords([])).


%c2: consulta 2

c_2_3(Cx,Cy,Cx1,Cy1, T, S, C, CT, SCT):-
    retractall(contador(_)),
    assert(contador(0)),
    retractall(tsizes(_)),
    assert(tsizes([])),
    retractall(scoords(_)),
    assert(scoords([])),
    retractall(usada(_)),
    assert(usada([])),
    retractall(gcoords(_)),
    assert(gcoords([])),
    retractall(coords(_)),
    assert(coords([])),
    retractall(tcoords(_)),
    assert(tcoords([])),
    retractall(tgrupos(_)),
    assert(tgrupos(0)),
    recorre(Cx,Cy,Cx1,Cy1),
    tgrupos(T),
    tsizes(Sizes),
    ordenaIns(Sizes,S),
    scoords(SCT1),
    ordenaIns(SCT1,SCT),
    coords(C),
    tcoords(CT1),
    ordenaIns1(CT1,CT),
    !.


verifica(T, C):-
    (

    Cero is 0,
    not(T=Cero),
    tsizes(Sizes),
    not(member(T,Sizes)),
    agregar(T, Sizes, Nsizes),
    coords(Coords1),
    not(member(C,Coords1)),
    agregar(C, Coords1, Coords),
    retractall(coords(_)),
    assert(coords(Coords)),
    retractall(tsizes(_)),
    assert(tsizes(Nsizes)),
    tgrupos(Tg),
    N is Tg+1,
    retractall(tgrupos(_)),
    assert(tgrupos(N)));
    (
        _ is 4

    ).

long([],0).
long([_|Xs],L) :- long(Xs,L1), L is L1+1.
inserta(X,[],[X]).
inserta(X,[Y|Ys],[X,Y|Ys]) :- X < Y.
inserta(X,[Y|Ys],[Y|Zs]) :- X >= Y, inserta(X,Ys,Zs).
ordenaIns([],[]).
ordenaIns([X|Xs],Ys) :- ordenaIns(Xs,Xs0), inserta(X,Xs0,Ys).

inserta1(X,[],[X]).

inserta1(X,[Y|Ys],[X,Y|Ys]) :-
    long(X, X1),
    long(Y, Y1),
    X1 < Y1.

inserta1(X,[Y|Ys],[Y|Zs]) :-
    long(X, X1),
    long(Y, Y1),
    X1 >= Y1,
    inserta1(X,Ys,Zs).

ordenaIns1([],[]).
ordenaIns1([X|Xs],Ys) :-
    ordenaIns1(Xs,Xs0),
    inserta1(X,Xs0,Ys).

%verusada(_, []).

verusada(V, [CA|CO]):-
    member(V, CA);
    verusada(V,CO).

todasCoords(Cx,Cy,T,C):-
    (
    Cero is 0,
    not(T=Cero),
    usada(L),
    (
    L=[];
    not(verusada([Cx|Cy], L))
    ),
    tcoords(TCoords1),
    agregar(C, L, L1),
    agregar(C, TCoords1, TCoords),
    scoords(Sc),
    agregar(T, Sc, Nsizes),
    retractall(tcoords(_)),
    assert(tcoords(TCoords)),
    retractall(usada(_)),
    assert(usada(L1)),
    retractall(scoords(_)),
    assert(scoords(Nsizes))
    );
    (
     % assert(usada(Cx,Cy));
        _ is 4

    ).

recorre(A,_,A,_).

recorre(Cx,Cy,Cx1,Cy1):-
    recorre1(Cx,Cy,Cy1),
    A is Cx+1,
    recorre(A,Cy,Cx1,Cy1),!.

recorre1(_,A,A).

recorre1(Cx,Cy,Cy1):-
    c1(Cx,Cy,T,C),
    verifica(T, C),
    todasCoords(Cx,Cy,T,C),
    B is Cy+1,
    recorre1(Cx,B,Cy1).