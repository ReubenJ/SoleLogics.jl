const BASE_PROPOSITIONAL_OPERATORS = BASE_OPERATORS
const BasePropositionalOperators = Union{typeof.(BASE_PROPOSITIONAL_OPERATORS)...}

# A propositional logic based on the base propositional operators
const BasePropositionalLogic = AbstractLogic{G,A} where {ALP,G<:AbstractGrammar{ALP,<:BasePropositionalOperators},A<:AbstractAlgebra}

"""
    propositionallogic(;
        alphabet = AlphabetOfAny{String}(),
        operators = [⊤, ⊥, ¬, ∧, ∨, →],
        grammar = CompleteFlatGrammar(AlphabetOfAny{String}(), [⊤, ⊥, ¬, ∧, ∨, →]),
        algebra = BooleanAlgebra(),
    )

Instantiate a [propositional logic](https://simple.wikipedia.org/wiki/Propositional_logic)
given a grammar and an algebra. Alternatively, an alphabet and a set of operators
can be specified instead of the grammar.

# Examples
```julia-repl
julia> (¬) isa operatorstype(propositionallogic())
true

julia> (¬) isa operatorstype(propositionallogic(; operators = [∨]))
false

julia> propositionallogic(; alphabet = ["p", "q"]);

julia> propositionallogic(; alphabet = ExplicitAlphabet([Proposition("p"), Proposition("q")]));

```

See also [`modallogic`](@ref), [`AbstractAlphabet`](@ref), [`AbstractAlgebra`](@ref).
"""
function propositionallogic(;
    alphabet::Union{Nothing,Vector,AbstractAlphabet} = nothing,
    operators::Union{Nothing,Vector{<:AbstractOperator}} = nothing,
    grammar::Union{Nothing,AbstractGrammar} = nothing,
    algebra::Union{Nothing,AbstractAlgebra} = nothing,
)
    _baselogic(
        alphabet = alphabet,
        operators = operators,
        grammar = grammar,
        algebra = algebra;
        default_operators = BASE_PROPOSITIONAL_OPERATORS,
        logictypename = "propositional logic",
    )
end

############################################################################################

"""
    abstract type AbstractAssignment{A,T<:TruthValue} <: AbstractInterpretation{A,T} end

A propositional assigment (or, simply, an *assigment*) is a propositional interpretation,
encoding a mapping from `Proposition`s of atom type `A`
to truth values of type `T`.

See also [`AbstractInterpretation`](@ref).
"""
abstract type AbstractAssignment{A,T<:TruthValue} <: AbstractInterpretation{A,T} end

"""
    Base.getindex(i::AbstractAssignment{AA,T}, p::Proposition, args...)::T where {AA,T<:TruthValue}

Return the truth value of a proposition, given an assignment.

See also [`AbstractInterpretation`](@ref).
"""
function Base.getindex(
    i::AbstractAssignment{AA,T},
    ::Proposition,
    args...
)::T where {AA,T<:TruthValue}
    return error("Please, provide method " *
                 "Base.getindex(::$(typeof(i)), " *
                 "::Proposition, " *
                 "args...::$(typeof(args))::$(truthtype(i)).")
end

"""
    Base.haskey(::Proposition{A}, i::AbstractAssignment{A})::Bool where {A}

Return whether an assigment has a truth value for a given proposition.

See also [`AbstractInterpretation`](@ref).
"""
function Base.haskey(i::AbstractAssignment{AA}, ::Proposition)::Bool where {AA}
    return error("Please, provide method " *
                 "Base.haskey(::$(typeof(i)), " *
                 "::Proposition)::Bool.")
end

# Helpers
function Base.getindex(
    i::AbstractAssignment{AA,T},
    a,
    args...
)::T where {AA,T<:TruthValue}
    # if !(a isa Proposition)
        Base.getindex(i, Proposition(a))
    # else
    #     return error("Please, provide method" *
    #                  " Base.getindex(::$(typeof(i))," *
    #                  " a," *
    #                  " args...::$(typeof(args))::$(truthtype(i)).")
    # end
end
function Base.haskey(i::AbstractAssignment, a)::Bool
    # if !(a isa Proposition)
        Base.haskey(i, Proposition(a))
    # else
    #     return error("Please, provide method" *
    #                  " Base.haskey(::$(typeof(i))," *
    #                  " a)::Bool.")
    # end
end


function inlinedisplay(i::AbstractAssignment)
    return error("Please, provide method inlinedisplay(::$(typeof(i)))::String.")
end

# # Implementation

# With propositional logic, the fallback method extracts the formula's syntax tree and checks it using the logic's
# algebra.

