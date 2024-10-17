import Base: show
using DataStructures: OrderedDict
using Graphs
using ThreadSafeDicts

"""
    abstract type AbstractWorld end

Abstract type for the nodes of an annotated accessibility graph (Kripke structure).
This is used, for example, in modal logic, where the truth of
formulas is relativized to *worlds*, that is, nodes of a graph.

# Implementing

When implementing a new world type, the logical semantics
should be defined via `accessibles` methods; refer to the help for `accessibles`.

See also [`AbstractKripkeStructure`](@ref), [`AbstractFrame`](@ref).
"""
abstract type AbstractWorld end

# Base.show(io::IO, w::AbstractWorld) = print(io, inlinedisplay(w))

############################################################################################

"""
    struct World{T} <: AbstractWorld
        name::T
    end

A world that is solely identified by its `name`.
This can be useful when instantiating the underlying graph of a modal frame
in an explicit way.

See also [`OneWorld`](@ref), [`AbstractWorld`](@ref).
"""
struct World{T} <: AbstractWorld
    name::T
end

name(w::World) = w.name

inlinedisplay(w::World) = string(name(w))

include("algebras/worlds.jl")

"""
    abstract type AbstractFrame{W<:AbstractWorld} end

Abstract type for an accessibility graph (Kripke frame), that gives the topology to
[Kripke structures](https://en.wikipedia.org/wiki/Kripke_structure_(model_checking)).
A frame can be queried for its set of vertices (also called *worlds*,
see [`allworlds`](@ref)), and it can be browsed via its accessibility
relation(s) (see [`accessibles`](@ref)). Refer to [`FullDimensionalFrame`](@ref) as an
example.

See also [`truthtype`](@ref), ,
[`allworlds`](@ref), [`nworlds`](@ref),
[`AbstractKripkeStructure`](@ref),
[`AbstractWorld`](@ref).
"""
abstract type AbstractFrame{W<:AbstractWorld} end

"""
    worldtype(fr::AbstractFrame)
    worldtype(i::AbstractKripkeStructure)

Return the world type of the Kripke frame/structure.

See also [`AbstractFrame`](@ref).
"""
worldtype(::Type{<:AbstractFrame{W}}) where {W<:AbstractWorld} = W
worldtype(fr::AbstractFrame) = worldtype(typeof(fr))

"""
    allworlds(fr::AbstractFrame{W})::AbstractVector{<:W} where {W<:AbstractWorld}

Return all worlds within the frame.

See also [`nworlds`](@ref), [`AbstractFrame`](@ref).
"""
function allworlds(fr::AbstractFrame{W})::AbstractVector{<:W} where {W<:AbstractWorld}
    return error("Please, provide method allworlds(frame::$(typeof(fr))).")
end

"""
    nworlds(fr::AbstractFrame)::Integer

Return the number of worlds within the frame.

See also [`nworlds`](@ref), [`AbstractFrame`](@ref).
"""
function nworlds(fr::AbstractFrame)::Integer
    return error("Please, provide method nworlds(frame::$(typeof(fr))).")
end

############################################################################################
##################################### Uni-modal logic ######################################
############################################################################################

"""
    abstract type AbstractUniModalFrame{W<:AbstractWorld} <: AbstractFrame{W} end

A frame of a modal logic based on a single (implicit) accessibility relation.

See also [`AbstractMultiModalFrame`](@ref), [`AbstractFrame`](@ref).
"""
abstract type AbstractUniModalFrame{W<:AbstractWorld} <: AbstractFrame{W} end

"""
    accessibles(fr::AbstractUniModalFrame{W}, w::W)::Worlds{W} where {W<:AbstractWorld}

Return the worlds in frame `fr` that are accessible from world `w`.

See also [`AbstractWorld`](@ref), [`AbstractUniModalFrame`](@ref).
"""
function accessibles(fr::AbstractUniModalFrame{W}, w::W)::Worlds{W} where {W<:AbstractWorld}
    return error("Please, provide method accessibles(fr::$(typeof(f)), w::$(typeof(w)))::Vector{$(W)}.")
end

############################################################################################

# """
# TODO Mauro
# Association "(w1,w2) => truth_value". Not recommended in sparse scenarios.
# """
# struct AdjMatUniModalFrame{W<:AbstractWorld,T<:Truth} <: AbstractUniModalFrame{W}
#     adjacents::NamedMatrix{T,Matrix{T},Tuple{OrderedDict{W,Int64},OrderedDict{W,Int64}}}
# end
# Upon construction, check that the type is not "OneWorld"
# end
# Add an example in the above docstring for accessibles
# accessibles(...) = ...

# TODO move truth value out of frame (frame is passive, perhaps it is relations that have a truth value)
"""
TODO
"""
struct ExplicitCrispUniModalFrame{
    W<:AbstractWorld,
    G<:Graphs.SimpleGraphs.AbstractSimpleGraph,
} <: AbstractUniModalFrame{W}
    worlds::Worlds{W}
    graph::G
end
accessibles(fr::ExplicitCrispUniModalFrame, w::AbstractWorld) = fr.worlds[neighbors(fr.graph, findfirst(==(w), fr.worlds))]
allworlds(fr::ExplicitCrispUniModalFrame) = fr.worlds
nworlds(fr::ExplicitCrispUniModalFrame) = length(fr.worlds)

function Base.show(io::IO, fr::ExplicitCrispUniModalFrame)
    println(io, "$(typeof(fr)) with")
    println(io, "- worlds = $(inlinedisplay.(fr.worlds))")
    maxl = maximum(length.(inlinedisplay.(fr.worlds)))
    println(io, "- accessibles = \n$(join(["\t$(rpad(inlinedisplay(w), maxl)) -> [$(join(inlinedisplay.(accessibles(fr, w)), ", "))]" for w in fr.worlds], "\n"))")
