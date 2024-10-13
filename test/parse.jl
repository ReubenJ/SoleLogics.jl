import SoleLogics: arity

using SoleLogics: relation

# testing utilities ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function test_parsing_equivalence(f::SyntaxBranch)
    @test syntaxstring(f) == syntaxstring(parseformula(syntaxstring(f)))
    @test syntaxstring(f; function_notation = true) ==
        syntaxstring(
            parseformula(
                syntaxstring(f; function_notation = true);
                function_notation = true
            );
            function_notation = true
        )
end

# simple tests ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@test_throws ErrorException parseformula("")
@test_nowarn parseformula("p")
@test_nowarn parseformula("⊤")
@test parseformula("⊤") isa Truth
@test parseformula("⊥") isa Truth

@test parseformula("¬p∧q") == parseformula("¬(p)∧q")
@test parseformula("¬p∧q") != parseformula("¬(p∧q)")

@test_nowarn parseformula("¬p∧q∧(¬s∧¬z)", [NEGATION, CONJUNCTION])
@test_nowarn parseformula("¬p∧q∧(¬s∧¬z)", [NEGATION])
@test_nowarn parseformula("¬p∧q∧{¬s∧¬z}",
    opening_parenthesis="{", closing_parenthesis="}")
@test_nowarn parseformula("¬p∧q∧ A ¬s∧¬z    B",
    opening_parenthesis="A", closing_parenthesis="B")

@test_nowarn parseformula("¬p∧q→(¬s∧¬z)")

@test syntaxstring(parseformula("⟨G⟩p")) == "⟨G⟩p"
@test syntaxstring(parseformula("⟨G⟩(p)"); remove_redundant_parentheses = false) == "⟨G⟩(p)"

@test syntaxstring(parseformula("[G]p")) == "[G]p"
@test syntaxstring(parseformula("[G]p"); remove_redundant_parentheses = false) == "[G](p)"

@test_nowarn parseformula("⟨G⟩p")

@test syntaxstring(parseformula("(◊¬p) ∧ (¬q)")) == "◊¬p ∧ ¬q"
@test syntaxstring(parseformula("q → p → ¬q"), remove_redundant_parentheses=false) == "(q) → ((p) → (¬(q)))"
# function notation ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@test syntaxstring(parseformula("p∧q"); function_notation = true) == "∧(p, q)"
@test syntaxstring(parseformula("p→q"); function_notation = true) == "→(p, q)"

@test_broken filter(!isspace, syntaxstring(parseformula("¬p∧q∧(¬s∧¬z)");
function_notation = true)) == "∧(¬(p),∧(q,∧(¬(s),¬(z))))" # left-most derivation
# function_notation = true)) == "∧(∧(¬(p),q),∧(¬(s),¬(z)))" # right-most derivation

@test_nowarn parseformula("→(∧(¬p, q), ∧(¬s, ¬z))", function_notation=true)
@test_nowarn parseformula("→(∧(¬p; q); ∧(¬s; ¬z))",
    function_notation=true, arg_delim = ";")
@test_nowarn parseformula("→{∧{¬p; q}; ∧{¬s; ¬z}}", function_notation=true,
    opening_parenthesis = "{", closing_parenthesis = "}",
    arg_delim = ";")


@test filter(!isspace, syntaxstring(parseformula("¬p∧q→(¬s∧¬z)");
    function_notation = true)) == "→(∧(¬(p),q),∧(¬(s),¬(z)))"
@test filter(!isspace, syntaxstring(
    parseformula("¬p∧q→A¬s∧¬zB",
        opening_parenthesis = "A",
        closing_parenthesis = "B");
    function_notation = true)) == "→(∧(¬(p),q),∧(¬(s),¬(z)))"