#     check(
#         a::AbstractAlgebra,
#         tree::SyntaxTree,
#         i::AbstractAssignment{A,T},
#         args...
#     )::T where {A,T<:TruthValue}
"""
    check(
        f::AbstractFormula,
        i::AbstractAssignment::{A,T},
        args...
    )::T where {A,T<:TruthValue}

Check a logical formula on an assigment, returning a truth value.
The (finite) [model checking](https://en.wikipedia.org/wiki/Model_checking) algorithm depends
on the given logic.

See also
[`TruthDict`](@ref),
[`SyntaxTree`](@ref), [`AbstractFormula`](@ref),
[`AbstractAlgebra`](@ref), [`AbstractInterpretation`](@ref).
"""
check(f::Formula, i::AbstractAssignment, args...) = check(algebra(f), tree(f), i, args...)

function check(
    a::AbstractAlgebra,
    tree::SyntaxTree,
    i::AbstractAssignment{A,T},
    args...
)::T where {A,T<:TruthValue}
    if token(tree) isa Proposition
        return Base.getindex(i, token(tree), args...)
    elseif token(tree) isa AbstractOperator
        ts = Tuple([check(a, childtree, i, args...) for childtree in children(tree)])
        return collatetruth(a, token(tree), ts)
    else
        return error("Unknown token type encountered when checking formula " *
                     "on interpretation of type $(typeof(i)): $(typeof(token(tree))).")
    end
end

# Helper: a proposition can be checked on an interpretation; a simple lookup is performed.
check(p::Proposition, i::AbstractAssignment{AA}, args...) where {AA} = Base.getindex(i, p, args...)

############################################################################################

"""
    struct TruthDict{
        A,
        T<:TruthValue,
        D<:AbstractDict{<:Proposition{<:A},T}
    } <: AbstractAssignment{A,T}
        truth::D
    end

A truth table instantiated as a dictionary,
explicitly assigning truth values to a *finite* set of propositions.
If prompted for the value of an unknown proposition, it throws an error.

# Examples
```julia-repl
julia> TruthDict(1:4)
TruthDict with values:
┌───────┬───────┬───────┬───────┐
│     4 │     2 │     3 │     1 │
│ Int64 │ Int64 │ Int64 │ Int64 │
├───────┼───────┼───────┼───────┤
│  true │  true │  true │  true │
└───────┴───────┴───────┴───────┘


julia> t1 = TruthDict(1:4, false); t1[5] = true; t1
TruthDict with values:
┌───────┬───────┬───────┬───────┬───────┐
│     5 │     4 │     2 │     3 │     1 │
│ Int64 │ Int64 │ Int64 │ Int64 │ Int64 │
├───────┼───────┼───────┼───────┼───────┤
│  true │ false │ false │ false │ false │
└───────┴───────┴───────┴───────┴───────┘


julia> t2 = TruthDict(["a" => true, "b" => false, "c" => true])
TruthDict with values:
┌────────┬────────┬────────┐
│      c │      b │      a │
│ String │ String │ String │
├────────┼────────┼────────┤
│   true │  false │   true │
└────────┴────────┴────────┘

julia> check(parsebaseformula("a ∨ b"), t2)
true

```

See also
[`DefaultedTruthDict`](@ref),
[`AbstractAssignment`](@ref), [`AbstractInterpretation`](@ref).
"""
struct TruthDict{
    A,
    T<:TruthValue,
    D<:AbstractDict{<:Proposition{<:A},T}
} <: AbstractAssignment{A,T}

    truth::D

    function TruthDict{A,T,D}(
        d::D,
    ) where {
        A,
        T<:TruthValue,
        D<:AbstractDict{<:Proposition{<:A},T},
    }
        return new{A,T,D}(d)
    end
    function TruthDict{A,T}(d::AbstractDict{<:Proposition,T}) where {A,T<:TruthValue}
        return TruthDict{A,T,typeof(d)}(d)
    end
    function TruthDict{A}(d::AbstractDict{<:Proposition,T}) where {A,T<:TruthValue}
        return TruthDict{A,T,typeof(d)}(d)
    end
    function TruthDict(d::AbstractDict{<:Proposition,T}) where {T<:TruthValue}
        # A = Union{atomtype.(keys(d))...}
        # P = Union{[Proposition{_A} for _A in atomtype.(keys(d))]...}
        # println(A)
        # println(d)
        A = typejoin(atomtype.(keys(d))...)
        d = Dict{Proposition{A},T}(d)
        return TruthDict{A,T,typeof(d)}(d)
    end
    function TruthDict(d::AbstractDict{A,T}) where {A,T<:TruthValue}
        return TruthDict(Dict{Proposition{A},T}([(Proposition{A}(a),v) for (a,v) in d]))
    end
    function TruthDict(v::AbstractVector, truth_value = true)
        if length(v) == 0
            return TruthDict()
        else
            return TruthDict(Dict([k => truth_value for k in v]))
        end
    end
    function TruthDict(v::AbstractVector{<:Union{Tuple,Pair}})
        if length(v) == 0
            return TruthDict()
        else
            return TruthDict(Dict(v))
        end
    end
    function TruthDict(p::Pair)
        return TruthDict([p])
    end
    function TruthDict(t::Tuple)
        return TruthDict(Pair(t...))
    end
    function TruthDict()
        d = Dict{Proposition{Any},TruthValue}([])
        return TruthDict{Any,TruthValue,typeof(d)}(d)
    end