end

############################################################################################
#### Multi-modal logic #####################################################################
############################################################################################

"""
    abstract type AbstractRelation end

Abstract type for the relations of a multi-modal
annotated accessibility graph (Kripke structure).
Two noteworthy relations are `identityrel` and `globalrel`, which
access the current world and all worlds, respectively.

# Examples
```julia-repl
julia> fr = SoleLogics.FullDimensionalFrame((10,),);

julia> Interval(8,11) in (accessibles(fr, Interval(2,5), IA_L))
true
```

# Implementation

When implementing a new relation type `R`, please provide the methods:

    arity(::R)::Int = ...
    syntaxstring(::R; kwargs...)::String = ...

If the relation is symmetric, please specify its converse relation `cr` with:

    hasconverse(::R) = true
    converse(::R) = cr

If the relation is many-to-one or one-to-one, please flag it with:

    istoone(::R) = true

If the relation is reflexive or transitive, flag it with:

    isreflexive(::R) = true
    istransitive(::R) = true

Most importantly, the logical semantics for `R` should be defined via `accessibles` methods;
refer to the help for `accessibles`.

See also
[`issymmetric`](@ref),
[`isreflexive`](@ref),
[`istransitive`](@ref),
[`isgrounding`](@ref),
[`arity`](@ref),
[`syntaxstring`](@ref),
[`converse`](@ref),
[`hasconverse`](@ref),
[`istoone`](@ref),
[`identityrel`](@ref),
[`globalrel`](@ref),
[`accessibles`](@ref),
[`AbstractKripkeStructure`](@ref),
[`AbstractFrame`](@ref),
[`AbstractWorld`](@ref).
"""
abstract type AbstractRelation end

"""
    arity(::AbstractRelation)::Integer

Return the `arity` of the relation.

See also [`AbstractRelation`](@ref).
"""
arity(r::AbstractRelation)::Integer = error("Please, provide method arity(::$(typeof(r))).")

function syntaxstring(r::AbstractRelation; kwargs...)::String
    return error("Please, provide method syntaxstring(::$(typeof(r)); kwargs...).")
end

doc_conv_rel = """
    hasconverse(r::AbstractRelation)::Bool
    converse(r::AbstractRelation)::AbstractRelation

If the relation `hasconverse`,
return the converse relation (type) of a given relation (type).

See also [`issymmetric`](@ref), [`isreflexive`](@ref), [`istransitive`](@ref), [`AbstractRelation`](@ref).
"""


"""$(doc_conv_rel)"""
function hasconverse(r::AbstractRelation)::Bool
    return false
end

"""$(doc_conv_rel)"""
function converse(r::AbstractRelation)::AbstractRelation
    return error("Please, provide method converse(::$(typeof(r))).")
end


"""
    istoone(r::AbstractRelation) = false

Return whether it is known that a relation is istoone.

See also [`hasconverse`](@ref), [`converse`](@ref),
[`issymmetric`](@ref), [`istransitive`](@ref), [`isgrounding`](@ref), [`AbstractRelation`](@ref).
"""
istoone(r::AbstractRelation) = false

"""
    issymmetric(r::AbstractRelation) = hasconverse(r) ? converse(r) == r : false

Return whether it is known that a relation is symmetric.

See also [`hasconverse`](@ref), [`converse`](@ref),
[`isreflexive`](@ref), [`istransitive`](@ref), [`isgrounding`](@ref), [`AbstractRelation`](@ref).
"""
issymmetric(r::AbstractRelation) = hasconverse(r) ? converse(r) == r : false

"""
    isreflexive(::AbstractRelation)

Return whether it is known that a relation is reflexive.

See also
[`issymmetric`](@ref), [`istransitive`](@ref), [`isgrounding`](@ref), [`AbstractRelation`](@ref).
"""
isreflexive(::AbstractRelation) = false

"""
    istransitive(::AbstractRelation)

Return whether it is known that a relation is transitive.

See also
[`istoone`](@ref), [`issymmetric`](@ref), [`isgrounding`](@ref), [`AbstractRelation`](@ref).
"""
istransitive(::AbstractRelation) = false

"""
    isgrounding(::AbstractRelation)

Return whether it is known that a relation is grounding.
A relation `R` is grounding if ∀x,z,y R(x,y) ⇔ R(z,y).

See also
[`isreflexive`](@ref), [`issymmetric`](@ref), [`istransitive`](@ref), [`AbstractRelation`](@ref).
"""
isgrounding(::AbstractRelation) = false

############################################################################################
############################################################################################
############################################################################################

############################################################################################
# Singletons representing natural relations
############################################################################################

doc_identityrel = """
    struct IdentityRel <: AbstractRelation end;
    const identityrel   = IdentityRel();

Singleton type for the identity relation. This is a binary relation via which a world
accesses itself. The relation is also symmetric, reflexive and transitive.

# Examples
```julia-repl
julia> syntaxstring(SoleLogics.identityrel)
"="

julia> SoleLogics.converse(identityrel)
IdentityRel()
```

See also
[`globalrel`](@ref),
[`AbstractRelation`](@ref),
[`AbstractWorld`](@ref),
[`AbstractFrame`](@ref).
[`AbstractKripkeStructure`](@ref),
"""

"""$(doc_identityrel)"""
struct IdentityRel <: AbstractRelation end;
"""$(doc_identityrel)"""
const identityrel = IdentityRel();

arity(::IdentityRel) = 2

syntaxstring(::IdentityRel; kwargs...) = "="

hasconverse(::IdentityRel) = true
converse(::IdentityRel) = identityrel
istoone(::IdentityRel) = true
issymmetric(::IdentityRel) = true
isreflexive(::IdentityRel) = true
istransitive(::IdentityRel) = true

############################################################################################

