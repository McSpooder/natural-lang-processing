
barbara():-
   write("*************************************************************"),nl,
   write("-------------------------------------------------------------"),nl,
   write("Barbara prompt"),
   percieve(Percepts,Input),
   action(Percepts,Input),
   write("-------------------------------------------------------------"),nl,
   write("*************************************************************"),nl,
   barbara().


/*Percieve reads the users input and parses the sentence into its constituents. It then returns this as "Percepts"*/

percieve(Percepts,Input):-
   read(Input),
   sentence(Input,Percepts).

/*Action is responsible for outputing the parsed sentence via text and ascii art. This is also the procedure which leads to recomendation.*/

action(Percepts,Input):-
   Percepts = sentence(NP,VP),
   split_np(NP),
   split_vp(VP,NounWord,VerbWord),

   recommend(VerbWord,NounWord,Response),
   write("sentence"),nl,
   write("        |        |-"), write(Input),nl,nl,
   write("        |        |-"), write("produces the recommendation that"),nl,nl,
   write("                 |        |-"), write(Response),nl.



split_np(Noun_Phrase):-
   Noun_Phrase = np(NPa),
   NPa = np(DET,NP2a),
   DET = det(DeterminerWord),
   NP2a = np2(ADJa,NP2b),
   ADJa = adj(AdjWord),
   NP2b = np2(NOUNa),
   NOUNa = noun(NounWorda),

   write("sentence"),nl,
   write("        |"),nl,
   write("        |--- NP: "),write(DeterminerWord),write(" "),write(AdjWord),write(" "),write(NounWorda),nl,
   write("                    |- DET: "),write(DeterminerWord),nl,
   write("                    |- NP2: "),write(AdjWord),write(" "),write(NounWorda),nl,
   write("                                 |- ADJ: "),write(AdjWord),nl,
   write("                                 |- NP2: "),write(NOUNa),nl,
   write("                                           |- Noun: "), write(NounWorda),nl.


split_vp(Verb_Phrase,NounWord,VerbWord):-
   Verb_Phrase = vp(VP02),
   VP02 = vp(Verb,NP02),
   Verb = verb(VerbWord),
   NP02 = np(DETb,NP2),
   DETb = det(DETWordB),
   NP2 = np2(ADJb,NP22),
   ADJb = adj(ADJWordB),
   NP22 = np2(Noun),
   Noun = noun(NounWord),

   write("        |"),nl,
   write("        |--- VP: "),write(VerbWord),write(" "),write(DETWordB),write(" "),write(ADJWordB),write(" "),write(NounWord),nl,
   write("                    |- Verb: "),write(VerbWord),nl,
   write("                    |- NP: "),write(DETWordB),write(" "),write(ADJWordB),write(" "),write(NounWord),nl,

   write("                             |- DET: "),write(DETWordB),nl,
   write("                             |- NP2: "),write(ADJWordB),write(" "),write(NounWord),nl,
   write("                                      |- ADJ: "),write(ADJWordB),nl,
   write("                                      |- NP2: "),write(Noun),nl,
   write("                                              |- Noun: "),write(NounWord),nl,nl,

   act_on(VerbWord,NounWord).

split_vp(Verb_Phrase,NounWord,VerbWord):-
   Verb_Phrase = vp(VP02),
   VP02 = vp(Verb,NP02),
   Verb = verb(VerbWord),
   NP02 = np2(Noun),
   Noun = noun(NounWord),

   write("        |"),nl,
   write("        |--- VP: "),write(VerbWord),write(" "),write(NounWord),nl,
   write("                    |- Verb: "),write(VerbWord),nl,
   write("                    |- NP2: "),write(Noun),nl,
   write("                             |- Noun: "),write(NounWord),nl,nl,

   act_on(VerbWord,NounWord).

split_vp(Verb_Phrase,NounWord,VerbWord):-
   Verb_Phrase = vp(VP02),
   VP02 = vp(Verb,NP02),
   Verb = verb(VerbWord),
   NP02 = np(DET,NP2a),
   DET = det(DeterminerWord),
   NP2a = np2(Noun),
   Noun = noun(NounWord),

   write("        |"),nl,
   write("        |--- VP: "),write(VerbWord),write(" "),write(DeterminerWord),write(" "),write(NounWord),nl,
   write("                    |- Verb: "),write(VerbWord),nl,
   write("                    |- NP: "),write(DeterminerWord),write(" "),write(NounWord),nl,
   write("                             |-DET: "),write(DeterminerWord),nl,
   write("                             |- NP2: "),write(Noun),nl,
   write("                                   |-Noun: "),write(NounWord),nl,nl,

   act_on(VerbWord,NounWord).



act_on(Verb,Noun):-
   recommend(Verb,Noun,Response),
   write(Response),nl,nl.

act_on(Verb,_):-
   member(Verb,[loves,likes,enjoys]),
   write("Its good that you have positive feelings towards this."),nl,nl.


sentence(Sentence,sentence(np(Noun_Phrase),vp(Verb_Phrase))):-
	/* so take a sentence (first arg) and parse it into a noun phrase and a verb phase */
	np(Sentence,Noun_Phrase,Rem),
	vp(Rem,Verb_Phrase).


np([X|T],np(det(X),NP2),Rem):-
	det(X),
	np2(T,NP2,Rem).
np(Sentence,Parse,Rem):- np2(Sentence,Parse,Rem).


np2([H|T],np2(noun(H)),T):- noun(H).  /* ok cute H, so you are a noun */
np2([H|T],np2(adj(H),Rest),Rem):- adj(H),np2(T,Rest,Rem).

pp([H|T],pp(prep(H),Parse),Rem):-
	prep(H),
	np(T,Parse,Rem).

vp([H|[]],verb(H)).

vp([H|Rest],vp(verb(H),RestParsed)):-
        verb(H),
	np(Rest,RestParsed,_).
vp([H|Rest],vp(verb(H),RestParsed)):-
        verb(H),
	pp(Rest,RestParsed,_).

recommend(likes,book,"They should join a book club.").
recommend(loves,horses,"They should join a riding club").
recommend(loves,walk,"They should join a rambling club").
recommend(likes,chat,"They should join a social club.").
recommend(likes,guitar,"They should join a band").
recommend(loves,car,"They should go to the races").

det(my).
det(an).
det(the).
det(a).
det(an).
det(is).
det(youre).
noun(hey).
noun(slimshady).
noun(name).
noun(cat).
noun(mat).
noun(father).
noun(book).
noun(boy).
noun(horses).
noun(grandfather).
noun(walk).
noun(person).
noun(chat).
noun(student).
noun(guitar).
noun(petrolhead).
noun(car).
verb(loves).
verb(being).
verb(sat).
verb(likes).
prep(on).
adj(racing).
adj(very).
adj(loud).
adj(avid).
adj(young).
adj(social).
adj(sprightly).
adj(long).
adj(teenage).
adj(good).
adj(big).
adj(old).
adj(fat).
adj(comfy).














