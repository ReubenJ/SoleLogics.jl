############################################################################################
# Allen's Interval Algebra 2D relations
############################################################################################

doc_rectangle_rel = """
    const IABase = Union{IntervalRelation,IdentityRel,GlobalRel}
    struct RectangleRelation{R1<:IABase,R2<:IABase} <: GeometricalRelation
        x :: R1
        y :: R2
    end

Relation from 2D interval algebra, obtained from the combination of orthogonal interval relations,
 and are thus also referred to as rectangle algebra.

# Examples
```julia-repl
julia> syntaxstring.(IA2DRelations[1:20:end])
9-element Vector{String}:
 "=,A"
 "A,L̅"
 "B,L"
 "E,B̅"
 "O,B"
 "A̅,E̅"
 "B̅,E"
 "E̅,D̅"
 "O̅,D"

julia> length(IA2DRelations)
168
```

See also [`Interval`](@ref), [`Interval2D`](@ref),
[`IntervalRelation`](@ref), [`[`GeometricalRelation`](@ref).
"""

"""$(doc_rectangle_rel)"""
const IABase = Union{IntervalRelation,IdentityRel,GlobalRel}
"""$(doc_rectangle_rel)"""
struct RectangleRelation{R1<:IABase,R2<:IABase} <: GeometricalRelation
    x :: R1
    y :: R2

    function RectangleRelation{R1,R2}(x::R1, y::R2) where {R1<:IABase,R2<:IABase}
        new{R1,R2}(x, y)
    end

    function RectangleRelation{R1,R2}() where {R1<:IABase,R2<:IABase}
        RectangleRelation{R1,R2}(R1(), R2())
    end

    function RectangleRelation(x::R1, y::R2) where {R1<:IABase,R2<:IABase}
        RectangleRelation{R1,R2}(x, y)
    end
end

arity(::RectangleRelation) = 2
hasconverse(::RectangleRelation) = true

function syntaxstring(r::RectangleRelation; kwargs...)
    "$(syntaxstring(r.x; kwargs...)),$(syntaxstring(r.y; kwargs...))"
end

# Properties
converse(r::RectangleRelation)      = RectangleRelation(converse(r.x),converse(r.y))
istransitive(r::RectangleRelation)  = istransitive(r.x)  && istransitive(r.y)
istopological(r::RectangleRelation) = istopological(r.x) && istopological(r.y)

############################################################################################