doc_globalrel = """
    struct GlobalRel <: AbstractRelation end;
    const globalrel  = GlobalRel();

Singleton type for the global relation. This is a binary relation via which a world
accesses every other world within the frame.
The relation is also symmetric, reflexive and transitive.

# Examples
```julia-repl
julia> syntaxstring(SoleLogics.globalrel)
"G"

julia> SoleLogics.converse(globalrel)
GlobalRel()
```

See also
[`identityrel`](@ref),
[`AbstractRelation`](@ref),
[`AbstractWorld`](@ref),
[`AbstractFrame`](@ref).
[`AbstractKripkeStructure`](@ref),
"""

"""$(doc_globalrel)"""
struct GlobalRel <: AbstractRelation end;
"""$(doc_globalrel)"""
const globalrel = GlobalRel();

arity(::GlobalRel) = 2

syntaxstring(::GlobalRel; kwargs...) = "G"

hasconverse(::GlobalRel) = true
converse(::GlobalRel) = globalrel
issymmetric(::GlobalRel) = true
isreflexive(::GlobalRel) = true
istransitive(::GlobalRel) = true
isgrounding(::GlobalRel) = true

############################################################################################

"""
A binary relation via which a world *is accessed* by every other world within the frame.
That is, the binary relation that leads to a world.

See also
[`identityrel`](@ref),
[`AbstractRelation`](@ref),
[`AbstractWorld`](@ref),
[`AbstractFrame`](@ref).
[`AbstractKripkeStructure`](@ref),
"""
struct AtWorldRelation{W<:AbstractWorld} <: AbstractRelation
    w::W
end;

arity(::AtWorldRelation) = 2

syntaxstring(r::AtWorldRelation; kwargs...) = "@($(syntaxstring(r.w)))"

hasconverse(::AtWorldRelation) = false
issymmetric(::AtWorldRelation) = false
isreflexive(::AtWorldRelation) = false
istransitive(::AtWorldRelation) = true
isgrounding(::AtWorldRelation) = true

############################################################################################
############################################################################################
############################################################################################

"""
    abstract type AbstractMultiModalFrame{W<:AbstractWorld} <: AbstractFrame{W} end

A frame of a multi-modal logic, that is, a modal logic based on a set
of accessibility relations.

# Implementation

When implementing a new multi-modal frame type, the logical semantics for the frame
should be defined via `accessibles` methods; refer to the help for `accessibles`.

See also [`AbstractUniModalFrame`](@ref), [`AbstractFrame`](@ref).
"""
abstract type AbstractMultiModalFrame{W<:AbstractWorld} <: AbstractFrame{W} end

# Shortcut: when enumerating accessibles through global relation, delegate to `allworlds`
accessibles(fr::AbstractMultiModalFrame, ::GlobalRel) = allworlds(fr)
accessibles(fr::AbstractMultiModalFrame, ::AbstractWorld, r::GlobalRel) = accessibles(fr, r)
accessibles(fr::AbstractMultiModalFrame, w::AbstractWorld,    ::IdentityRel) = [w]
accessibles(fr::AbstractMultiModalFrame, w::AbstractWorld,    r::AtWorldRelation) = [r.w]


"""
    accessibles(
        fr::AbstractMultiModalFrame{W},
        w::W,
        r::AbstractRelation
    ) where {W<:AbstractWorld}

Return the worlds in frame `fr` that are accessible from world `w` via relation `r`.

# Examples
```julia-repl
julia> fr = SoleLogics.FullDimensionalFrame((10,),);

julia> typeof(accessibles(fr, Interval(2,5), IA_L))
Base.Generator{...}

julia> typeof(accessibles(fr, globalrel))
Base.Generator{...}

julia> @assert SoleLogics.nworlds(fr) == length(collect(accessibles(fr, globalrel)))

julia> typeof(accessibles(fr, Interval(2,5), identityrel))
Vector{Interval{Int64}}

julia> Interval(8,11) in collect(accessibles(fr, Interval(2,5), IA_L))
true
```

# Implementation

Since `accessibles` always returns an iterator of worlds of the same type `W`,
the current implementation of `accessibles` for multi-modal frames delegates the enumeration
to a lower level `_accessibles` function, which returns an iterator of parameter tuples
that are, then, fed to the world constructor the using IterTools generators, as in:

    function accessibles(
        fr::AbstractMultiModalFrame{W},
        w::W,
        r::AbstractRelation,
    ) where {W<:AbstractWorld}
        IterTools.imap(W, _accessibles(fr, w, r))
    end

As such, when defining new frames, worlds, and/or relations, one should provide new methods
for `_accessibles`. For example:

    _accessibles(fr::Full1DFrame, w::Interval{<:Integer}, ::_IA_A) = zip(Iterators.repeated(w.y), w.y+1:X(fr)+1)

This pattern is generally convenient; it can, however, be bypassed,
although this requires defining two additional methods in order to
resolve dispatch ambiguities.
When defining a new frame type `FR{W}`, one can resolve the ambiguities and define
a custom `accessibles` method by providing these three methods:

    # access worlds through relation `r`
    function accessibles(
        fr::FR{W},
        w::W,
        r::AbstractRelation,
    ) where {W<:AbstractWorld}
        ...
    end

    # access current world
    function accessibles(
        fr::FR{W},
        w::W,
        r::IdentityRel,
    ) where {W<:AbstractWorld}
        [w]
    end

    # access all worlds
    function accessibles(
        fr::FR{W},
        w::W,
        r::GlobalRel,
    ) where {W<:AbstractWorld}
        allworlds(fr)
    end

In general, it should be true that
`collect(accessibles(fr, w, r)) isa AbstractWorlds{W}`.

See also [`AbstractWorld`](@ref),
[`AbstractRelation`](@ref), [`AbstractMultiModalFrame`](@ref).
"""
function accessibles(
    fr::AbstractMultiModalFrame,
    w::W,
    r::AbstractRelation
) where {W<:AbstractWorld}
    IterTools.imap(W, _accessibles(fr, w, r))