end

Base.getindex(i::TruthDict{AA}, p::Proposition) where {AA} = Base.getindex(i.truth, p)
Base.haskey(i::TruthDict{AA}, p::Proposition) where {AA} = Base.haskey(i.truth, p)


function inlinedisplay(i::TruthDict)
    "TruthDict([$(join(["$(syntaxstring(p)) => $t" for (p,t) in i.truth], ", "))])"
end

# Utility function to represent pretty tables horizontally
function _hpretty_table(io::IO, keys, values)
    atomkeys = atom.(keys)
    header = (atomkeys, typeof.(atomkeys))
    data = hcat([x for x in values]...)
    pretty_table(io, data; header=header)
end

function Base.show(
    io::IO,
    i::TruthDict{A,T,D},
) where {A,T<:TruthValue,D<:AbstractDict{<:Proposition{<:A},T}}
    println(io, "TruthDict with values:")
    _hpretty_table(io, i.truth |> keys, i.truth |> values)
end

# Helpers
@forward TruthDict.truth (
    Base.length, Base.setindex!, Base.iterate,
    Base.IteratorSize, Base.IteratorEltype,
    Base.firstindex, Base.lastindex,
    Base.keys, Base.values,
)


############################################################################################

"""
    struct DefaultedTruthDict{
        A,
        T<:TruthValue,
        D<:AbstractDict{<:Proposition{<:A},T}
    } <: AbstractAssignment{A,T}
        truth::D
        default_truth::T
    end

A truth table instantiated as a dictionary, plus a default value.
This structure assigns truth values to a set of propositions and,
when prompted for the value of a proposition that is not in the dictionary,
it returns `default_truth`.

# Examples
```julia-repl
julia> t1 = DefaultedTruthDict(string.(1:4), false); t1["5"] = false; t1
DefaultedTruthDict with default truth `false` and values:
┌────────┬────────┬────────┬────────┬────────┐
│      4 │      1 │      5 │      2 │      3 │
│ String │ String │ String │ String │ String │
├────────┼────────┼────────┼────────┼────────┤
│   true │   true │  false │   true │   true │
└────────┴────────┴────────┴────────┴────────┘


julia> check(parsebaseformula("1 ∨ 2"), t1)
true

julia> check(parsebaseformula("1 ∧ 5"), t1)
false

```

See also
[`TruthDict`](@ref),
[`AbstractAssignment`](@ref), [`AbstractInterpretation`](@ref).
"""
struct DefaultedTruthDict{
    A,
    T<:TruthValue,
    D<:AbstractDict{<:Proposition{<:A},T}
} <: AbstractAssignment{A,T}

    truth::D

    default_truth::T

    function DefaultedTruthDict{A,T,D}(
        d::D,
        default_truth::T = false,
    ) where {
        A,
        T<:TruthValue,
        D<:AbstractDict{<:Proposition{<:A},T},
    }
        return new{A,T,D}(d, default_truth)
    end

    function DefaultedTruthDict(
        d::TruthDict{A,T,D},
        default_truth::T = false,
    ) where {
        A,
        T<:TruthValue,
        D<:AbstractDict{<:Proposition{<:A},T}
    }
        return DefaultedTruthDict{A,T,D}(d.truth, default_truth)
    end

    function DefaultedTruthDict(
        a::Union{
            AbstractDict{<:Proposition,T},
            AbstractDict{A,T},
            AbstractVector{<:Union{Tuple,Pair}},
            AbstractVector,
            Pair,
            Tuple,
        },
        default_truth::T = false,
    ) where {A,T<:TruthValue}
        if length(a) == 0
            return DefaultedTruthDict(default_truth)
        else
            return DefaultedTruthDict(TruthDict(a), default_truth)
        end
    end

    function DefaultedTruthDict(
        default_truth::T = false,
    ) where {T<:TruthValue}
        d = Dict{Proposition{Any},T}([])
        return DefaultedTruthDict{Any,T,typeof(d)}(d, default_truth)
    end
end

function Base.getindex(i::DefaultedTruthDict{AA}, p::Proposition) where {AA}
    return Base.haskey(i.truth, p) ? Base.getindex(i.truth, p) : i.default_truth
end
Base.haskey(i::DefaultedTruthDict{AA}, p::Proposition) where {AA} = true

