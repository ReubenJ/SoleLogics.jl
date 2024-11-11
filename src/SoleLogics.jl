module SoleLogics

import Base: show
using DataStructures
using Dictionaries
using PrettyTables
using Random
using StatsBase
using Reexport
using Lazy

using SoleBase
using SoleBase: initrng

############################################################################################

export iscrisp, isfinite, isnullary, isunary, isbinary

export Syntactical, Connective,
    Formula, AbstractSyntaxStructure, SyntaxTree, SyntaxLeaf,
    Atom, Truth, SyntaxBranch

export Operator, SyntaxToken

export syntaxstring

export arity, valuetype, tokentype, tokenstype,
        atomstype, operatorstype, truthtype,
        associativity, precedence

# export value # TODO remove. The name is too generic, and it clashes, e.g., with JuMP.value.
export token, children, formulas
export tree

export tokens, ntokens, atoms, natoms, truths, ntruths, leaves, nleaves,
        connectives, nconnectives, operators, noperators, height
export composeformulas

export interpret, check

include("core.jl")

############################################################################################

export AlphabetOfAny, ExplicitAlphabet, UnionAlphabet

export alphabet, alphabets
export domain, top, bot, grammar, algebra, logic

include("logics.jl")

############################################################################################

export TOP, ⊤
export BOT, ⊥
export BooleanTruth
export istop, isbot

export NamedConnective, CONJUNCTION, NEGATION, DISJUNCTION, IMPLICATION
export ∧, ¬, ∨, →

export BooleanAlgebra

export BaseLogic

include("base-logic.jl")

############################################################################################

export propositionallogic

export TruthDict, DefaultedTruthDict
export truth_table

include("propositional-logic.jl")

############################################################################################

export accessibles
export ismodal, modallogic

export DIAMOND, BOX, ◊, □
export DiamondRelationalConnective, BoxRelationalConnective
export diamond, box
export globaldiamond, globalbox

export KripkeStructure
export truthtype, worldtype

export AbstractWorld

export AbstractWorlds, Worlds

export Interval, Interval2D, OneWorld


export AbstractRelation

export GlobalRel, IdentityRel
export globalrel, identityrel


include("modal-logic.jl")

############################################################################################

include("many-valued-logics/ManyValuedLogics.jl")

############################################################################################

export LeftmostLinearForm, LeftmostConjunctiveForm, LeftmostDisjunctiveForm, Literal

export subformulas, normalize

export CNF, DNF, cnf

include("syntax-utils.jl")

############################################################################################

include("interpretation-sets.jl")

############################################################################################

export parseformula

include("parse.jl")

############################################################################################

export randbaseformula, randformula
export randframe, randmodel

include("random.jl")

############################################################################################

export AnchoredFormula

include("anchored-formula.jl")

############################################################################################

export @atoms, @synexpr

include("ui.jl")

############################################################################################

include("experimentals.jl")

############################################################################################

include("deprecate.jl")

############################################################################################

include("utils.jl")

############################################################################################

end