end

############################################################################################

# TODO test
"""
    struct WrapperMultiModalFrame{
        W<:AbstractWorld,
        D<:AbstractDict{<:AbstractRelation,<:AbstractUniModalFrame{W}}
    } <: AbstractMultiModalFrame{W}
        frames::D
    end

A multi-modal frame that is the superposition of many uni-modal frames.
It uses a single `AbstractUniModalFrame` for
each of relations.

See also [`AbstractRelation`](@ref), [`AbstractUniModalFrame`](@ref).
"""
struct WrapperMultiModalFrame{
    W<:AbstractWorld,
    D<:AbstractDict{<:AbstractRelation,<:AbstractUniModalFrame{W}}
} <: AbstractMultiModalFrame{W}
    frames::D
end
function accessibles(
    fr::WrapperMultiModalFrame{W},
    w::W,
    r::AbstractRelation,
) where {W<:AbstractWorld}
    accessibles(frames[r], w, r)
end
function accessibles(
    fr::WrapperMultiModalFrame{W},
    w::W,
    r::IdentityRel,
) where {W<:AbstractWorld}
    [w]
end
function accessibles(
    fr::WrapperMultiModalFrame{W},
    w::W,
    r::GlobalRel,
) where {W<:AbstractWorld}
    accessibles(fr, r)
end

# """
# TODO
# """
# struct AdjMatCrispMultiModalFrame{
#     W<:AbstractWorld
# } <: AbstractMultiModalFrame{W}
#     worlds::Worlds{W}
#     adjacents::Vector{W,Dict{R,Vector{W,3}}}
# end
# accessibles(fr::AdjMatMultiModalFrame) = ...

# allworlds(fr::AdjMatMultiModalFrame) = fr.worlds
# nworlds(fr::AdjMatMultiModalFrame) = length(fr)



include("algebras/relations.jl")

include("algebras/frames.jl")

############################################################################################
############################################################################################
############################################################################################

"""
    abstract type AbstractKripkeStructure <: AbstractInterpretation end

Abstract type for representing
[Kripke structures](https://en.wikipedia.org/wiki/Kripke_structure_(model_checking))'s.
It comprehends a directed graph structure (Kripke frame), where nodes are referred to as
*worlds*, and the binary relation between them is referred to as the
*accessibility relation*. Additionally, each world is associated with a mapping from
`Atom`s to `Truth` values.

See also [`frame`](@ref), [`worldtype`](@ref),
[`accessibles`](@ref), [`AbstractInterpretation`](@ref).
"""
abstract type AbstractKripkeStructure <: AbstractInterpretation end

function interpret(
    φ::Truth,
    i::AbstractKripkeStructure,
    w::AbstractWorld,
)::Truth
    return φ
end

function interpret(
    φ::Atom,
    i::AbstractKripkeStructure,
    w::AbstractWorld,
)::SyntaxLeaf
    return error("Please, provide method interpret(::$(typeof(φ)), ::$(typeof(i)), ::$(typeof(w))).")
end

function interpret(
    φ::Formula,
    i::AbstractKripkeStructure,
    w::Union{Nothing,AbstractWorld},
)::Formula
    return error("Please, provide method interpret(::$(typeof(φ)), ::$(typeof(i)), ::$(typeof(w))).")
end

"""
    frame(i::AbstractKripkeStructure)::AbstractFrame

Return the frame of a Kripke structure.

See also [`AbstractFrame`](@ref), [`AbstractKripkeStructure`](@ref).
"""
function frame(i::AbstractKripkeStructure)::AbstractFrame
    return error("Please, provide method frame(i::$(typeof(i))).")
end

worldtype(i::AbstractKripkeStructure) = worldtype(frame(i))
accessibles(i::AbstractKripkeStructure, args...) = accessibles(frame(i), args...)
allworlds(i::AbstractKripkeStructure, args...) = allworlds(frame(i), args...)
nworlds(i::AbstractKripkeStructure) = nworlds(frame(i))

# TODO explain
struct AnyWorld end

# # General grounding
# function check(
#     φ::SyntaxTree,
#     i::AbstractKripkeStructure;
#     kwargs...
# )
#     if token(φ) isa Union{DiamondRelationalConnective,BoxRelationalConnective}
#         rel = SoleLogics.relation(SoleLogics.token(φ))
#         if rel == tocenterrel
#             checkw(first(children(φ)), i, centralworld(frame(i)); kwargs...)
#         elseif rel == globalrel
#             checkw(first(children(φ)), i, AnyWorld(); kwargs...)
#         elseif isgrounding(rel)
#             checkw(first(children(φ)), i, accessibles(frame(i), rel); kwargs...)
#         else
#             error("Unexpected formula: $φ! Perhaps ")
#         end
#     else
#         # checkw(φ, i, nothing; kwargs...)
#         error("Unexpected formula: $φ! Perhaps ")
#     end
# end