# (12+1+1)^2-1-1 = 194 Extended 2D Interval Algebra relations
                                                                                                     """See [`RectangleRelation`](@ref)""" const IA_IdU  = RectangleRelation(identityrel, globalrel);  """See [`RectangleRelation`](@ref)""" const IA_IdA  = RectangleRelation(identityrel , IA_A); """See [`RectangleRelation`](@ref)""" const IA_IdL  = RectangleRelation(identityrel , IA_L); """See [`RectangleRelation`](@ref)""" const IA_IdB  = RectangleRelation(identityrel , IA_B); """See [`RectangleRelation`](@ref)""" const IA_IdE  = RectangleRelation(identityrel , IA_E); """See [`RectangleRelation`](@ref)""" const IA_IdD  = RectangleRelation(identityrel , IA_D); """See [`RectangleRelation`](@ref)""" const IA_IdO  = RectangleRelation(identityrel , IA_O); """See [`RectangleRelation`](@ref)""" const IA_IdAi  = RectangleRelation(identityrel , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_IdLi  = RectangleRelation(identityrel , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_IdBi  = RectangleRelation(identityrel , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_IdEi  = RectangleRelation(identityrel , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_IdDi  = RectangleRelation(identityrel , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_IdOi  = RectangleRelation(identityrel , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_UId  = RectangleRelation(globalrel    , identityrel);                                                             """See [`RectangleRelation`](@ref)""" const IA_UA   = RectangleRelation(globalrel   , IA_A); """See [`RectangleRelation`](@ref)""" const IA_UL   = RectangleRelation(globalrel   , IA_L); """See [`RectangleRelation`](@ref)""" const IA_UB   = RectangleRelation(globalrel   , IA_B); """See [`RectangleRelation`](@ref)""" const IA_UE   = RectangleRelation(globalrel   , IA_E); """See [`RectangleRelation`](@ref)""" const IA_UD   = RectangleRelation(globalrel   , IA_D); """See [`RectangleRelation`](@ref)""" const IA_UO   = RectangleRelation(globalrel   , IA_O); """See [`RectangleRelation`](@ref)""" const IA_UAi   = RectangleRelation(globalrel   , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_ULi   = RectangleRelation(globalrel   , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_UBi   = RectangleRelation(globalrel   , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_UEi   = RectangleRelation(globalrel   , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_UDi   = RectangleRelation(globalrel   , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_UOi   = RectangleRelation(globalrel   , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_AId  = RectangleRelation(IA_A         , identityrel); """See [`RectangleRelation`](@ref)""" const IA_AU   = RectangleRelation(IA_A        , globalrel); """See [`RectangleRelation`](@ref)""" const IA_AA   = RectangleRelation(IA_A         , IA_A); """See [`RectangleRelation`](@ref)""" const IA_AL   = RectangleRelation(IA_A         , IA_L); """See [`RectangleRelation`](@ref)""" const IA_AB   = RectangleRelation(IA_A         , IA_B); """See [`RectangleRelation`](@ref)""" const IA_AE   = RectangleRelation(IA_A         , IA_E); """See [`RectangleRelation`](@ref)""" const IA_AD   = RectangleRelation(IA_A         , IA_D); """See [`RectangleRelation`](@ref)""" const IA_AO   = RectangleRelation(IA_A         , IA_O); """See [`RectangleRelation`](@ref)""" const IA_AAi   = RectangleRelation(IA_A         , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_ALi   = RectangleRelation(IA_A         , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_ABi   = RectangleRelation(IA_A         , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_AEi   = RectangleRelation(IA_A         , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_ADi   = RectangleRelation(IA_A         , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_AOi   = RectangleRelation(IA_A         , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_LId  = RectangleRelation(IA_L         , identityrel); """See [`RectangleRelation`](@ref)""" const IA_LU   = RectangleRelation(IA_L        , globalrel); """See [`RectangleRelation`](@ref)""" const IA_LA   = RectangleRelation(IA_L         , IA_A); """See [`RectangleRelation`](@ref)""" const IA_LL   = RectangleRelation(IA_L         , IA_L); """See [`RectangleRelation`](@ref)""" const IA_LB   = RectangleRelation(IA_L         , IA_B); """See [`RectangleRelation`](@ref)""" const IA_LE   = RectangleRelation(IA_L         , IA_E); """See [`RectangleRelation`](@ref)""" const IA_LD   = RectangleRelation(IA_L         , IA_D); """See [`RectangleRelation`](@ref)""" const IA_LO   = RectangleRelation(IA_L         , IA_O); """See [`RectangleRelation`](@ref)""" const IA_LAi   = RectangleRelation(IA_L         , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_LLi   = RectangleRelation(IA_L         , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_LBi   = RectangleRelation(IA_L         , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_LEi   = RectangleRelation(IA_L         , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_LDi   = RectangleRelation(IA_L         , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_LOi   = RectangleRelation(IA_L         , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_BId  = RectangleRelation(IA_B         , identityrel); """See [`RectangleRelation`](@ref)""" const IA_BU   = RectangleRelation(IA_B        , globalrel); """See [`RectangleRelation`](@ref)""" const IA_BA   = RectangleRelation(IA_B         , IA_A); """See [`RectangleRelation`](@ref)""" const IA_BL   = RectangleRelation(IA_B         , IA_L); """See [`RectangleRelation`](@ref)""" const IA_BB   = RectangleRelation(IA_B         , IA_B); """See [`RectangleRelation`](@ref)""" const IA_BE   = RectangleRelation(IA_B         , IA_E); """See [`RectangleRelation`](@ref)""" const IA_BD   = RectangleRelation(IA_B         , IA_D); """See [`RectangleRelation`](@ref)""" const IA_BO   = RectangleRelation(IA_B         , IA_O); """See [`RectangleRelation`](@ref)""" const IA_BAi   = RectangleRelation(IA_B         , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_BLi   = RectangleRelation(IA_B         , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_BBi   = RectangleRelation(IA_B         , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_BEi   = RectangleRelation(IA_B         , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_BDi   = RectangleRelation(IA_B         , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_BOi   = RectangleRelation(IA_B         , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_EId  = RectangleRelation(IA_E         , identityrel); """See [`RectangleRelation`](@ref)""" const IA_EU   = RectangleRelation(IA_E        , globalrel); """See [`RectangleRelation`](@ref)""" const IA_EA   = RectangleRelation(IA_E         , IA_A); """See [`RectangleRelation`](@ref)""" const IA_EL   = RectangleRelation(IA_E         , IA_L); """See [`RectangleRelation`](@ref)""" const IA_EB   = RectangleRelation(IA_E         , IA_B); """See [`RectangleRelation`](@ref)""" const IA_EE   = RectangleRelation(IA_E         , IA_E); """See [`RectangleRelation`](@ref)""" const IA_ED   = RectangleRelation(IA_E         , IA_D); """See [`RectangleRelation`](@ref)""" const IA_EO   = RectangleRelation(IA_E         , IA_O); """See [`RectangleRelation`](@ref)""" const IA_EAi   = RectangleRelation(IA_E         , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_ELi   = RectangleRelation(IA_E         , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_EBi   = RectangleRelation(IA_E         , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_EEi   = RectangleRelation(IA_E         , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_EDi   = RectangleRelation(IA_E         , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_EOi   = RectangleRelation(IA_E         , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_DId  = RectangleRelation(IA_D         , identityrel); """See [`RectangleRelation`](@ref)""" const IA_DU   = RectangleRelation(IA_D        , globalrel); """See [`RectangleRelation`](@ref)""" const IA_DA   = RectangleRelation(IA_D         , IA_A); """See [`RectangleRelation`](@ref)""" const IA_DL   = RectangleRelation(IA_D         , IA_L); """See [`RectangleRelation`](@ref)""" const IA_DB   = RectangleRelation(IA_D         , IA_B); """See [`RectangleRelation`](@ref)""" const IA_DE   = RectangleRelation(IA_D         , IA_E); """See [`RectangleRelation`](@ref)""" const IA_DD   = RectangleRelation(IA_D         , IA_D); """See [`RectangleRelation`](@ref)""" const IA_DO   = RectangleRelation(IA_D         , IA_O); """See [`RectangleRelation`](@ref)""" const IA_DAi   = RectangleRelation(IA_D         , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_DLi   = RectangleRelation(IA_D         , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_DBi   = RectangleRelation(IA_D         , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_DEi   = RectangleRelation(IA_D         , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_DDi   = RectangleRelation(IA_D         , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_DOi   = RectangleRelation(IA_D         , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_OId  = RectangleRelation(IA_O         , identityrel); """See [`RectangleRelation`](@ref)""" const IA_OU   = RectangleRelation(IA_O        , globalrel); """See [`RectangleRelation`](@ref)""" const IA_OA   = RectangleRelation(IA_O         , IA_A); """See [`RectangleRelation`](@ref)""" const IA_OL   = RectangleRelation(IA_O         , IA_L); """See [`RectangleRelation`](@ref)""" const IA_OB   = RectangleRelation(IA_O         , IA_B); """See [`RectangleRelation`](@ref)""" const IA_OE   = RectangleRelation(IA_O         , IA_E); """See [`RectangleRelation`](@ref)""" const IA_OD   = RectangleRelation(IA_O         , IA_D); """See [`RectangleRelation`](@ref)""" const IA_OO   = RectangleRelation(IA_O         , IA_O); """See [`RectangleRelation`](@ref)""" const IA_OAi   = RectangleRelation(IA_O         , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_OLi   = RectangleRelation(IA_O         , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_OBi   = RectangleRelation(IA_O         , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_OEi   = RectangleRelation(IA_O         , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_ODi   = RectangleRelation(IA_O         , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_OOi   = RectangleRelation(IA_O         , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_AiId = RectangleRelation(IA_Ai        , identityrel); """See [`RectangleRelation`](@ref)""" const IA_AiU  = RectangleRelation(IA_Ai       , globalrel); """See [`RectangleRelation`](@ref)""" const IA_AiA  = RectangleRelation(IA_Ai        , IA_A); """See [`RectangleRelation`](@ref)""" const IA_AiL  = RectangleRelation(IA_Ai        , IA_L); """See [`RectangleRelation`](@ref)""" const IA_AiB  = RectangleRelation(IA_Ai        , IA_B); """See [`RectangleRelation`](@ref)""" const IA_AiE  = RectangleRelation(IA_Ai        , IA_E); """See [`RectangleRelation`](@ref)""" const IA_AiD  = RectangleRelation(IA_Ai        , IA_D); """See [`RectangleRelation`](@ref)""" const IA_AiO  = RectangleRelation(IA_Ai        , IA_O); """See [`RectangleRelation`](@ref)""" const IA_AiAi  = RectangleRelation(IA_Ai        , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_AiLi  = RectangleRelation(IA_Ai        , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_AiBi  = RectangleRelation(IA_Ai        , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_AiEi  = RectangleRelation(IA_Ai        , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_AiDi  = RectangleRelation(IA_Ai        , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_AiOi  = RectangleRelation(IA_Ai        , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_LiId = RectangleRelation(IA_Li        , identityrel); """See [`RectangleRelation`](@ref)""" const IA_LiU  = RectangleRelation(IA_Li       , globalrel); """See [`RectangleRelation`](@ref)""" const IA_LiA  = RectangleRelation(IA_Li        , IA_A); """See [`RectangleRelation`](@ref)""" const IA_LiL  = RectangleRelation(IA_Li        , IA_L); """See [`RectangleRelation`](@ref)""" const IA_LiB  = RectangleRelation(IA_Li        , IA_B); """See [`RectangleRelation`](@ref)""" const IA_LiE  = RectangleRelation(IA_Li        , IA_E); """See [`RectangleRelation`](@ref)""" const IA_LiD  = RectangleRelation(IA_Li        , IA_D); """See [`RectangleRelation`](@ref)""" const IA_LiO  = RectangleRelation(IA_Li        , IA_O); """See [`RectangleRelation`](@ref)""" const IA_LiAi  = RectangleRelation(IA_Li        , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_LiLi  = RectangleRelation(IA_Li        , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_LiBi  = RectangleRelation(IA_Li        , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_LiEi  = RectangleRelation(IA_Li        , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_LiDi  = RectangleRelation(IA_Li        , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_LiOi  = RectangleRelation(IA_Li        , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_BiId = RectangleRelation(IA_Bi        , identityrel); """See [`RectangleRelation`](@ref)""" const IA_BiU  = RectangleRelation(IA_Bi       , globalrel); """See [`RectangleRelation`](@ref)""" const IA_BiA  = RectangleRelation(IA_Bi        , IA_A); """See [`RectangleRelation`](@ref)""" const IA_BiL  = RectangleRelation(IA_Bi        , IA_L); """See [`RectangleRelation`](@ref)""" const IA_BiB  = RectangleRelation(IA_Bi        , IA_B); """See [`RectangleRelation`](@ref)""" const IA_BiE  = RectangleRelation(IA_Bi        , IA_E); """See [`RectangleRelation`](@ref)""" const IA_BiD  = RectangleRelation(IA_Bi        , IA_D); """See [`RectangleRelation`](@ref)""" const IA_BiO  = RectangleRelation(IA_Bi        , IA_O); """See [`RectangleRelation`](@ref)""" const IA_BiAi  = RectangleRelation(IA_Bi        , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_BiLi  = RectangleRelation(IA_Bi        , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_BiBi  = RectangleRelation(IA_Bi        , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_BiEi  = RectangleRelation(IA_Bi        , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_BiDi  = RectangleRelation(IA_Bi        , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_BiOi  = RectangleRelation(IA_Bi        , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_EiId = RectangleRelation(IA_Ei        , identityrel); """See [`RectangleRelation`](@ref)""" const IA_EiU  = RectangleRelation(IA_Ei       , globalrel); """See [`RectangleRelation`](@ref)""" const IA_EiA  = RectangleRelation(IA_Ei        , IA_A); """See [`RectangleRelation`](@ref)""" const IA_EiL  = RectangleRelation(IA_Ei        , IA_L); """See [`RectangleRelation`](@ref)""" const IA_EiB  = RectangleRelation(IA_Ei        , IA_B); """See [`RectangleRelation`](@ref)""" const IA_EiE  = RectangleRelation(IA_Ei        , IA_E); """See [`RectangleRelation`](@ref)""" const IA_EiD  = RectangleRelation(IA_Ei        , IA_D); """See [`RectangleRelation`](@ref)""" const IA_EiO  = RectangleRelation(IA_Ei        , IA_O); """See [`RectangleRelation`](@ref)""" const IA_EiAi  = RectangleRelation(IA_Ei        , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_EiLi  = RectangleRelation(IA_Ei        , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_EiBi  = RectangleRelation(IA_Ei        , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_EiEi  = RectangleRelation(IA_Ei        , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_EiDi  = RectangleRelation(IA_Ei        , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_EiOi  = RectangleRelation(IA_Ei        , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_DiId = RectangleRelation(IA_Di        , identityrel); """See [`RectangleRelation`](@ref)""" const IA_DiU  = RectangleRelation(IA_Di       , globalrel); """See [`RectangleRelation`](@ref)""" const IA_DiA  = RectangleRelation(IA_Di        , IA_A); """See [`RectangleRelation`](@ref)""" const IA_DiL  = RectangleRelation(IA_Di        , IA_L); """See [`RectangleRelation`](@ref)""" const IA_DiB  = RectangleRelation(IA_Di        , IA_B); """See [`RectangleRelation`](@ref)""" const IA_DiE  = RectangleRelation(IA_Di        , IA_E); """See [`RectangleRelation`](@ref)""" const IA_DiD  = RectangleRelation(IA_Di        , IA_D); """See [`RectangleRelation`](@ref)""" const IA_DiO  = RectangleRelation(IA_Di        , IA_O); """See [`RectangleRelation`](@ref)""" const IA_DiAi  = RectangleRelation(IA_Di        , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_DiLi  = RectangleRelation(IA_Di        , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_DiBi  = RectangleRelation(IA_Di        , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_DiEi  = RectangleRelation(IA_Di        , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_DiDi  = RectangleRelation(IA_Di        , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_DiOi  = RectangleRelation(IA_Di        , IA_Oi);
"""See [`RectangleRelation`](@ref)""" const IA_OiId = RectangleRelation(IA_Oi        , identityrel); """See [`RectangleRelation`](@ref)""" const IA_OiU  = RectangleRelation(IA_Oi       , globalrel); """See [`RectangleRelation`](@ref)""" const IA_OiA  = RectangleRelation(IA_Oi        , IA_A); """See [`RectangleRelation`](@ref)""" const IA_OiL  = RectangleRelation(IA_Oi        , IA_L); """See [`RectangleRelation`](@ref)""" const IA_OiB  = RectangleRelation(IA_Oi        , IA_B); """See [`RectangleRelation`](@ref)""" const IA_OiE  = RectangleRelation(IA_Oi        , IA_E); """See [`RectangleRelation`](@ref)""" const IA_OiD  = RectangleRelation(IA_Oi        , IA_D); """See [`RectangleRelation`](@ref)""" const IA_OiO  = RectangleRelation(IA_Oi        , IA_O); """See [`RectangleRelation`](@ref)""" const IA_OiAi  = RectangleRelation(IA_Oi        , IA_Ai); """See [`RectangleRelation`](@ref)""" const IA_OiLi  = RectangleRelation(IA_Oi        , IA_Li); """See [`RectangleRelation`](@ref)""" const IA_OiBi  = RectangleRelation(IA_Oi        , IA_Bi); """See [`RectangleRelation`](@ref)""" const IA_OiEi  = RectangleRelation(IA_Oi        , IA_Ei); """See [`RectangleRelation`](@ref)""" const IA_OiDi  = RectangleRelation(IA_Oi        , IA_Di); """See [`RectangleRelation`](@ref)""" const IA_OiOi  = RectangleRelation(IA_Oi        , IA_Oi);

"""
(12+1)^2-1=168 2D Interval Algebra relations.

See [`RectangleRelation`](@ref)
"""
const IA2DRelations = [
        IA_IdA ,IA_IdL ,IA_IdB ,IA_IdE ,IA_IdD ,IA_IdO ,IA_IdAi ,IA_IdLi ,IA_IdBi ,IA_IdEi ,IA_IdDi ,IA_IdOi,
IA_AId ,IA_AA  ,IA_AL  ,IA_AB  ,IA_AE  ,IA_AD  ,IA_AO  ,IA_AAi  ,IA_ALi  ,IA_ABi  ,IA_AEi  ,IA_ADi  ,IA_AOi,
IA_LId ,IA_LA  ,IA_LL  ,IA_LB  ,IA_LE  ,IA_LD  ,IA_LO  ,IA_LAi  ,IA_LLi  ,IA_LBi  ,IA_LEi  ,IA_LDi  ,IA_LOi,
IA_BId ,IA_BA  ,IA_BL  ,IA_BB  ,IA_BE  ,IA_BD  ,IA_BO  ,IA_BAi  ,IA_BLi  ,IA_BBi  ,IA_BEi  ,IA_BDi  ,IA_BOi,
IA_EId ,IA_EA  ,IA_EL  ,IA_EB  ,IA_EE  ,IA_ED  ,IA_EO  ,IA_EAi  ,IA_ELi  ,IA_EBi  ,IA_EEi  ,IA_EDi  ,IA_EOi,
IA_DId ,IA_DA  ,IA_DL  ,IA_DB  ,IA_DE  ,IA_DD  ,IA_DO  ,IA_DAi  ,IA_DLi  ,IA_DBi  ,IA_DEi  ,IA_DDi  ,IA_DOi,
IA_OId ,IA_OA  ,IA_OL  ,IA_OB  ,IA_OE  ,IA_OD  ,IA_OO  ,IA_OAi  ,IA_OLi  ,IA_OBi  ,IA_OEi  ,IA_ODi  ,IA_OOi,
IA_AiId,IA_AiA ,IA_AiL ,IA_AiB ,IA_AiE ,IA_AiD ,IA_AiO ,IA_AiAi ,IA_AiLi ,IA_AiBi ,IA_AiEi ,IA_AiDi ,IA_AiOi,
IA_LiId,IA_LiA ,IA_LiL ,IA_LiB ,IA_LiE ,IA_LiD ,IA_LiO ,IA_LiAi ,IA_LiLi ,IA_LiBi ,IA_LiEi ,IA_LiDi ,IA_LiOi,
IA_BiId,IA_BiA ,IA_BiL ,IA_BiB ,IA_BiE ,IA_BiD ,IA_BiO ,IA_BiAi ,IA_BiLi ,IA_BiBi ,IA_BiEi ,IA_BiDi ,IA_BiOi,
IA_EiId,IA_EiA ,IA_EiL ,IA_EiB ,IA_EiE ,IA_EiD ,IA_EiO ,IA_EiAi ,IA_EiLi ,IA_EiBi ,IA_EiEi ,IA_EiDi ,IA_EiOi,
IA_DiId,IA_DiA ,IA_DiL ,IA_DiB ,IA_DiE ,IA_DiD ,IA_DiO ,IA_DiAi ,IA_DiLi ,IA_DiBi ,IA_DiEi ,IA_DiDi ,IA_DiOi,
IA_OiId,IA_OiA ,IA_OiL ,IA_OiB ,IA_OiE ,IA_OiD ,IA_OiO ,IA_OiAi ,IA_OiLi ,IA_OiBi ,IA_OiEi ,IA_OiDi ,IA_OiOi,
]
IA2DRelation = Union{typeof.(IA2DRelations)...}

"""
(1+1)*13=26 2D Interval Algebra relations with either globalrel and/or identity.

See [`RectangleRelation`](@ref)
"""
const IA2D_URelations = [
IA_UId ,IA_UA ,IA_UL ,IA_UB ,IA_UE ,IA_UD ,IA_UO ,IA_UAi ,IA_ULi ,IA_UBi ,IA_UEi ,IA_UDi ,IA_UOi,
IA_IdU ,IA_AU ,IA_LU ,IA_BU ,IA_EU ,IA_DU ,IA_OU ,IA_AiU ,IA_LiU ,IA_BiU ,IA_EiU ,IA_DiU ,IA_OiU
]
IA2D_URelation = Union{typeof.(IA2D_URelations)...}

"""
(12+1+1)^2-1=195 2D Interval Algebra relations extended with their combinations with the global relation.

See [`RectangleRelation`](@ref)
"""
const IA2DRelations_extended = [
globalrel,
IA2DRelations...,
IA2D_URelations...
]
IA2DRelation_extended = Union{typeof.(IA2DRelations_extended)...}

############################################################################################

# IA7 2D
                                                                                                                """See [`RectangleRelation`](@ref)""" const IA7_IdAorO          = RectangleRelation(identityrel   , IA_AorO); """See [`RectangleRelation`](@ref)""" const IA7_IdL           = RectangleRelation(identityrel    , IA_L); """See [`RectangleRelation`](@ref)""" const IA7_IdDorBorE         = RectangleRelation(identityrel    , IA_DorBorE); """See [`RectangleRelation`](@ref)""" const IA7_IdAiorOi          = RectangleRelation(identityrel   , IA_AiorOi); """See [`RectangleRelation`](@ref)""" const IA7_IdLi          = RectangleRelation(identityrel   , IA_Li); """See [`RectangleRelation`](@ref)""" const IA7_IdDiorBiorEi          = RectangleRelation(identityrel   , IA_DiorBiorEi);
"""See [`RectangleRelation`](@ref)""" const IA7_AorOId        = RectangleRelation(IA_AorO       , identityrel); """See [`RectangleRelation`](@ref)""" const IA7_AorOAorO        = RectangleRelation(IA_AorO       , IA_AorO); """See [`RectangleRelation`](@ref)""" const IA7_AorOL         = RectangleRelation(IA_AorO        , IA_L); """See [`RectangleRelation`](@ref)""" const IA7_AorODorBorE       = RectangleRelation(IA_AorO        , IA_DorBorE); """See [`RectangleRelation`](@ref)""" const IA7_AorOAi            = RectangleRelation(IA_AorO       , IA_AiorOi); """See [`RectangleRelation`](@ref)""" const IA7_AorOLi        = RectangleRelation(IA_AorO       , IA_Li); """See [`RectangleRelation`](@ref)""" const IA7_AorODiorBiorEi        = RectangleRelation(IA_AorO       , IA_DiorBiorEi);
"""See [`RectangleRelation`](@ref)""" const IA7_LId           = RectangleRelation(IA_L          , identityrel); """See [`RectangleRelation`](@ref)""" const IA7_LAorO           = RectangleRelation(IA_L          , IA_AorO); """See [`RectangleRelation`](@ref)""" const IA7_LL            = RectangleRelation(IA_L           , IA_L); """See [`RectangleRelation`](@ref)""" const IA7_LDorBorE          = RectangleRelation(IA_L           , IA_DorBorE); """See [`RectangleRelation`](@ref)""" const IA7_LAiorOi           = RectangleRelation(IA_L          , IA_AiorOi); """See [`RectangleRelation`](@ref)""" const IA7_LLi           = RectangleRelation(IA_L          , IA_Li); """See [`RectangleRelation`](@ref)""" const IA7_LDiorBiorEi           = RectangleRelation(IA_L          , IA_DiorBiorEi);
"""See [`RectangleRelation`](@ref)""" const IA7_DorBorEId     = RectangleRelation(IA_DorBorE    , identityrel); """See [`RectangleRelation`](@ref)""" const IA7_DorBorEAorO     = RectangleRelation(IA_DorBorE    , IA_AorO); """See [`RectangleRelation`](@ref)""" const IA7_DorBorEL      = RectangleRelation(IA_DorBorE     , IA_L); """See [`RectangleRelation`](@ref)""" const IA7_DorBorEDorBorE    = RectangleRelation(IA_DorBorE     , IA_DorBorE); """See [`RectangleRelation`](@ref)""" const IA7_DorBorEAiorOi     = RectangleRelation(IA_DorBorE    , IA_AiorOi); """See [`RectangleRelation`](@ref)""" const IA7_DorBorELi     = RectangleRelation(IA_DorBorE    , IA_Li); """See [`RectangleRelation`](@ref)""" const IA7_DorBorEDiorBiorEi     = RectangleRelation(IA_DorBorE    , IA_DiorBiorEi);
"""See [`RectangleRelation`](@ref)""" const IA7_AiorOiId      = RectangleRelation(IA_AiorOi     , identityrel); """See [`RectangleRelation`](@ref)""" const IA7_AiorOiAorO      = RectangleRelation(IA_AiorOi     , IA_AorO); """See [`RectangleRelation`](@ref)""" const IA7_AiorOiL       = RectangleRelation(IA_AiorOi      , IA_L); """See [`RectangleRelation`](@ref)""" const IA7_AiorOiDorBorE     = RectangleRelation(IA_AiorOi      , IA_DorBorE); """See [`RectangleRelation`](@ref)""" const IA7_AiorOiAiorOi      = RectangleRelation(IA_AiorOi     , IA_AiorOi); """See [`RectangleRelation`](@ref)""" const IA7_AiorOiLi      = RectangleRelation(IA_AiorOi     , IA_Li); """See [`RectangleRelation`](@ref)""" const IA7_AiorOiDiorBiorEi      = RectangleRelation(IA_AiorOi     , IA_DiorBiorEi);
"""See [`RectangleRelation`](@ref)""" const IA7_LiId          = RectangleRelation(IA_Li         , identityrel); """See [`RectangleRelation`](@ref)""" const IA7_LiAorO          = RectangleRelation(IA_Li         , IA_AorO); """See [`RectangleRelation`](@ref)""" const IA7_LiL           = RectangleRelation(IA_Li          , IA_L); """See [`RectangleRelation`](@ref)""" const IA7_LiDorBorE         = RectangleRelation(IA_Li          , IA_DorBorE); """See [`RectangleRelation`](@ref)""" const IA7_LiAiorOi          = RectangleRelation(IA_Li         , IA_AiorOi); """See [`RectangleRelation`](@ref)""" const IA7_LiLi          = RectangleRelation(IA_Li         , IA_Li); """See [`RectangleRelation`](@ref)""" const IA7_LiDiorBiorEi          = RectangleRelation(IA_Li         , IA_DiorBiorEi);
"""See [`RectangleRelation`](@ref)""" const IA7_DiorBiorEiId  = RectangleRelation(IA_DiorBiorEi , identityrel); """See [`RectangleRelation`](@ref)""" const IA7_DiorBiorEiAorO  = RectangleRelation(IA_DiorBiorEi , IA_AorO); """See [`RectangleRelation`](@ref)""" const IA7_DiorBiorEiL   = RectangleRelation(IA_DiorBiorEi  , IA_L); """See [`RectangleRelation`](@ref)""" const IA7_DiorBiorEiDorBorE = RectangleRelation(IA_DiorBiorEi  , IA_DorBorE); """See [`RectangleRelation`](@ref)""" const IA7_DiorBiorEiAiorOi  = RectangleRelation(IA_DiorBiorEi , IA_AiorOi); """See [`RectangleRelation`](@ref)""" const IA7_DiorBiorEiLi  = RectangleRelation(IA_DiorBiorEi , IA_Li); """See [`RectangleRelation`](@ref)""" const IA7_DiorBiorEiDiorBiorEi  = RectangleRelation(IA_DiorBiorEi , IA_DiorBiorEi);

"""See [`RectangleRelation`](@ref)"""
const IA72DRelations = [IA7_IdAorO, IA7_IdL, IA7_IdDorBorE, IA7_IdAiorOi, IA7_IdLi, IA7_IdDiorBiorEi, IA7_AorOId, IA7_AorOAorO, IA7_AorOL, IA7_AorODorBorE, IA7_AorOAi, IA7_AorOLi, IA7_AorODiorBiorEi, IA7_LId, IA7_LAorO, IA7_LL, IA7_LDorBorE, IA7_LAiorOi, IA7_LLi, IA7_LDiorBiorEi, IA7_DorBorEId, IA7_DorBorEAorO, IA7_DorBorEL, IA7_DorBorEDorBorE, IA7_DorBorEAiorOi, IA7_DorBorELi, IA7_DorBorEDiorBiorEi, IA7_AiorOiId, IA7_AiorOiAorO, IA7_AiorOiL, IA7_AiorOiDorBorE, IA7_AiorOiAiorOi, IA7_AiorOiLi, IA7_AiorOiDiorBiorEi, IA7_LiId, IA7_LiAorO, IA7_LiL, IA7_LiDorBorE, IA7_LiAiorOi, IA7_LiLi, IA7_LiDiorBiorEi, IA7_DiorBiorEiId, IA7_DiorBiorEiAorO, IA7_DiorBiorEiL, IA7_DiorBiorEiDorBorE, IA7_DiorBiorEiAiorOi, IA7_DiorBiorEiLi, IA7_DiorBiorEiDiorBiorEi]

IA72DRelation = Union{typeof.(IA72DRelations)...}

############################################################################################

# IA3 2D
                                                                                                                """See [`RectangleRelation`](@ref)""" const IA3_IdI             = RectangleRelation(identityrel   , IA_I); """See [`RectangleRelation`](@ref)""" const IA3_IdL           = RectangleRelation(identityrel    , IA_L); """See [`RectangleRelation`](@ref)""" const IA3_IdLi          = RectangleRelation(identityrel   , IA_Li);
"""See [`RectangleRelation`](@ref)""" const IA3_IId           = RectangleRelation(IA_I          , identityrel); """See [`RectangleRelation`](@ref)""" const IA3_II              = RectangleRelation(IA_I          , IA_I); """See [`RectangleRelation`](@ref)""" const IA3_IL            = RectangleRelation(IA_I           , IA_L); """See [`RectangleRelation`](@ref)""" const IA3_ILi           = RectangleRelation(IA_I          , IA_Li);
"""See [`RectangleRelation`](@ref)""" const IA3_LId           = RectangleRelation(IA_L          , identityrel); """See [`RectangleRelation`](@ref)""" const IA3_LI              = RectangleRelation(IA_L          , IA_I); """See [`RectangleRelation`](@ref)""" const IA3_LL            = RectangleRelation(IA_L           , IA_L); """See [`RectangleRelation`](@ref)""" const IA3_LLi           = RectangleRelation(IA_L          , IA_Li);
"""See [`RectangleRelation`](@ref)""" const IA3_LiId          = RectangleRelation(IA_Li         , identityrel); """See [`RectangleRelation`](@ref)""" const IA3_LiI             = RectangleRelation(IA_Li         , IA_I); """See [`RectangleRelation`](@ref)""" const IA3_LiL           = RectangleRelation(IA_Li          , IA_L); """See [`RectangleRelation`](@ref)""" const IA3_LiLi          = RectangleRelation(IA_Li         , IA_Li);

"""See [`RectangleRelation`](@ref)"""
const IA32DRelations = [IA3_IdI, IA3_IdL, IA3_IdLi, IA3_IId, IA3_II, IA3_IL, IA3_ILi, IA3_LId, IA3_LI, IA3_LL, IA3_LLi, IA3_LiId, IA3_LiI, IA3_LiL, IA3_LiLi]

IA32DRelation = Union{typeof.(IA32DRelations)...}
