/-!
# ExhaustivenessLicense — the graded ladder of exhaustiveness certificates

W-LADDER kernel half (2026-07-25). The SIDE E-condition asks: *is the mechanism catalogue
exhaustive?* This module compiles the **ordered ladder of licenses** an exclusion instance can
carry for that exhaustiveness, and grades the corpus's own instances against it.

The four grades, strongest first:

* `theorem_` — **THEOREM (Ostrowski-class).** Exhaustiveness is certified by a classification /
  finiteness theorem in ZFC (Ostrowski 1916 for the places of ℚ; CFSG; geometrization). The search
  terminates *and* a theorem proves it terminates completely.
* `search` — **SEARCH (Hodge-class).** Exhaustiveness is established by search / verification, with a
  conservation-style prediction of termination, but no closed classification theorem yet.
* `forcedOrUnderdetermined` — **FORCED-OR-UNDERDETERMINED (T7-class).** The count is forced by the
  structure's own formation architecture, but its exhaustiveness carries no independent theorem or
  terminating-search certificate — forced by construction, or underdetermined.
* `none` — **NONE.** No exhaustiveness license: no theorem, no terminating search, no forcing.

**Salt-check discipline.** The grades are NOT axiom-stipulated. `Grade.rank` is a function; the order
`Grade.le` derives from it; the ladder facts (`theorem_is_top`, `ladder_strict`) are proved. Each
corpus instance carries its factual `Evidence`, and its grade is *computed* by `grade` and proved by
`decide`/`rfl` — never asserted. The **only** open point is the E-Difficulty biconditional
(`EDifficultyTop`), carried as a **named premise** (INTERFACES), never proved here: it is the bridge
from the ladder's top grade to the difficulty theory (E-Difficulty Level 1, TYPE-I discharge).

`theorem` throughout (vanilla-build law); core Lean only, no Mathlib, no `native_decide`.
-/

namespace SIDEEffects
namespace ExhaustivenessLicense

/-- The four exhaustiveness-license grades. Ordered
    `theorem_ > search > forcedOrUnderdetermined > none`. -/
inductive Grade where
  | none
  | forcedOrUnderdetermined
  | search
  | theorem_
deriving DecidableEq, Repr

/-- The strength rank of a grade — a *function*, the sole source of the order. -/
def Grade.rank : Grade → Nat
  | .none => 0
  | .forcedOrUnderdetermined => 1
  | .search => 2
  | .theorem_ => 3

/-- The order relation on grades — DERIVED from `rank`, not stipulated per-grade. -/
def Grade.le (a b : Grade) : Prop := a.rank ≤ b.rank

instance : LE Grade := ⟨Grade.le⟩

/-- The order is decidable — inherited from `Nat.decLe` on the ranks. -/
instance (a b : Grade) : Decidable (a ≤ b) := Nat.decLe a.rank b.rank

/-- The order is reflexive (a genuine preorder, compiled). -/
theorem Grade.le_refl (a : Grade) : a ≤ a := Nat.le_refl a.rank

/-- The order is transitive (a genuine preorder, compiled). -/
theorem Grade.le_trans {a b c : Grade} (h₁ : a ≤ b) (h₂ : b ≤ c) : a ≤ c :=
  Nat.le_trans h₁ h₂

/-- **THEOREM is the top of the ladder** — derived from `rank`, proved for every grade. -/
theorem theorem_is_top (g : Grade) : g ≤ Grade.theorem_ := by
  cases g <;> decide

/-- **NONE is the bottom of the ladder.** -/
theorem none_is_bottom (g : Grade) : Grade.none ≤ g := by
  cases g <;> decide

/-- The ladder is strict at every rung — the four grades are genuinely ordered, not collapsed. -/
theorem ladder_strict :
    Grade.none.rank < Grade.forcedOrUnderdetermined.rank
    ∧ Grade.forcedOrUnderdetermined.rank < Grade.search.rank
    ∧ Grade.search.rank < Grade.theorem_.rank := by decide

/-- The factual evidence an exclusion instance can carry for the exhaustiveness of its catalogue.
    This is *data* — what certificates the instance actually has — not a verdict. -/