"""
    function check(
        φ::SyntaxTree,
        i::AbstractKripkeStructure,
        w::Union{Nothing,AnyWorld,<:AbstractWorld} = nothing;
        use_memo::Union{Nothing,AbstractDict{<:Formula,<:Vector{<:AbstractWorld}}} = nothing,
        perform_normalization::Bool = true,
        memo_max_height::Union{Nothing,Int} = nothing,
    )::Bool

Check a formula on a specific word in a [`KripkeStructure`](@ref).

# Examples
```julia-repl
julia> using Graphs, Random

julia> @atoms String p q
2-element Vector{Atom{String}}:
 Atom{String}("p")
 Atom{String}("q")

julia> fmodal = randformula(Random.MersenneTwister(14), 3, [p,q], SoleLogics.BASE_MODAL_CONNECTIVES)
¬□(p ∨ q)

# A special graph, called Kripke Frame, is created.
# Nodes are called worlds, and the edges are relations between worlds.
julia> worlds = SoleLogics.World.(1:5) # 5 worlds are created, numerated from 1 to 5

julia> edges = Edge.([(1,2), (1,3), (2,4), (3,4), (3,5)])

julia> kframe = SoleLogics.ExplicitCrispUniModalFrame(worlds, Graphs.SimpleDiGraph(edges))

# A valuation function establishes which fact are true on each world
julia> valuation = Dict([
    worlds[1] => TruthDict([p => true, q => false]),
    worlds[2] => TruthDict([p => true, q => true]),
    worlds[3] => TruthDict([p => true, q => false]),
    worlds[4] => TruthDict([p => false, q => false]),
    worlds[5] => TruthDict([p => false, q => true]),
 ])

# Kripke Frame and valuation function are merged in a Kripke Structure
julia> kstruct = KripkeStructure(kframe, valuation)

julia> [w => check(fmodal, kstruct, w) for w in worlds]
5-element Vector{Pair{SoleLogics.World{Int64}, Bool}}:
 SoleLogics.World{Int64}(1) => 0
 SoleLogics.World{Int64}(2) => 1
 SoleLogics.World{Int64}(3) => 1
 SoleLogics.World{Int64}(4) => 0
 SoleLogics.World{Int64}(5) => 0
```

See also [`SyntaxTree`](@ref), [`AbstractWorld`](@ref), [`KripkeStructure`](@ref).
"""
function check(
    φ::SyntaxTree,
    i::AbstractKripkeStructure,
    w::Union{Nothing,AnyWorld,<:AbstractWorld} = nothing;
    use_memo::Union{Nothing,AbstractDict{<:Formula,<:Vector{<:AbstractWorld}}} = nothing,
    perform_normalization::Bool = true,
    memo_max_height::Union{Nothing,Int} = nothing
)::Bool
    W = worldtype(i)

    if isnothing(w)
        if nworlds(frame(i)) == 1
            w = first(allworlds(frame(i)))
        end
    end
    @assert isgrounded(φ) || !(isnothing(w)) "Please, specify a world in order " *
        "to check non-grounded formula: $(syntaxstring(φ))."

    setformula(memo_structure::AbstractDict{<:Formula}, φ::Formula, val) = memo_structure[tree(φ)] = val
    readformula(memo_structure::AbstractDict{<:Formula}, φ::Formula) = memo_structure[tree(φ)]
    hasformula(memo_structure::AbstractDict{<:Formula}, φ::Formula) = haskey(memo_structure, tree(φ))

    if perform_normalization
        φ = normalize(φ; profile = :modelchecking, allow_atom_flipping = false)
    end

    memo_structure = begin
        if isnothing(use_memo)
            ThreadSafeDict{SyntaxTree,Worlds{W}}()
        else
            use_memo
        end
    end

    if !isnothing(memo_max_height)
        forget_list = Vector{SyntaxTree}()
    end

    fr = frame(i)

    # TODO try lazily
    (_f, _c) = filter, collect
    # (_f, _c) = Iterators.filter, identity

    if !hasformula(memo_structure, φ)
        for ψ in unique(subformulas(φ))
            if !isnothing(memo_max_height) && height(ψ) > memo_max_height
                push!(forget_list, ψ)
            end

            if !hasformula(memo_structure, ψ)
                tok = token(ψ)

                worldset = begin
                    if tok isa Connective
                        _c(collateworlds(fr, tok, map(f->readformula(memo_structure, f), children(ψ))))
                    elseif tok isa SyntaxLeaf
                        _f(_w->begin
                            istop(interpret(tok, i, _w))
                        end, _c(allworlds(fr)))
                    else
                        error("Unexpected token encountered in check: $(typeof(tok))")
                    end
                end
                setformula(memo_structure, ψ, Worlds{W}(worldset))
            end
            # @show syntaxstring(ψ), readformula(memo_structure, ψ)
        end
    end

    if !isnothing(memo_max_height)
        for ψ in forget_list
            delete!(memo_structure, ψ)
        end
    end

    ret = begin
        if isnothing(w) || w isa AnyWorld
            length(readformula(memo_structure, φ)) > 0
        else
            w in readformula(memo_structure, φ)
        end
    end

    return ret
end

############################################################################################

"""
    struct KripkeStructure{
        FR<:AbstractFrame,
        MAS<:AbstractDict
    } <: AbstractKripkeStructure
        frame::FR
        assignment::AS
    end

Type for representing
[Kripke structures](https://en.wikipedia.org/wiki/Kripke_structure_(model_checking)).
explicitly; it wraps a `frame`, and an abstract dictionary that assigns an interpretation to
each world.
"""
struct KripkeStructure{
    FR<:AbstractFrame,
    MAS<:AbstractDict
} <: AbstractKripkeStructure
    frame::FR
    assignment::MAS
end

frame(i::KripkeStructure) = i.frame

function interpret(a::Atom, i::KripkeStructure, w::W) where {W<:AbstractWorld}
    interpret(a, i.assignment[w])
end

function Base.show(io::IO, i::KripkeStructure)
    println(io, "$(typeof(i)) with")
    print(io, "- frame = ")
    Base.show(io, frame(i))
    maxl = maximum(length.(inlinedisplay.(allworlds(i))))
    println(io, "- valuations = \n$(join(["\t$(rpad(inlinedisplay(w), maxl)) -> $(inlinedisplay(i.assignment[w]))" for w in allworlds(i)], "\n"))")
end

############################################################################################
############################################################################################
############################################################################################

