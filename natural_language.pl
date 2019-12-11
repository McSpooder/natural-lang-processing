/* Ok some background on grammars

as a background to this have a look at
http://en.wikipedia.org/wiki/English_grammar
which will explain where we are coming from.

What we are doing is analysing the syntax of an input. As the lectures
emphasised this is only the first part. Where we are going is
beyond Eliza towards Alice. Can we understand the <subject>
<object> and <verb> in a sentence, i.e. *who* is doing *what* to *whom*.

This is useful for an AI on the Semantic Web and also a NPC is Games.

There are three essentials to understanding natural language....

1.  Syntax --- what we are doing this week
2. Semantics --- the meaning of symbols --- remember sometimes words
have two meanings e.g. capitol. When you start to include agents with
beliefs then this also brings in words like right and wrong e.g. was
Trotsky a good man or not - depends upon your beliefs
3. Pragmatics - what do you actually mean e.g. "I love Dr Brayshaw's
Prolog Lectures"............. ;-) a rivetting encounter with a new
programing paradigm or a chance to catch up on some missing sleep.

Now some quick terminolgy.  The lexicon of syntax is as follows.

NP = Noun Phrase - this contains a major noun either as the subject or the object of a sentence
VP = Verb Phrase- in the simple sentences we shall consider it will contain the principle verb of the sentence
Det - a determiner e.g. a or the
PP -  Prepositional Phrase - typically goes before a noun  phrase e.g. <on> NP the plate or <with> a crack
A sentence consists of a Noun  Phrase and a Verb Phrase - hence S -> NP,VP
-> means symbol brakes down to contain

The other essential is a Context Free Grammar. The one were are going to
use here is

S -> NP VP	e.g. John loves Mary
S -> VP		e.g. Go!
NP -> Det NP2
NP -> NP2
NP -> NP PP
NP2 -> Noun
NP2 -> Adj NP2
PP -> Prep NP
VP -> Verb
VP -> Verb NP
VP -> VP PP

This is a fairly standard grammar and will service us here. The treatise
on this subject is
Winodgrad, T., Language as a Cognitive Process,
Volume 1: Syntax, Addison-Wesley(Menlo-Park, California), 1983, ISBN
0-201-08571-2
This is still the definite tome in the area.

Now to Prolog

The task in hand is to parse the sentence

The cat sat on the mat.

We assume that we can read this in to Prolog as a list (see earlier Labs
on how to do this).

Thus the input to the program is going to be the list
[the,cat,sat,on,the,mat].

*/

/* so a sentence is made up of a nown phrase and a verb phrase */

sentence(Sentence,sentence(np(Noun_Phrase),vp(Verb_Phrase))):-
	/* so take a sentence (first arg) and parse it into a noun phrase and a verb phase */
	np(Sentence,Noun_Phrase,Rem),
	vp(Rem,Verb_Phrase).
/* ok a (noun phrase) np can be one of three things
NP -> Det NP2
NP -> NP2
NP -> NP PP
so we need three clauses to do this

and then we hand back the remainder. This does mean that we might find a
correct parse that is not what we are looking for and then we have to
hope that backtracking will sort this out. Compare and contrast this
with what the WREN girls did with the BOMBE at Bletchley Park - ok
essentially a gear driven device but there are similiarities.....  */

np([X|T],np(det(X),NP2),Rem):-
	det(X),
	np2(T,NP2,Rem).
np(Sentence,Parse,Rem):- np2(Sentence,Parse,Rem).
np(Sentence,np(NP,PP),Rem):-
	/* e.g. Jane on the dance_floor */
	np(Sentence,NP,Rem1),
	pp(Rem1,PP,Rem).

/* ok the next bit
NP2 -> Noun
NP2 -> Adj NP2

so we want to deal with recursive numbers of adjectives as in
the quick brown fox
or as in the lecture
the lazy lazy fat cat
*/
np2([H|T],np2(noun(H)),T):- noun(H).  /* ok cute H, so you are a noun */
np2([H|T],np2(adj(H),Rest),Rem):- adj(H),np2(T,Rest,Rem).  /* shove the adj(H) into the to be retured answer and then recurse on the rest of the phrase to return the parse and the remainder of the sentence */

/* last bit I'm giving you is this
PP -> Prep NP
*/
pp([H|T],pp(prep(H),Parse),Rem):-
	prep(H),
	np(T,Parse,Rem).

/* now your task for the week is to figure out

VP -> Verb
VP -> Verb NP
VP -> VP PP

simplify matters and don't worry about Rem - if the end of the sentence
isn't understood then .....................

so you need to define
vp([H|[]],verb(H)):-
vp([H|Rest],vp(verb(H),RestParsed)):- check if H is a verb and recurse
on NP vp([H|Rest],vp(verb(H),RestParsed)):- otherwise check if H is a
verb and recurse on PP

once you have done that you will have your own complete context free
grammar english language parsing system that you can use wherever you
want

and how many lines of Prolog have I actually written.

Notice how many lines of comment I put into my programs

*/

/* and don't forget we need to describe some english to Prolog as facts */
det(the).
noun(cat).
noun(mat).
verb(sat).
prep(on).
adj(big).
adj(fat).
adj(comfy).

/* you now can attempt to run this program e.g.

?- np([the,cat,sat,on,the,mat],O,L).
O = np(det(the), noun(cat)),
L = [sat, on, the, mat]
Where O is the Parse output
and L is the remainder as yet not parsed part
2 ?- pp([on,the,mat],P,L).

P = pp(prep(on), np(det(the), noun(mat))),
L = []

?- np([the,big,fat,cat,sat,on,the,mat],P,L).
P = np(det(the), np2(adj(big), np2(adj(fat), np2(noun(cat))))),
L =  [sat, on, the, mat]
*/


/* ok - your last bit of lab work *before the ACW* how would you expand this cover the sentence

the yellow orange rabbit ran_away with the silvery moon  */


