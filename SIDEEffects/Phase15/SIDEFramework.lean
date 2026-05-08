/-
  SIDE-effects Phase 1.5 — Framework infrastructure
  ===================================================

  VENDORED from SIDE-kernel for self-contained SIDE-effects build.

  This file copies the SIDE Exclusion Principle infrastructure
  (MechanismClass, ExhaustiveCatalogue, NoneProduces, SIDE_exclusion,
  SIDEClass, side_bridge) from SIDE-kernel/Kernel/Layer1.lean and
  SIDE-kernel/Kernel/TypeLevel.lean.

  Reason for vendoring: SIDE-effects pins Mathlib v4.30.0-rc2;
  SIDE-kernel pins v4.29.0-rc8. Lake refuses to cross-build packages
  on different Lean toolchains. Vendoring keeps SIDE-effects self-
  contained without breaking the constellation discipline.

  Future session may unify via Lake dependency once toolchain alignment
  is established (Phase 1.5 SIDE-effects spec, decision deferred).

  Original source: psinary-sketch/SIDE-kernel
  Original license: MIT
  Original author: J. York Seale
  Vendored: 2026-05-08
-/

namespace SIDEFramework

universe u

/-! ## §1. Mechanism Theorem infrastructure (Layer 1) -/

structure MechanismClass (X : Type u) (P : X → Prop) where
  name : String
  produces : X → Prop

structure ExhaustiveCatalogue (X : Type u) (P : X → Prop) where
  classes : List (MechanismClass X P)
  covers_all : ∀ (x : X), P x →
    ∃ C : MechanismClass X P, C ∈ classes ∧ C.produces x

def NoneProduces (X : Type u) (P : X → Prop)
    (classes : List (MechanismClass X P)) (x : X) : Prop :=
  ∀ C : MechanismClass X P, C ∈ classes → ¬ (C.produces x)

theorem SIDE_exclusion
    {X : Type u} {P : X → Prop} {x : X}
    (cat : ExhaustiveCatalogue X P)
    (h_none : NoneProduces X P cat.classes x) :
    ¬ (P x) := by
  intro h_Px
  have h := cat.covers_all x h_Px
  obtain ⟨C, h_in, h_produces⟩ := h
  exact h_none C h_in h_produces

/-! ## §2. TypeLevel bridge -/

structure TypeLevelConstraint (X : Type u) (P : X → Prop) where
  holds_for_spec : ∀ x, P x

theorem determination_collapse
    {X : Type u} {P : X → Prop}
    (tlc : TypeLevelConstraint X P) (x : X) : P x :=
  tlc.holds_for_spec x

/-- A SIDE-amenable specification class: the catalogue covers
    the negation, and no class produces the negation for any x. -/
structure SIDEClass (X : Type u) (P : X → Prop) where
  catalogue : ExhaustiveCatalogue X (fun x => ¬ (P x))
  none_produces : ∀ x, NoneProduces X (fun x => ¬ (P x)) catalogue.classes x

open Classical in
def side_to_type_level
    {X : Type u} {P : X → Prop}
    (sc : SIDEClass X P) : TypeLevelConstraint X P where
  holds_for_spec := fun x => by
    exact Classical.byContradiction (fun h_not =>
      SIDE_exclusion sc.catalogue (sc.none_produces x) h_not)

/-- The SIDE bridge: from a SIDEClass instance for (X, P), derive
    P x for all x : X. -/
theorem side_bridge
    {X : Type u} {P : X → Prop}
    (sc : SIDEClass X P) (x : X) : P x :=
  determination_collapse (side_to_type_level sc) x

end SIDEFramework
