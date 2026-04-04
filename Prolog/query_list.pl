male(X).
grandparent(X,'Aureliano Buendía').
grandparent(X,'Aureliano Buendía').
grandparent(X,'Aureliano José').
grandfather(X,'Aureliano José').
grandmother(X,'Aureliano José').
grandmother(X,'Aureliano José').
grandparent(X,'Aureliano').
parent('Ursula Iguarán', X).
grandfather('Ursula Iguarán', X).
grandmother('Ursula Iguarán', X).
ancestor(X,Y).
ancestor('Jose Arcadio Buendía',Y).
ancestor('José Arcadio Buendía',Y).
aunt(X,'Aureliano Babilonia').
aunt(X,'Aureliano Babilonia').
projection([X]), aunt(X,'Aureliano Babilonia').
distinct([X], aunt(X,'Aureliano Babilonia')).
distinct([X], uncle(X,'Aureliano Babilonia')).
sentence.
list_aunt('Aureliano José', Aunts).
no_children(X).
ancestor(Y,'José Arcadio Buendía').