@test_nowarn parseformula("¬p∧q→     (¬s∧¬z)")
@test parseformula("□p∧   q∧(□s∧◊z)", [BOX]) == parseformula("□p∧   q∧(□s∧◊z)")
@test syntaxstring(parseformula("◊ ◊ ◊ ◊ p∧q"); function_notation = true) == "∧(◊(◊(◊(◊(p)))), q)"
@test syntaxstring(parseformula("¬¬¬ □□□ ◊◊◊ p ∧ ¬¬¬ q"); function_notation = true) ==
    "∧(¬(¬(¬(□(□(□(◊(◊(◊(p))))))))), ¬(¬(¬(q))))"

@test token(parseformula("¬¬¬ □□□ ◊◊◊ p ∧ ¬¬¬ q")) == ∧
@test token(parseformula("¬¬¬ □□□ ◊◊◊ p → ¬¬¬ q")) == →

fxs = [
    "(¬(¬(⟨G⟩(q))) → (([G](p)) ∧ ([G](q))))", #¬((¬(⟨G⟩(q))) → (([G](p)) ∧ ([G](q))))
    "((¬(q ∧ q)) ∧ ((p ∧ p) ∧ (q → q))) → ([G]([G](⟨G⟩(p))))",
    "((⟨G⟩(⟨G⟩(q))) ∧ (¬([G](p)))) → (((q → p) → (¬(q))) ∧ (¬([G](q))))",
    "[G](¬(⟨G⟩(p ∧ q)))",
    "⟨G⟩(((¬(⟨G⟩((q ∧ p) → (¬(q))))) ∧ (((¬(q → q)) → ((q → p) → (¬(q))))" *
    "∧ (((¬(p)) ∧ (⟨G⟩(p))) → (¬(⟨G⟩(q)))))) ∧ ((¬(([G](p ∧ q)) → (¬(p → q)))) →" *
    "([G](([G](q∧ q)) ∧ ([G](q → p))))))"
]
[test_parsing_equivalence(parseformula(f)) for f in fxs]

fxs = ["→(→(q, p), ¬q)", "∧(∧(q, p), ¬q)"]
[test_parsing_equivalence(parseformula(f, function_notation = true)) for f in fxs ]

# malformed input ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@test_throws ErrorException parseformula("")
@test_throws ErrorException parseformula("¬p◊")
@test_throws ErrorException parseformula("¬p◊q")
@test_throws ErrorException parseformula("◊¬p◊")
@test_throws ErrorException parseformula("◊¬p◊q")
@test_throws ErrorException parseformula("(p∧q", [NEGATION, CONJUNCTION])
@test_throws ErrorException parseformula("))))", [CONJUNCTION])
@test_throws ErrorException parseformula("⟨G⟩p ¬⟨G⟩q")
@test_throws ErrorException parseformula("¬[[G]]p")

@test_throws ErrorException parseformula(""; function_notation = true)
@test_throws ErrorException parseformula("¬p◊"; function_notation = true)
@test_throws ErrorException parseformula("¬p◊q"; function_notation = true)
@test_throws ErrorException parseformula("◊¬p◊"; function_notation = true)
@test_throws ErrorException parseformula("◊¬p◊q"; function_notation = true)
@test_throws ErrorException parseformula("(p∧q", [NEGATION, CONJUNCTION];
    function_notation = true)
@test_throws ErrorException parseformula("))))", [CONJUNCTION];
    function_notation = true)
@test_throws ErrorException parseformula("¬[[G]]p"; function_notation = true)

@test_throws ErrorException parseformula("¬p∧q∧(¬s∧¬z)", opening_parenthesis="{")
@test_throws ErrorException parseformula("¬p∧q∧{¬s∧¬z)",
    opening_parenthesis="{", closing_parenthesis="}")
@test_throws ErrorException parseformula("¬p∧q∧ C ¬s∧¬z    B",
    opening_parenthesis="A", closing_parenthesis="B")

@test_throws ErrorException parseformula("¬p∧q→ |¬s∧¬z|",
    opening_parenthesis = "|", closing_parenthesis = "|")

# parsing atoms ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@test_nowarn parseformula("¬1→0";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))))
@test_nowarn parseformula("¬0.42∧1";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))))
@test_nowarn parseformula("¬-96";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))))