structure Evidence where
  /-- A classification / finiteness theorem certifies the catalogue complete (Ostrowski-class). -/
  hasClassificationTheorem : Bool
  /-- A search / verification establishes completeness, with predicted termination (Hodge-class). -/
  hasTerminatingSearch : Bool
  /-- The count is forced by the formation architecture (T7-class). -/
  isForced : Bool
deriving DecidableEq, Repr

/-- **The grading function** — the grade DERIVES from the evidence, strongest applicable first.
    The verdict is *computed*, never stipulated. -/
def grade (e : Evidence) : Grade :=
  if e.hasClassificationTheorem then Grade.theorem_
  else if e.hasTerminatingSearch then Grade.search
  else if e.isForced then Grade.forcedOrUnderdetermined
  else Grade.none

/-! ## The corpus's own instances as inhabitants, with their grades computed -/

/-- **RH** — the seven-class catalogue's exhaustiveness rests on classification theorems
    (Ostrowski n₂=3, ring classification n₁=2, Cartan B n₃=2, Conservation/Tate n₄=0). THEOREM-grade,
    conditional on `h2` at the totality register — the conditionality is the E-Difficulty bridge below. -/
def RH_evidence : Evidence := ⟨true, true, true⟩

/-- **Hodge** — exhaustiveness search-established (Hodge Conservation predicts termination; no closed
    classification theorem). SEARCH-grade. (Evidence: `SEARCH_TERMINATES §6.2`.) -/
def Hodge_evidence : Evidence := ⟨false, true, false⟩

/-- **T7 seven-length** — the seven-fold count is forced by the formation architecture; no independent
    theorem or terminating search certifies its exhaustiveness. FORCED-OR-UNDERDETERMINED. -/
def T7_evidence : Evidence := ⟨false, false, true⟩

/-- **The class-number diagonal** (the ℚ(√−6) diagonal of the class-number-anomaly kernel) — likewise
    forced by construction, exhaustiveness not independently certified. FORCED-OR-UNDERDETERMINED. -/
def classNumberDiagonal_evidence : Evidence := ⟨false, false, true⟩

theorem RH_grade : grade RH_evidence = Grade.theorem_ := rfl
theorem Hodge_grade : grade Hodge_evidence = Grade.search := rfl
theorem T7_grade : grade T7_evidence = Grade.forcedOrUnderdetermined := rfl
theorem classNumberDiagonal_grade :
    grade classNumberDiagonal_evidence = Grade.forcedOrUnderdetermined := rfl

/-- The instances sit on the ladder in the ordered relation the grades induce:
    T7 ≤ Hodge ≤ RH, and the class-number diagonal shares T7's rung. -/
theorem instances_ordered :
    grade T7_evidence ≤ grade Hodge_evidence
    ∧ grade Hodge_evidence ≤ grade RH_evidence
    ∧ grade classNumberDiagonal_evidence ≤ grade Hodge_evidence := by decide

/-! ## The E-Difficulty bridge — the single INTERFACES point (named premise, never encoded) -/

/-- **The E-Difficulty biconditional at the top grade.** An instance earns the THEOREM grade *iff*
    its mechanism search is TYPE-I discharged (the domain Ostrowski is constructed — E-Difficulty
    Level 1). This is a *named premise*: the bridge from the ladder's top to the difficulty theory,
    supplied from outside, never proved inside this module. -/
def EDifficultyTop (e : Evidence) (typeI_discharged : Prop) : Prop :=
  (grade e = Grade.theorem_) ↔ typeI_discharged

/-- **INTERFACES — top grade ⇒ TYPE-I discharge, through the named E-Difficulty bridge.**
    RH's top grade is proved (`RH_grade`); the bridge (the named premise) carries it to the
    difficulty-theoretic conclusion. The biconditional itself is disclaimed — this theorem never
    proves it, it consumes it. -/
theorem RH_typeI_of_top {RH_typeI_discharged : Prop}
    (bridge : EDifficultyTop RH_evidence RH_typeI_discharged) :
    RH_typeI_discharged :=
  bridge.mp RH_grade

end ExhaustivenessLicense
end SIDEEffects
