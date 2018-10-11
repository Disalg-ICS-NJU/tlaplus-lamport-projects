---- MODULE MC ----
EXTENDS XJupiter, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
c1, c2, c3
----

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
a, b
----

\* MV CONSTANT definitions Client
const_153915699695257000 == 
{c1, c2, c3}
----

\* MV CONSTANT definitions Char
const_153915699695258000 == 
{a, b}
----

\* SYMMETRY definition
symm_153915699695259000 == 
Permutations(const_153915699695257000) \union Permutations(const_153915699695258000)
----

\* CONSTANT definitions @modelParameterConstants:2InitState
const_153915699695260000 == 
<<>>
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_153915699695262000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_153915699695263000 ==
TypeOK
----
=============================================================================
\* Modification History
\* Created Wed Oct 10 15:36:36 CST 2018 by hengxin