@test_nowarn parseformula("→(¬1,0)";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))),
    function_notation = true)
@test_nowarn parseformula("→(¬1;0)";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))),
    function_notation = true, arg_delim = ";")
@test_nowarn parseformula("→(¬1/0)";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))),
    function_notation = true, arg_delim = "/")
@test_nowarn parseformula("∧(¬0.42,1)";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))),
    function_notation = true)
@test_nowarn parseformula("¬-96";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))),
    function_notation = true)

@test_throws ErrorException parseformula("[G][G]-1.2[G]";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))))
@test_throws ErrorException parseformula("¬-3(";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))))

@test_throws ArgumentError parseformula("p";
    atom_parser = (x -> Atom{Float64}(parse(Float64, x))))

@test_nowarn parseformula("10 ∧ ⟨G⟩ 2 ∧ [=] -1", Connective[];
    atom_parser = x->(Atom{Int64}(parse(Int, x))))
@test_nowarn parseformula("10 ∧ ⟨G⟩ 2 ∧ [=] -1";
    atom_parser = x->(Atom{Int64}(parse(Int, x))))
@test_nowarn parseformula("10 ∧ ⟨G⟩ 2 ∧ [=] -1", Connective[];
    atom_parser = x->(Atom{Int64}(parse(Int, x))))
@test_nowarn parseformula("10 ∧ ⟨G⟩ 2 ∧ [=] -1";
    atom_parser = x->(Atom{Int64}(parse(Int, x))))


# custom operators ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TERNOP = SoleLogics.NamedConnective{:⇶}()
SoleLogics.arity(::typeof(TERNOP)) = 3

QUATERNOP = SoleLogics.NamedConnective{:⩰}()
SoleLogics.arity(::typeof(QUATERNOP)) = 4

@test_nowarn parseformula("⇶(p, q, r)", [TERNOP]; function_notation=true)
@test_nowarn parseformula("⇶(p1, q1, ⇶(p2, q2, r2))", [TERNOP]; function_notation=true)

@test_nowarn parseformula("⩰(p, q, r, s)", [QUATERNOP]; function_notation=true)
@test_nowarn parseformula("⩰(p1, q1, r1, ⩰(p2, q2, r2, s2))",
    [QUATERNOP]; function_notation=true)

# custom relations ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

using SoleLogics: AbstractRelationalConnective

struct _TestRel <: AbstractRelation end;
testrel  = _TestRel();
SoleLogics.arity(::_TestRel) = 2
SoleLogics.syntaxstring(::_TestRel; kwargs...) = "Test,Relation"

# If AbstractRelationalConnective interface changes, just redefine the following:
struct SoleRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end
(SoleRelationalConnective)(r::AbstractRelation) = SoleRelationalConnective{typeof(r)}()
SoleLogics.syntaxstring(op::SoleRelationalConnective; kwargs...) =
    "🌅$(syntaxstring(relation(op);  kwargs...))🌄"

struct PipeRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end
(PipeRelationalConnective)(r::AbstractRelation) = PipeRelationalConnective{typeof(r)}()
SoleLogics.syntaxstring(op::PipeRelationalConnective; kwargs...) =
    "|$(syntaxstring(relation(op);  kwargs...))|"

struct CurlyRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end
(CurlyRelationalConnective)(r::AbstractRelation) = CurlyRelationalConnective{typeof(r)}()
SoleLogics.syntaxstring(op::CurlyRelationalConnective; kwargs...) =
    "{$(syntaxstring(relation(op);  kwargs...))}"

struct MyCustomRelationalConnective{R<:AbstractRelation} <: AbstractRelationalConnective{R} end
(MyCustomRelationalConnective)(r::AbstractRelation) = MyCustomRelationalConnective{typeof(r)}()
SoleLogics.syntaxstring(op::MyCustomRelationalConnective; kwargs...) =
    "LEFT CUSTOM PARENTHESIS $(syntaxstring(relation(op);  kwargs...)) RIGHT CUSTOM PARENTHESIS"