function inlinedisplay(i::DefaultedTruthDict)
    "DefaultedTruthDict([$(join(["$(syntaxstring(p)) => $t" for (p,t) in i.truth], ", "))], $(i.default_truth))"
end

function Base.show(
    io::IO,
    i::DefaultedTruthDict{A,T,D},
) where {A,T<:TruthValue,D<:AbstractDict{<:Proposition{<:A},T}}
    println(io, "DefaultedTruthDict with default truth `$(i.default_truth)` and values:")
    _hpretty_table(io, i.truth |> keys, i.truth |> values)
end

# Helpers
@forward DefaultedTruthDict.truth (
    Base.setindex!, Base.iterate,
    Base.firstindex, Base.lastindex,
    Base.keys,
    Base.values,
)

############################################################################################

# Helpers:
#  we let any AbstractDict and AbstractVector be used as an interpretation when model checking.

check(f::Formula, i::Union{AbstractDict,AbstractVector}, args...) = check(algebra(f), tree(f), i, args...)
function check(
    a::AbstractAlgebra,
    tree::SyntaxTree,
    i::Union{AbstractDict,AbstractVector},
    args...
)
    check(a, tree, convert(AbstractInterpretation, i), args...)
end

# A dictionary is interpreted as the map from propositions to truth values
convert(::Type{AbstractInterpretation}, i::AbstractDict) = TruthDict(i)
# Base.getindex(i::AbstractDict, p::Proposition) = i[atom(p)]
Base.haskey(p::Proposition, i::AbstractDict) = (atom(p) in keys(i))
check(p::Proposition, i::AbstractDict) = Base.getindex(i, p)

# A vector is interpreted as the set of true propositions
convert(::Type{AbstractInterpretation}, i::AbstractVector) = DefaultedTruthDict(i, false)
# Base.getindex(i::AbstractVector, p::Proposition) = (atom(p) in i)
# Base.in(p::Proposition, i::AbstractVector) = true
check(p::Proposition, i::AbstractVector) = (p in i)

"""
    eagercheck(phi::SoleLogics.AbstractSyntaxStructure)

Return a generator that yields applications of `check` algorithm over `phi`, considering
every possible formula interpretation. Each yielded value is a pair `(i,c)` where `i` is an
interpretation and c corresponds to `check(phi, i)`.

# Examples
```julia
julia> for (interpretation, checkans) in SoleLogics.eagercheck(parseformula("¬(p ∧ q)"))
        println(interpretation)
        println("Checking result using the above interpretation: \$checkans\n")
    end
TruthDict with values:
┌────────┬────────┐
│      q │      p │
│ String │ String │
├────────┼────────┤
│   true │   true │
└────────┴────────┘

Checking result using the above interpretation: false

TruthDict with values:
┌────────┬────────┐
│      q │      p │
│ String │ String │
├────────┼────────┤
│   true │  false │
└────────┴────────┘

Checking result using the above interpretation: true
...
```

See also [`AbstractAssignment`](@ref), [`check`](@ref).
"""
function eagercheck(phi::SoleLogics.AbstractSyntaxStructure)
    props = propositions(phi)

    return (
        (
            TruthDict([prop => truth for (prop, truth) in zip(props, interpretation)]),
            check(
                phi,
                TruthDict([prop => truth for (prop, truth) in zip(props, interpretation)])
            )
        )
        for interpretation in Iterators.product([[true, false] for _ in 1:length(props)]...)
    )
end

"""
    feedtruth!(td::TruthDict, entry::T)

Push a new interpretation `entry` in a `TruthDict`.

!!! warning
    `entry`, whose type represent a `TruthValue`, must be an `AbstractVector` subtype.

# Examples
```julia
julia> p, q = Proposition.(["p", "q"])

julia> td = TruthDict([p => [true], q => [true]])
TruthDict with values:
┌────────┬────────┐
│      q │      p │
│ String │ String │
├────────┼────────┤
│   true │   true │
└────────┴────────┘

julia> SoleLogics.feedtruth!(td, [true, false])
┌────────┬────────┐
│      q │      p │
│ String │ String │
├────────┼────────┤
│   true │   true │
│   true │  false │
└────────┴────────┘
```

See also [`TruthDict`](@ref), [`TruthValue`](@ref).
"""
function feedtruth!(td::TruthDict{A,T,D}, entry::T) where {A,T<:AbstractVector,D}
    td = TruthDict(
        Dict(
            [k => vcat(v, e) for (k,v,e) in zip(td.truth|>keys, td.truth|>values, entry)]
        )
    )
end

"""
    generate_truthtable()

Given a SyntaxTree, retrun a truth table where each possible interpretation is considered.
"""
function generate_truthtable()
    # @Mauro TODO
end