"""
    ismodal(::Type{<:Connective})::Bool = false
    ismodal(c::Connective)::Bool = ismodal(typeof(c))

Return whether it is known that an `Connective` is modal.

# Examples
```julia-repl
julia> ismodal(◊)
true

julia> ismodal(∧)
false
```
"""
ismodal(::Type{<:Connective})::Bool = false
ismodal(c::Connective)::Bool = ismodal(typeof(c))
ismodal(::Truth)::Bool = false

"""
    isbox(::Type{<:Connective})::Bool = false
    isbox(c::Connective)::Bool = isbox(typeof(c))

Return whether it is known that an `Connective` is a box (i.e., universal) connective.

# Examples
```julia-repl
julia> SoleLogics.isbox(◊)
false

julia> SoleLogics.isbox(∧)
false

julia> SoleLogics.isbox(□)
true
```
"""
isbox(::Any)::Bool = false
isbox(::Type{<:Connective})::Bool = false
isbox(c::Connective)::Bool = isbox(typeof(c))
isbox(::Truth)::Bool = false

isdiamond(::Any)::Bool = false
isdiamond(C::Type{<:Connective})::Bool = ismodal(C) && !isbox(C)
isdiamond(c::Connective)::Bool = isdiamond(typeof(c))
isdiamond(::Truth)::Bool = false

doc_DIAMOND = """
    const DIAMOND = NamedConnective{:◊}()
    const ◊ = DIAMOND
    ismodal(::typeof(◊)) = true
    arity(::typeof(◊)) = 1

Logical diamond connective, typically interpreted as the modal existential quantifier.
See [here](https://en.wikipedia.org/wiki/Modal_operator).

See also [`BOX`](@ref), [`NamedConnective`](@ref), [`Connective`](@ref).
"""
"""$(doc_DIAMOND)"""
const DIAMOND = NamedConnective{:◊}()
"""$(doc_DIAMOND)"""
const ◊ = DIAMOND
ismodal(::Type{typeof(◊)}) = true
isbox(::Type{typeof(◊)}) = false
arity(::typeof(◊)) = 1
precedence(::typeof(◊)) = precedence(NEGATION)
associativity(::typeof(◊)) = associativity(NEGATION)

doc_BOX = """
    const BOX = NamedConnective{:□}()
    const □ = BOX
    arity(::typeof(□)) = 1

Logical box connective, typically interpreted as the modal universal quantifier.
See [here](https://en.wikipedia.org/wiki/Modal_operator).

See also [`DIAMOND`](@ref), [`NamedConnective`](@ref), [`Connective`](@ref).
"""
"""$(doc_BOX)"""
const BOX = NamedConnective{:□}()
"""$(doc_BOX)"""
const □ = BOX
ismodal(::Type{typeof(□)}) = true
isbox(::Type{typeof(□)}) = true
arity(::typeof(□)) = 1
precedence(::typeof(□)) = precedence(NEGATION)
associativity(::typeof(□)) = associativity(NEGATION)

hasdual(::typeof(DIAMOND)) = true
dual(::typeof(DIAMOND)) = BOX
hasdual(::typeof(BOX)) = true
dual(::typeof(BOX))     = DIAMOND

############################################################################################

const BASE_MODAL_CONNECTIVES = [BASE_PROPOSITIONAL_CONNECTIVES..., ◊, □]
const BaseModalConnectives = Union{typeof.(BASE_MODAL_CONNECTIVES)...}

"""
    modallogic(;
        alphabet = AlphabetOfAny{String}(),
        operators = [⊤, ⊥, ¬, ∧, ∨, →, ◊, □],
        grammar = CompleteFlatGrammar(AlphabetOfAny{String}(), [⊤, ⊥, ¬, ∧, ∨, →, ◊, □]),
        algebra = BooleanAlgebra(),
    )

Instantiate a [modal logic](https://simple.wikipedia.org/wiki/Modal_logic)
given a grammar and an algebra. Alternatively, an alphabet and a set of operators
can be specified instead of the grammar.

# Examples
```julia-repl
julia> (¬) isa operatorstype(modallogic());
true

julia> (□) isa operatorstype(modallogic());
true

julia> (□) isa operatorstype(modallogic(; operators = [¬, ∨]))
┌ Warning: Instantiating modal logic (via `modallogic`) with solely propositional operators (SoleLogics.NamedConnective[¬, ∨]). Consider using propositionallogic instead.
└ @ SoleLogics ~/.julia/dev/SoleLogics/src/modal-logic.jl:642
false

julia> modallogic(; alphabet = ["p", "q"]);

julia> modallogic(; alphabet = ExplicitAlphabet([Atom("p"), Atom("q")]));

```

See also [`propositionallogic`](@ref), [`AbstractAlphabet`](@ref), [`AbstractAlgebra`](@ref).
"""
function modallogic(;
    alphabet::Union{Nothing,Vector,AbstractAlphabet} = nothing,
    operators::Union{Nothing,Vector{<:Connective}} = nothing,
    grammar::Union{Nothing,AbstractGrammar} = nothing,
    algebra::Union{Nothing,AbstractAlgebra} = nothing,
    default_operators = BASE_MODAL_CONNECTIVES
)
    if !isnothing(operators) && length(setdiff(operators, BASE_PROPOSITIONAL_CONNECTIVES)) == 0
        @warn "Instantiating modal logic (via `modallogic`) with solely " *
            "propositional operators ($(operators)). Consider using propositionallogic instead."
    end
    _baselogic(
        alphabet = alphabet,
        operators = operators,
        grammar = grammar,
        algebra = algebra;
        default_operators = default_operators,
        logictypename = "modal logic",
    )
end

# A modal logic based on the base modal connectives
const BaseModalLogic = AbstractLogic{G,A} where {ALP,G<:AbstractGrammar{ALP,<:BaseModalConnectives},A<:AbstractAlgebra}

############################################################################################

