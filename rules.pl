%batuhan tongarlak 
location(T1,R,C) :-
	T0  is T1 - 1,
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	(
	  ((action(T0,eat);action(T0,clockWise);action(T0,counterClockWise)), location(T0,R,C));
	  ((action(T0,attack);action(T0,forward)), bump(T1), location(T0,R,C));
	  ((action(T0,attack);action(T0,forward)), dir(T0,north), not(bump(T1)), location(T0,RS,C));
	  ((action(T0,attack);action(T0,forward)), dir(T0,south), not(bump(T1)), location(T0,RN,C));
	  ((action(T0,attack);action(T0,forward)), dir(T0,west),  not(bump(T1)), location(T0,R,CE));
	  ((action(T0,attack);action(T0,forward)), dir(T0,east),  not(bump(T1)), location(T0,R,CW))
	).

dir(T1,north) :-
	T0 is T1 - 1,
		  (
				  ((action(T0,eat);action(T0,attack);action(T0,forward)), dir(T0,north) );
				  (action(T0,clockWise)       , dir(T0,west));
				  (action(T0,counterClockWise), dir(T0,east))
		  ).
  
dir(T1,east) :-
	T0 is T1 - 1,
		  (
				  ((action(T0,eat);action(T0,attack);action(T0,forward)), dir(T0,east));
				  (action(T0,clockWise)       , dir(T0,north));
				  (action(T0,counterClockWise), dir(T0,south))
		  ).
  
dir(T1,south) :-
	T0 is T1 - 1,
		  (
				  ((action(T0,eat);action(T0,attack);action(T0,forward)), dir(T0,south));
				  (action(T0,clockWise)       , dir(T0,east));
				  (action(T0,counterClockWise), dir(T0,west))
		  ).
  
dir(T1,west) :-

	T0 is T1 - 1,
		  (
				  ((action(T0,eat);action(T0,attack);action(T0,forward)), dir(T0,west) );
				  (action(T0,clockWise)       , dir(T0,south));
				  (action(T0,counterClockWise), dir(T0,north))
		  ).
  
  /* Wall variables related */
  

%helper predicates
forany(Cond,Action) :-
	\+forall(Cond,\+Action).

try_location(R,C):-
	find_max_action(List),
	forany(member(Number, List),
	location(Number,R,C)).	
%wall q1 predicates
isWall(X,Y):-         % change in Q1
	(X =:= 0; Y =:= 0);
	isWall(_,X,Y).
		
isClear(T,R,C) :-     % change in Q1
		  hasNotWumpus(T,R,C), 
		  hasNotPit(T,R,C),
		  not(isWall(R,C)).
isWall(T,R,C) :- 

	T0 = T - 1 ,
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	(
		(bump(T),		dir(T0,south),		location(T0,RN,C));
		(bump(T),		dir(T0,west),		location(T0,R,CE));
		(bump(T),		dir(T0,north),		location(T0,RS,C));
		(bump(T),		dir(T0,east),		location(T0,R,CW))
	).


 %wumpus q2 predicates
hasNotWumpus(1,R,C):-
	find_max_action(List),
	forany(member(Number, List),
	hasNotWumpusSpecificT(Number,R,C)).

hasWumpusSmell(T,R,C):-
	location(T,R,C),
	wumpusSmell(T).