f = parseformula("LEFT CUSTOM PARENTHESIS G RIGHT CUSTOM PARENTHESIS p ∧ ¬" *
    "LEFT CUSTOM PARENTHESIS G RIGHT CUSTOM PARENTHESIS q", [MyCustomRelationalConnective(globalrel)])

@test_nowarn parseformula("🌅G🌄p ∧ ¬🌅G🌄q", [SoleRelationalConnective(globalrel)])
@test_nowarn parseformula("∧(🌅G🌄p,¬🌅G🌄q)", [SoleRelationalConnective(globalrel)];
    function_notation = true)
@test_nowarn parseformula("∧[🌅G🌄p DELIM ¬🌅G🌄q)", [SoleRelationalConnective(globalrel)];
    function_notation = true, opening_parenthesis = "[", arg_delim = "DELIM")

@test_nowarn parseformula("|G|p   ∧ ¬|G|q", [PipeRelationalConnective(globalrel)])
@test_nowarn parseformula("∧(|G|p,  ¬|G|q)", [PipeRelationalConnective(globalrel)];
    function_notation = true)

@test_nowarn parseformula("{G}p   ∧  ¬{G}q", [CurlyRelationalConnective(globalrel)])
@test_nowarn parseformula("∧({G}p   ,¬{G}q)", [CurlyRelationalConnective(globalrel)];
    function_notation = true)

_f = parseformula("|G|p ∧ ¬{G}q", [CurlyRelationalConnective(globalrel)])
@test syntaxstring(token(children(_f)[1])) == "|G|p" # PipeRelationalConnective not specified
_f = parseformula("∧(|G|p,¬{G}q)", [CurlyRelationalConnective(globalrel)];
    function_notation = true)
@test syntaxstring(token(children(_f)[1])) == "|G|p"

_f = parseformula("{Gp ∧ ¬{G}q", [CurlyRelationalConnective(globalrel)])
@test syntaxstring(token(children(_f)[1])) == "{Gp"

@test_nowarn parseformula("¬⟨Test,Relation⟩[Test,Relation]p",
    [BoxRelationalConnective(testrel), DiamondRelationalConnective(testrel)]
)

# # parseba#= seformula ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# using SoleLogics: parsebaseformula

# @test_throws ErrorException parsebaseformula("")
# @test_broken parsebaseformula("⊤")
# @test_broken parsebaseformula("⊤ ∧ ⊤")
# @test_broken parsebaseformula("⊤ ∧ p")
# @test_broken parsebaseformula("⊥ ∧ □¬((p∧¬q)→r)")
# @test_broken parsebaseformula("□¬((p∧¬q)→r) ∧ ⊤")
# @test_broken parsebaseformula("⊤ ∧ (⊥∧¬⊤→⊤)")
# @test_nowarn parsebaseformula("□¬((p∧¬q)→r)")

# @test_nowarn parsebaseformula("p")

# @test_nowarn ¬parsebaseformula("p")
# @test_nowarn ¬parseformula("p")
# @test_nowarn ¬parseformula("(s∧z)", propositionallogic())
# @test_nowarn ¬parsebaseformula("p", propositionallogic())

# @test operatorstype(
#     logic(parsebaseformula("¬p∧q∧(¬s∧¬z)", [BOX]))) <: SoleLogics.BaseModalConnectives
# @test !(operatorstype(
#     logic(parsebaseformula("¬p∧q∧(¬s∧¬z)", [BOX]))) <:
#         SoleLogics.BasePropositionalConnectives)
# @test !(operatorstype(logic(
#     parsebaseformula("¬p∧q∧(¬s∧¬z)", modallogic()))) <:
#         SoleLogics.BasePropositionalConnectives)
# @test (@test_nowarn operatorstype(
#     logic(parsebaseformula("¬p∧q∧(¬s∧¬z)"))) <: SoleLogics.BasePropositionalConnectives)

