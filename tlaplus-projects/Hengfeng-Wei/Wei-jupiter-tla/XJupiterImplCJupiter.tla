------------------------ MODULE XJupiterImplCJupiter ------------------------
(*
We show that XJupiter (XJupiterExtended) implements CJupiter.
*)
EXTENDS XJupiterExtended
-----------------------------------------------------------------------------
VARIABLES
    op2ss,  \* a function from an operation (represented by its Oid) 
            \* to the part of 2D state space produced while the operation is transformed
    c2ssX   \* c2ssX[c]: redundant (eXtra) 2D state space maintained for client c \in Client

varsImpl == <<varsEx, op2ss, c2ssX>>
-----------------------------------------------------------------------------
TypeOKImpl ==
    /\ TypeOKEx
    /\ \A oid \in DOMAIN op2ss: oid \in Oid /\ IsSS(op2ss[oid])
    /\ \A c \in Client: IsSS(c2ssX[c])
-----------------------------------------------------------------------------
InitImpl ==
    /\ InitEx
    /\ op2ss = <<>>
    /\ c2ssX = [c \in Client |-> EmptyGraph]

DoImpl(c) ==
    /\ DoEx(c)
    /\ UNCHANGED <<op2ss, c2ssX>>

RevImpl(c) ==
    /\ RevEx(c)
    /\ LET cop == Head(cincoming[c])
       IN  c2ssX' = [c2ssX EXCEPT ![c] = @ (+) op2ss[cop.oid]]
    /\ UNCHANGED op2ss

SRevImpl == 
    /\ SRevEx
    /\ LET cop == Head(sincoming)
             c == cop.oid.c
         xform == xForm(cop, s2ss[c], ds[Server])  \* TODO: performance!!!
            ss == xform.xss
       IN op2ss' = op2ss @@ (cop.oid :> [node |-> ss.node, edge |-> ss.edge])
    /\ UNCHANGED c2ssX
-----------------------------------------------------------------------------
NextImpl ==
    \/ \E c \in Client: DoImpl(c) \/ RevImpl(c)
    \/ SRevImpl
    
FairnessImpl ==
    /\ WF_varsImpl(SRevImpl \/ \E c \in Client: RevImpl(c)) 

SpecImpl == InitImpl /\ [][NextImpl]_varsImpl \* /\ FairnessImpl

CJ == INSTANCE CJupiter 
        WITH cincoming <- cincomingCJ, \* sincoming needs no substitution
             css <- [r \in Replica |-> 
                        IF r = Server 
                        THEN SetReduce((+), Range(s2ss), EmptyGraph)
                        ELSE c2ss[r] (+) c2ssX[r]]

THEOREM SpecImpl => CJ!Spec
=============================================================================
\* Modification History
\* Last modified Mon Dec 31 11:09:14 CST 2018 by hengxin
\* Created Fri Oct 26 15:00:19 CST 2018 by hengxin