hasNotWumpusSpecificT(T,R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,

	(
		location(T,R,C);
		(not(wumpusSmell(T)),location(T,RN,C));
		(not(wumpusSmell(T)),location(T,RS,C));
		(not(wumpusSmell(T)),location(T,R,CW));
		(not(wumpusSmell(T)),location(T,R,CE));
		isWall(R,C)
	).


%pit q2 predicates
hasNotPit(1,R,C):-
	find_max_action(List),
	forany(member(Number, List),
	hasNotPitSpecificT(Number,R,C)).

hasPitBreeze(T,R,C):-
	location(T,R,C), %ben bu lokasyondayım ve o an breeze alıyroum.
	pitBreeze(T).

hasNotPitSpecificT(T,R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,

	(
		location(T,R,C);
		(not(pitBreeze(T)),location(T,RN,C));
		(not(pitBreeze(T)),location(T,RS,C));
		(not(pitBreeze(T)),location(T,R,CW));
		(not(pitBreeze(T)),location(T,R,CE));
		isWall(R,C)
	).
%q3 pit
 
hasPit(1,R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	find_max_action(List),
	(
		(checkPitsForNorth(RN,C), forany(	member(T,List),hasPitBreeze(T,RN,C)	)	); %true when there is no pit on its north, east and west
		(checkPitsForSouth(RS,C), forany(	member(T,List),hasPitBreeze(T,RS,C)	)	);
		(checkPitsForWest(R,CW), forany(	member(T,List),hasPitBreeze(T,R,CW)	)	);
		(checkPitsForEast(R,CE), forany(	member(T,List),hasPitBreeze(T,R,CE)	)	)
	).



checkPitsForNorth(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotPit(1,RN,C),
	hasNotPit(1,R,CW),
	hasNotPit(1,R,CE).

checkPitsForSouth(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotPit(1,RS,C),
	hasNotPit(1,R,CW),
	hasNotPit(1,R,CE).

checkPitsForWest(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotPit(1,RN,C),
	hasNotPit(1,RS,C),
	hasNotPit(1,R,CW).

checkPitsForEast(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotPit(1,RN,C),
	hasNotPit(1,RS,C),
	hasNotPit(1,R,CE).


%q3 wumpus
hasWumpus(1,R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	find_max_action(List),
	(
		(checkWumpusForNorth(RN,C), forany(	member(T,List),hasWumpusSmell(T,RN,C)	)	); %true when there is no pit on its north, east and west
		(checkWumpusForSouth(RS,C), forany(	member(T,List),hasWumpusSmell(T,RS,C)	)	);
		(checkWumpusForWest(R,CW), forany(	member(T,List),hasWumpusSmell(T,R,CW)	)	);
		(checkWumpusForEast(R,CE), forany(	member(T,List),hasWumpusSmell(T,R,CE)	)	)
	).



checkWumpusForNorth(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotWumpus(1,RN,C),
	hasNotWumpus(1,R,CW),
	hasNotWumpus(1,R,CE).

checkWumpusForSouth(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotWumpus(1,RS,C),
	hasNotWumpus(1,R,CW),
	hasNotWumpus(1,R,CE).

checkWumpusForWest(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotWumpus(1,RN,C),
	hasNotWumpus(1,RS,C),
	hasNotWumpus(1,R,CW).

checkWumpusForEast(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotWumpus(1,RN,C),
	hasNotWumpus(1,RS,C),
	hasNotWumpus(1,R,CE).

%q3 dead wumpus

hasDeadWumpusSpecificT(T,R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	
	(
		(	action(T,attack),	dir(T,north),	location(T,RS,C)  ,	hasWumpus(1,R,C)	);				
		(	action(T,attack),	dir(T,south),	location(T,RN,C)  ,	hasWumpus(1,R,C)	);		
		(	action(T,attack),	dir(T,west),	location(T,R,CE)  ,	hasWumpus(1,R,C)	);	
		(	action(T,attack),	dir(T,south),	location(T,R,CW)  ,	hasWumpus(1,R,C)	)
	). 


hasDeadWumpus(1,R,C):-
	find_max_action(List),
	forany(member(Number, List),
	hasDeadWumpusSpecificT(Number,R,C)).



%q4 food relaetd
	

hasNotFood(1,R,C):-
	find_max_action(List),
	forany(member(Number, List),
	hasNotFoodSpecificT(Number,R,C)).

hasFoodSmell(T,R,C):-
	location(T,R,C), %ben bu lokasyondayım ve o an breeze alıyroum.
	foodSmell(T).

hasNotFoodSpecificT(T,R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,

	(
		(	not(foodSmell(T)),	location(T,RN,C)	);
		(	not(foodSmell(T)),	location(T,RS,C)	);
		(	not(foodSmell(T)),	location(T,R,CW)	);
		(	not(foodSmell(T)),	location(T,R,CE)	);
		isWall(R,C)
	).




hasFood(1,R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	find_max_action(List),
	(
		(checkFoodsForNorth(RN,C), forany(	member(T,List),hasFoodSmell(T,RN,C)	), not(forany(	member(T,List), (action(T,eat), location(T,R,C)  )))	); %true when there is no Food on its north, east and west
		(checkFoodsForSouth(RS,C), forany(	member(T,List),hasFoodSmell(T,RS,C)	), not(forany(	member(T,List), (action(T,eat), location(T,R,C)  )))	);
		(checkFoodsForWest(R,CW), forany(	member(T,List),hasFoodSmell(T,R,CW)	), not(forany(	member(T,List), (action(T,eat), location(T,R,C)  )))	);
		(checkFoodsForEast(R,CE), forany(	member(T,List),hasFoodSmell(T,R,CE)	), not(forany(	member(T,List), (action(T,eat), location(T,R,C)  )))	)
	).


checkFoodsForNorth(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotFood(1,RN,C),
	hasNotFood(1,R,CW),
	hasNotFood(1,R,CE).

checkFoodsForSouth(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotFood(1,RS,C),
	hasNotFood(1,R,CW),
	hasNotFood(1,R,CE).

checkFoodsForWest(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotFood(1,RN,C),
	hasNotFood(1,RS,C),
	hasNotFood(1,R,CW).

checkFoodsForEast(R,C):-
	RN  is R - 1,
	RS  is R + 1,
	CW  is C - 1,
	CE  is C + 1,
	hasNotFood(1,RN,C),
	hasNotFood(1,RS,C),
	hasNotFood(1,R,CE).


%dummies

isWall(-1,-1).
isWall(-1,-1,-1).
bump(-1).
action(0,_).



%helpers
smaller(List,Number):-
	forall(member(Elem,List), Elem = Number).
	
find_max_action(List):-
	findall(X, action(X,_), Bag),
	max_list(Bag, Max),
	RealMax is Max + 1,
	append(Bag, [RealMax] , List).
	
location(1,1,8). 
dir(1,south). 
action(1,forward). 
action(2,forward). 
action(3,forward). 
action(4,counterClockWise).
action(5,forward).
bump(6).
