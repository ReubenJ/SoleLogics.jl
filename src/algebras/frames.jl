
############################################################################################
# Natural relations
############################################################################################

# Note keep separate to avoid ambiguity
accessibles(fr::AbstractMultiModalFrame, ::AbstractWorld, r::GlobalRel) = accessibles(fr, r)
accessibles(fr::AbstractMultiModalFrame, ::AbstractWorldSet, r::GlobalRel) = accessibles(fr, r)
accessibles(fr::AbstractMultiModalFrame, w::AbstractWorld,    ::IdentityRel) = [w] # TODO try IterTools.imap(identity, [w])
accessibles(fr::AbstractMultiModalFrame, S::AbstractWorldSet, ::IdentityRel) = S # TODO try IterTools.imap(identity, S)

# Shortcut: when enumerating accessibles through global relation, delegate to `allworlds`
accessibles(fr::AbstractMultiModalFrame, ::GlobalRel) = allworlds(fr)

############################################################################################

# It is convenient to define methods for `accessibles` that take a world set instead of a
#  single world. Generally, this falls back to calling `_accessibles` on each world in
#  the set, and returning a constructor of wolds from the union; however, one may provide
#  improved implementations for special cases (e.g. ⟨L⟩ of a world set in interval algebra).
function accessibles(
    fr::AbstractMultiModalFrame{W},
    S::AbstractWorldSet,
    r::AbstractRelation,
) where {W<:AbstractWorld}
    IterTools.imap(W,
        IterTools.distinct(
            Iterators.flatten(
                (_accessibles(fr, w, r) for w in S)
            )
        )
    )
end

############################################################################################

# TODO remove
# Fix (not needed from Julia 1.7, see https://github.com/JuliaLang/julia/issues/34674 )
if length(methods(Base.keys, (Base.Generator,))) == 0
    Base.keys(g::Base.Generator) = g.iter
end

# TODO fix these...
abstract type InitCondition end
# function initialworld() end
function initialworldset() end

# """TODO"""
# struct AnchoredMultiModalFrame{
#     N,
#     W<:AbstractWorld,
#     T<:TruthValue,
#     FR<:AbstractMultiModalFrame{N,W,T},
# } <: AbstractMultiModalFrame{N,W,T}

#     frame::FR

#     initialworld::Union{Nothing,W}

#     function check_initialworld(initialworld, N, W)
#         @assert isnothing(initialworld) || initialworld isa W "Cannot instantiate" *
#             " AnchoredMultiModalFrame with initialworld of type $(typeof(initialworld))." *
#             " Type should be $(W) (dimensionality = $(N))."
#     end

#     function AnchoredMultiModalFrame{N,W,T}(
#         fr::AbstractMultiModalFrame{N,W,T},
#         initialworld = nothing,
#     ) where {N,W<:AbstractWorld,T<:TruthValue}
#         new{N,W,T}(fr, initialworld)
#     end

#     function AnchoredMultiModalFrame(
#         fr::AbstractMultiModalFrame{N,W,T},
#         initialworld = nothing,
#     ) where {N,W<:AbstractWorld,T<:TruthValue}
#         AnchoredMultiModalFrame{N,W,T}(fr, initialworld)
#     }
#     end
# end

# accessibles(fr::AnchoredMultiModalFrame, args...) = accessibles(fr.frame, args...)
# allworlds(fr::AnchoredMultiModalFrame, args...) = allworlds(fr.frame, args...)
# nworlds(fr::AnchoredMultiModalFrame) = nworlds(fr.frame)
# initialworld(fr::AnchoredMultiModalFrame) = fr.initialworld

############################################################################################

include("frames/full-dimensional-frame/main.jl")
