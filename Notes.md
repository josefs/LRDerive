% LR parsing and the derivative of context free grammars
% Josef Svenningsson
% 

In the beginning Knuth described the LR parsing algorithm using point 
productions to track the progress of parsing through the context free 
grammar. I believe that this process can be described more neatly using 
derivatives much like Brozovski (check spelling) did with regular 
expressions.

In order to show this it would be nice to have a representation of 
context free grammars that is easier to manipulate. Something that looks 
closer to regular expressions and the types that Conor had in his paper.

I have some rough idea on what this representation could look like. The 
problem is with the fixpoint. Either, one could go with one big fat 
tuple to represent the different productions. Or one could use some kind 
of index function in the style of Andres Löh and c:o's latest paper.

I looked a bit further in Löh & c:o's paper, mostly to find some 
references. However, the references that were there were of no use. The 
paper by Grant Makholm isn't available online, which is a great pity 
since I suspect it would have been useful. The other thing they cite is 
a tutorial by Swierstra et. al. which doesn't give a solution to the 
problem at all afaics.

Some literature study.

* This paper might be of interest. At least they talk about fixpoints 
  and context free grammars.
  [Fix point internal hierarchy specification for context free grammars](http://portal.acm.org/citation.cfm?id=1354000)
* [Context-free languages of infinite words as least fixpoints](http://www.springerlink.com/content/p483887717081555/)
* Looks promising: [Unique fixpoints in complete lattices with applications to formal languages and semantics](http://www.springerlink.com/content/m72268528442x7v0/)
* Francois Pottier has an interesting pearl which seems to have some 
  relevant material: [Lazy Least Fixed Points in ML](pauillac.inria.fr/~fpottier/publis/fpottier-fix.pdf)
* Minamide has a paper which also could be of interest
  [Verified Decision Procedures on Context-Free Grammars](www.score.is.tsukuba.ac.jp/~minamide/papers/tphols07.pdf)
* Neil Jones mentioned an early paper which characterized context free
  grammars as least fixpoints. It was by [Seymour Ginsburg](http://portal.acm.org/author_page.cfm?id=81100567281&query=(Author%3A81100567281)%20&querydisp=(Author%3A81100567281)%20&role=Author&perpage=10&start=21&slide=4&srt=meta_published_date%20dsc&short=0&source_disp=&since_month=&since_year=&before_month=&before_year=&coll=GUIDE&dl=GUIDE&termshow=matchboolean&range_query=&CFID=41963999&CFTOKEN=57099012). I should make sure to read through some of his papers.

* I also want to read Knuth's original paper. I've found a scanned
  version of the first couple of pages on the net. The whole paper is
  in a book "Selected Paper on Computer Languages". It's available
  rather inexpensively from amazon.co.uk. I've bought myself a copy.


# The representation

We present a compositional representation of context free
grammars. Although it is new it is not very surprising.

$\begin{array}{lcl}
G,H \in \text{Grammar} & ::= & x \: | \: 0 \: | \: 1 \: | \: G \cdot  H \: | \: G \: + \: H \: | \: T \: A\\
T \in \text{Grammar Tuples} & ::= & r \: | \: \mu r . \displaystyle\prod_{A \in N} G_A
\end{array}$

$A,B$ ranges over indexes. These corresponds roughly to nonterminals
in a context free grammar. We assume an alphabet $\Sigma$ and $x,y$
ranges over characters in the alphabet.

We're using the notion of an indexed fixed point. It's not much
different from taking the fixed point of a tuple of elements, we only
add the ability to index into the tuple with something other than
integers.

The semantics of our compositional context free grammars is a set of
strings. This is in contrast to the standard semantics of context free
grammars which are given a semantics based on derivation trees. Our
semantics is more coarse grained as it doesn't take into account that
there may be several derivations of the same string and therefore
doesn't have the notion of ambiguous grammars.

$\begin{array}{lcl}
|[ x               |]_\sigma & = & \{ x \}\\
|[ G \cdot H       |]_\sigma & = & |[G|]_\sigma \circ |[H|]_\sigma \\
|[ G + H           |]_\sigma & = & |[G|]_\sigma \cup |[H|]_\sigma \\
|[ r \; A          |]_\sigma & = & \sigma(r)(A) \\
|[ (\mu r . G_B) A |]_\sigma & = & \mu T . |[ G_B |]_{\sigma[ r \mapsto T ]} \: A
\end{array}$

Here comes the partial derivative with respect to a character

$\begin{array}{lcl}
\partial_x (r A)        & = & r A \\
\partial_x x            & = & 1 \\
\partial_x (y\not= x)   & = & 0 \\
\partial_x 0            & = & 0 \\
\partial_x 1            & = & 0 \\
\partial_x (G \cdot H)  & = & \partial_x G \cdot H + \delta G \cdot \partial_x H \\
\partial_x (G + H)      & = & \partial_x G + \partial_x H \\
\partial_x (\mu r . \displaystyle\prod_{A \in N} G_A)  & = & \partial_x G_A
\end{array}$

$\begin{array}{lcl}
\delta_\varsigma x           & = & 0\\
\delta_\varsigma 0           & = & 1\\
\delta_\varsigma 1           & = & 0\\
\delta_\varsigma (G \cdot H) & = & \delta_\varsigma G \cdot \delta_\varsigma H\\
\delta_\varsigma (G + H)     & = & \delta_\varsigma G + \delta_\varsigma H\\
\delta_\varsigma (T A)       & = & \delta_\varsigma T (A)\\
\\
\delta_\varsigma r & = & \\
\delta_\varsigma (\mu r . \displaystyle\prod_{A \in N} G_A) & = &\\
\end{array}$

Partial derivative with respect to a non-terminal. These transitions
corresponds to when we need to push the current state on the stack so that
we know how to resume parsing when we are done parsing the non-terminal.

# Dot productions

# Further thoughts on the connection to LR parsing

It seems that the connection between the derivative of a context free
grammar and the LR(0) automaton is somewhat convoluted. The reason is
that it is natural only to derive with respect to a character in the
alphabet whereas in the LR(0) automaton we also have transitions for
non-terminals. Deriving with respect to non-terminals might be doable
but a little bit messy. That would give us one correspondence.

Another option is to change the standard LR(0) automaton to only have
transitions for terminals. Then it would correspond more closely to
the derivative of the context free grammar. The only crux is then how
to know when to reduce in the LR machine. Shifts are still indicated
by the state transitions but it is not clear how we can find out when
to reduce, and how. On the other hand, my new version of the context
free grammar doesn't have production in the usual sense so it doesn't
make sense to reduce in the same way as in ordinary LR
parsing. Hmmm. Need to think more.

The non-terminals in the LR(0) automaton implements recursion and how
to handle the stack.

# Acknowledgements

The author would like to thank Neil Jones for some very inspiring
discussions which lead to the insight presented here.

This note was prepared using John MacFarlane's wonderful tool pandoc.