"""
    abstract type AbstractRelationalConnective{R<:AbstractRelation} <: Connective end

Abstract type for relational logical connectives. A relational connective
allows for semantic quantification across relational structures (e.g., Kripke structures).
It has arity equal to the arity of its underlying relation minus one.

See, for example [temporal modal logic](https://en.wikipedia.org/wiki/Temporal_logic).

See also [`DiamondRelationalConnective`](@ref), [`BoxRelationalConnective`](@ref),
[`AbstractKripkeStructure`](@ref), [`AbstractFrame`](@ref).
"""
abstract type AbstractRelationalConnective{R<:AbstractRelation} <: Connective end

doc_op_rel = """
    relationtype(::AbstractRelationalConnective{R}) where {R<:AbstractRelation} = R
    relation(op::AbstractRelationalConnective) = relationtype(op)()

Return the underlying relation (and relation type) of the relational connective.

See also [`AbstractFrame`](@ref).
"""

"""$(doc_op_rel)"""
relationtype(::AbstractRelationalConnective{R}) where {R<:AbstractRelation} = R
"""$(doc_op_rel)"""
relation(op::AbstractRelationalConnective) = relationtype(op)()

arity(op::AbstractRelationalConnective) = arity(relation(op))-1

function precedence(op::AbstractRelationalConnective)
    if isunary(op)
        precedence(NEGATION)
    else
        error("Please, provide method SoleLogics.precedence(::$(typeof(op))).")
    end
end

function associativity(op::AbstractRelationalConnective)
    if isunary(op)
        associativity(NEGATION)
    else
        error("Please, provide method SoleLogics.associativity(::$(typeof(op))).")
    end
end

const archetypmodal_relops_docstring = """
    struct DiamondRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end
    struct BoxRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end

Singleton types for relational connectives, typically interpreted as the modal existential
and universal quantifier, respectively.

Both connectives can be easily instantiated with relation instances,
such as `DiamondRelationalConnective(rel)`, which is a shortcut for
`DiamondRelationalConnective{typeof(rel)}()`.

# Examples
```julia-repl
julia> syntaxstring(DiamondRelationalConnective(IA_A))
"⟨A⟩"

julia> syntaxstring(BoxRelationalConnective(IA_A))
"[A]"

julia> @assert DiamondRelationalConnective(IA_A) == SoleLogics.dual(BoxRelationalConnective(IA_A))

```

See also
[`DiamondRelationalConnective`](@ref), [`BoxRelationalConnective`](@ref),
[`syntaxstring`](@ref), [`dual`](@ref),
[`AbstractKripkeStructure`](@ref), [`AbstractFrame`](@ref).
"""

"""$(archetypmodal_relops_docstring)"""
struct DiamondRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end
(DiamondRelationalConnective)(r::AbstractRelation) = DiamondRelationalConnective{typeof(r)}()

"""$(archetypmodal_relops_docstring)"""
struct BoxRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end
(BoxRelationalConnective)(r::AbstractRelation) = BoxRelationalConnective{typeof(r)}()

ismodal(::Type{<:DiamondRelationalConnective}) = true
ismodal(::Type{<:BoxRelationalConnective}) = true

isbox(::Type{<:DiamondRelationalConnective}) = false
isbox(::Type{<:BoxRelationalConnective}) = true

function syntaxstring(op::DiamondRelationalConnective; use_modal_notation = nothing, kwargs...)
    if isnothing(use_modal_notation)
        return "⟨$(syntaxstring(relation(op); kwargs...))⟩"
    elseif use_modal_notation == :superscript
        return "◊$(SoleBase.superscript(syntaxstring(relation(op); kwargs...)))"
    # elseif use_modal_notation == :subscript
    #     return "◊$(SoleBase.subscript(syntaxstring(relation(op); kwargs...)))"
    else
        return error("Unexpected value for parameter `use_modal_notation`. Allowed are: [nothing, :superscript]")
    end
end
function syntaxstring(op::BoxRelationalConnective; use_modal_notation = nothing, kwargs...)
    if isnothing(use_modal_notation)
        return "[$(syntaxstring(relation(op); kwargs...))]"
    elseif use_modal_notation == :superscript
        return "□$(SoleBase.superscript(syntaxstring(relation(op); kwargs...)))"
    # elseif use_modal_notation == :subscript
    #     return "□$(SoleBase.subscript(syntaxstring(relation(op); kwargs...)))"
    else
        return error("Unexpected value for parameter `use_modal_notation`. Allowed are: [nothing, :superscript]")
    end
end

hasdual(::DiamondRelationalConnective) = true
dual(op::DiamondRelationalConnective) = BoxRelationalConnective{relationtype(op)}()
hasdual(::BoxRelationalConnective) = true
dual(op::BoxRelationalConnective)     = DiamondRelationalConnective{relationtype(op)}()

############################################################################################

"""
    diamond() = DIAMOND
    diamond(r::AbstractRelation) = DiamondRelationalConnective(r)

Return either the diamond modal connective from unimodal logic (i.e., ◊), or a
a diamond relational connective from a multi-modal logic, wrapping the relation `r`.

See also [`DiamondRelationalConnective`](@ref), [`diamond`](@ref), [`DIAMOND`](@ref).
"""
function diamond() DIAMOND end
function diamond(r::AbstractRelation) DiamondRelationalConnective(r) end

"""
    box() = BOX
    box(r::AbstractRelation) = BoxRelationalConnective(r)

Return either the box modal connective from unimodal logic (i.e., □), or a
a box relational connective from a multi-modal logic, wrapping the relation `r`.

See also [`BoxRelationalConnective`](@ref), [`box`](@ref), [`BOX`](@ref).
"""
function box() BOX end
function box(r::AbstractRelation) BoxRelationalConnective(r) end