# @test alphabet(logi =#c(parsebaseformula("p→q"))) == AlphabetOfAny{String}()

# stress test ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

s = "¬((¬(([G](⟨G⟩(¬((¬([G](⟨G⟩(⟨G⟩(q))))) → (¬(⟨G⟩((¬(q)) ∧ ([G](p))))))))) ∧ (⟨G⟩((" *
    "[G](⟨G⟩([G](⟨G⟩(⟨G⟩(q ∧ q)))))) ∧ (¬(⟨G⟩((([G](⟨G⟩(p))) ∧ (⟨G⟩(⟨G⟩(p)))) ∧ (⟨G⟩(" *
    "[G](p → p)))))))))) ∧ (([G](([G]([G](¬((((¬(p)) → (⟨G⟩(q))) → ((⟨G⟩(p)) → (q → p" *
    "))) ∧ (⟨G⟩(¬([G](p)))))))) ∧ ([G](⟨G⟩([G](¬([G]([G](q ∧ p))))))))) ∧ (¬([G]((⟨G⟩" *
    "(⟨G⟩(¬(((⟨G⟩(q)) ∧ (⟨G⟩(q))) → (⟨G⟩(q → p)))))) ∧ ([G](¬(((¬(¬(q))) → (¬(q → p))" *
    ") ∧ (([G](p → p)) → ((⟨G⟩(p)) → (q → p)))))))))))"
f = parseformula(s)
@test syntaxstring(f) == syntaxstring(parseformula(syntaxstring(f)))
@test syntaxstring(f; function_notation = true) ==
    syntaxstring(
        parseformula(
            syntaxstring(f; function_notation = true); function_notation = true
        );
        function_notation = true
    )

s = "◊((¬((◊(◊(((¬(¬(q))) ∧ ((p ∧ p) ∨ (¬(p)))) → (¬(□(¬(q))))))) ∨ ((□(((□(◊(q))) →"  *
    "((p → q) ∨ (□(q)))) → (◊(□(◊(p)))))) ∨ ((((□(q ∨ p)) → (◊(¬(q)))) → (((p ∨ q) →"  *
    "(◊(q))) ∧ ((q ∨ p) ∧ (◊(q))))) ∧ ((¬((◊(p)) ∨ (¬(p)))) ∧ (□(◊(q ∧ p)))))))) → ((" *
    "◊(¬((□((◊(q → q)) ∨ (□(□(p))))) ∧ (¬((¬(◊(p))) ∨ ((◊(q)) ∨ (□(q)))))))) → ((¬((¬" *
    "(◊((q ∨ q) ∨ (□(q))))) → (((¬(□(q))) ∨ (□(◊(q)))) → (((◊(p)) ∧ (◊(q))) ∨ (¬(q ∧"  *
    "q)))))) → ((□(◊(¬(◊(¬(p)))))) ∨ ((□(□((q → p) ∧ (p ∧ p)))) ∨ (((◊(◊(p))) → ((p →" *
    "q) ∧ (p → q))) ∧ (□((p ∨ q) ∧ (◊(q))))))))))"
f = parseformula(s)
@test syntaxstring(f) == syntaxstring(parseformula(syntaxstring(f)))
@test syntaxstring(f; function_notation = true) ==
    syntaxstring(
        parseformula(
            syntaxstring(f; function_notation = true); function_notation = true
        );
        function_notation = true
    )

@test_nowarn parseformula("10 ∧ ⟨G⟩ 2 ∧ [=] -1"; atom_parser = x->(Atom{Int64}(parse(Int, x))))

# synexpr

# NOTE: also if the following works, a MethodError is given during testing.
# LoadError: MethodError: no method matching (::NamedConnective{:∧})(::String, ::Atom{String})
#
# synexpr_formula = syntaxstring(@synexpr p ∧ q ∧ r ∨ s ∧ t)
# @test syntaxstring(parseformula("p ∧ q ∧ r ∨ s ∧ t")) == syntaxstring(synexpr_formula)