globaldiamond = diamond(globalrel)
globalbox = box(globalrel)

identitydiamond = diamond(identityrel)
identitybox = box(identityrel)

function diamondsandboxes()
    return [diamond(), box()]
end
function diamondsandboxes(r::AbstractRelation)
    return [diamond(r), box(r)]
end
function diamondsandboxes(rs::AbstractVector{<:AbstractRelation})
    return Iterators.flatten([diamondsandboxes(r) for r in rs]) |> collect
end

# Well known connectives
Base.show(io::IO, c::Union{
    typeof(globaldiamond),
    typeof(globalbox),
    typeof(identitydiamond),
    typeof(identitybox)
}) = print(io, "$(syntaxstring(c))")

const BASE_MULTIMODAL_CONNECTIVES = [BASE_PROPOSITIONAL_CONNECTIVES...,
    globaldiamond,
    globalbox,
    diamond(identityrel),
    box(identityrel),
]
const BaseMultiModalConnectives = Union{typeof.(BASE_MULTIMODAL_CONNECTIVES)...}

############################################################################################


"""
    collateworlds(
        fr::AbstractFrame{W},
        op::Operator,
        t::NTuple{N,WS},
    )::AbstractVector{<:W} where {N,W<:AbstractWorld,WS<:AbstractWorlds}

For a given crisp frame (`truthtype == Bool`),
return the set of worlds where a composed formula op(φ1, ..., φN) is true, given the `N`
sets of worlds where the each immediate sub-formula is true.

See also [`check`](@ref), [`iscrisp`](@ref),
[`Operator`](@ref), [`AbstractFrame`](@ref).
"""
function collateworlds(
    fr::AbstractFrame{W},
    op::Operator,
    t::NTuple{N,<:AbstractWorlds}
)::AbstractVector{<:W} where {N,W<:AbstractWorld}
    if arity(op) != length(t)
        return error("Cannot collate $(length(t)) truth values for " *
                     "operator $(typeof(op)) with arity $(arity(op))).")
    else
        return error("Please, provide method collateworlds(::$(typeof(fr)), " *
                     "::$(typeof(op)), ::NTuple{$(arity(op)), $(AbstractWorlds{W})}).")
    end
end

# I know, these exceed 92 characters. But they look nicer like this!! :D
function collateworlds(fr::AbstractFrame{W}, t::BooleanTruth, ::NTuple{0,<:AbstractWorlds}) where {W<:AbstractWorld}
    istop(t) ? allworlds(fr) : W[]
end

collateworlds(fr::AbstractFrame{W}, ::typeof(¬), (ws,)::NTuple{1,<:AbstractWorlds}) where {W<:AbstractWorld} = setdiff(allworlds(fr), ws)
collateworlds(::AbstractFrame{W}, ::typeof(∧), (ws1, ws2)::NTuple{2,<:AbstractWorlds}) where {W<:AbstractWorld} = intersect(ws1, ws2)
collateworlds(::AbstractFrame{W}, ::typeof(∨), (ws1, ws2)::NTuple{2,<:AbstractWorlds}) where {W<:AbstractWorld} = union(ws1, ws2)
collateworlds(fr::AbstractFrame{W}, ::typeof(→), (ws1, ws2)::NTuple{2,<:AbstractWorlds}) where {W<:AbstractWorld} = union(setdiff(allworlds(fr), ws1), ws2)

function collateworlds(
    fr::AbstractFrame{W},
    op::typeof(◊),
    (ws,)::NTuple{1,<:AbstractWorlds},
) where {W<:AbstractWorld}
    filter(w1->intersects(ws, accessibles(fr, w1)), collect(allworlds(fr)))
end

function collateworlds(
    fr::AbstractFrame{W},
    op::typeof(□),
    (ws,)::NTuple{1,<:AbstractWorlds},
) where {W<:AbstractWorld}
    filter(w1->issubset(accessibles(fr, w1), ws), collect(allworlds(fr)))
end

# TODO: use AbstractMultiModalFrame
function collateworlds(
    fr::AbstractFrame{W},
    op::DiamondRelationalConnective,
    (ws,)::NTuple{1,<:AbstractWorlds},
) where {W<:AbstractWorld}
    r = relation(op)
    if r == globalrel
        if length(ws) > 0
            collect(allworlds(fr))
        else
            W[]
        end
    else
        if hasconverse(r)
            # DIAMOND STRATEGY 1
            union(W[], [accessibles(fr, w, converse(r)) for w in ws]...)
        else
            # DIAMOND STRATEGY 2
            filter(w1->intersects(ws, accessibles(fr, w1, r)), collect(allworlds(fr)))
        end
    end
end

# TODO: use AbstractMultiModalFrame
function collateworlds(
    fr::AbstractFrame{W},
    op::BoxRelationalConnective,
    (ws,)::NTuple{1,<:AbstractWorlds},
) where {W<:AbstractWorld}
    r = relation(op)
    if r == globalrel
        if length(ws) == nworlds(fr) # Assuming no duplicates
            collect(allworlds(fr))
        else
            W[]
        end
    else
        if hasconverse(r)
            # BOX STRATEGY 1
            negws = setdiff(collect(allworlds(fr)), ws)
            negboxws = union(W[], [
                accessibles(fr, w, converse(r)) for w in negws]...)
            setdiff(collect(allworlds(fr)), negboxws)
            # BOX STRATEGY 3
            # filter(w1->all((w2)->w1 in accessibles(fr, w2, converse(r)), ws), collect(allworlds(fr)))
        else
            # BOX STRATEGY 2
            filter(w1->issubset(accessibles(fr, w1, r), ws), collect(allworlds(fr)))
        end
        # Note: this is wrong, as it does not include worlds for which φ is trivially true.
        # union(intersect(W[], [accessibles(fr, w, converse(r)) for w in ws]...))
    end
end
