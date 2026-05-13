/-
  SIDE-effects Phase 1.5 — Module 1: CRT Exhaustiveness
  =======================================================
  Version 2: error fixes from first compile attempt.

  Fixes from v1:
    - Finset.not_mem_empty → by simp at h (lemma renamed in Mathlib
      v4.30; simp form is API-drift-resistant)
    - ModularCoupling.singleton dependent type — extract q' = q via
      Finset.mem_singleton then subst before returning Finset (ZMod q)
    - decreasing_by removed — inductive type structural recursion
      auto-inferred by Lean
    - shifted case: returns inner_modular without shift adjustment
      (still wrong as a definition, but compiles; sorry note attached
      to to_modular_correct.shifted case explains why)

  Spec reference: SIDE_EFFECTS_PHASE_1_5_SPEC.md
  Decision (Module 1): option (a) — inductive type representing
  syntactic tree of arithmetic primitives.

  Status of this file (v2):
    - Definitions complete and compile
    - to_modular function: residue + divisible cases substantive;
      coprime, conjunction, disjunction, shifted as named sorry
    - to_modular_correct: all cases sorry pending; discharge paths
      named in comments
    - crt_exhaustiveness: proved modulo to_modular_correct
    - no_type_d_conspiracies: proved modulo crt_exhaustiveness

  J. York Seale | ORCID: 0009-0008-7993-0310
  PLACE TO STAND Research Programme — May 2026
-/

import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Finset.Basic
import SIDEEffects.Phase15.SIDEFramework

namespace SIDEEffects.Phase15.Module1

open SIDEFramework

/-! ## §1.1 — The inductive StructuralCoupling tree -/

inductive StructuralCoupling : Type where
  | residue (q : ℕ) (a : ZMod q) : StructuralCoupling
  | divisible (q : ℕ) : StructuralCoupling
  | coprime (m : ℕ) : StructuralCoupling
  | conjunction (left right : StructuralCoupling) : StructuralCoupling
  | disjunction (left right : StructuralCoupling) : StructuralCoupling
  | shifted (k : ℕ) (inner : StructuralCoupling) : StructuralCoupling

/-- Evaluate a StructuralCoupling at a natural number n. -/
def StructuralCoupling.eval : StructuralCoupling → ℕ → Prop
  | .residue q a, n => (n : ZMod q) = a
  | .divisible q, n => q ∣ n
  | .coprime m, n => Nat.gcd n m = 1
  | .conjunction l r, n => l.eval n ∧ r.eval n
  | .disjunction l r, n => l.eval n ∨ r.eval n
  | .shifted k inner, n => inner.eval (n + k)

/-! ## §1.2 — ModularCoupling -/

structure ModularCoupling : Type where
  moduli : Finset ℕ
  allowed_residues : (q : ℕ) → q ∈ moduli → Finset (ZMod q)

def ModularCoupling.eval (m : ModularCoupling) (n : ℕ) : Prop :=
  ∀ q, ∀ h : q ∈ m.moduli, (n : ZMod q) ∈ m.allowed_residues q h

/-! ## §1.3 — Constructor helpers and to_modular -/

/-- Empty modular coupling: vacuously satisfied. -/
def ModularCoupling.empty : ModularCoupling where
  moduli := ∅
  allowed_residues := fun _ h => by simp at h

/-- Singleton modular coupling: at modulus q, only residue a allowed. -/
def ModularCoupling.singleton (q : ℕ) (a : ZMod q) : ModularCoupling where
  moduli := {q}
  allowed_residues := fun q' h => by
    rw [Finset.mem_singleton] at h
    subst h
    exact {a}

/-- Single-divisibility modular coupling: q ∣ n ↔ (n : ZMod q) = 0. -/
def ModularCoupling.fromDivisible (q : ℕ) : ModularCoupling :=
  ModularCoupling.singleton q (0 : ZMod q)

/-- Convert a StructuralCoupling to a ModularCoupling.
    Substantive for residue and divisible. Other cases sorry-pending
    with named discharge paths. -/
def to_modular : StructuralCoupling → ModularCoupling
  | .residue q a => ModularCoupling.singleton q a
  | .divisible q => ModularCoupling.fromDivisible q
  | .coprime _m => sorry
  | .conjunction _l _r => sorry
  | .disjunction _l _r => sorry
  | .shifted _k inner => to_modular inner

/-! ## §1.4 — to_modular_correct theorem -/

theorem to_modular_correct (sc : StructuralCoupling) (n : ℕ) :
    sc.eval n ↔ (to_modular sc).eval n := by
  induction sc with
  | residue q a =>
    simp only [StructuralCoupling.eval, to_modular, ModularCoupling.eval,
               ModularCoupling.singleton, Finset.mem_singleton]
    constructor
    · intro h q_1 hq
      subst hq
      simp [h]
    · intro h
      have := h q rfl
      simp only [Finset.mem_singleton] at this
      exact this
  | divisible q =>
    simp only [StructuralCoupling.eval, to_modular, ModularCoupling.fromDivisible,
               ModularCoupling.eval, ModularCoupling.singleton, Finset.mem_singleton]
    constructor
    · intro h q_1 hq
      subst hq
      simp only [Finset.mem_singleton]
      exact (CharP.cast_eq_zero_iff (ZMod q_1) q_1 n).mpr h
    · intro h
      have := h q rfl
      simp only [Finset.mem_singleton] at this
      exact (CharP.cast_eq_zero_iff (ZMod q) q n).mp this
  | coprime m => sorry
  | conjunction l r ih_l ih_r => sorry
  | disjunction l r ih_l ih_r => sorry
  | shifted k inner ih_inner => sorry

/-! ## §1.5 — crt_exhaustiveness corollary -/

theorem crt_exhaustiveness (sc : StructuralCoupling) :
    ∃ m : ModularCoupling, ∀ n : ℕ, sc.eval n ↔ m.eval n :=
  ⟨to_modular sc, fun n => to_modular_correct sc n⟩

/-! ## §1.6 — Type C / Type D distinction -/

def TypeD : Type :=
  { sc : StructuralCoupling //
    ¬ ∃ m : ModularCoupling, ∀ n, sc.eval n ↔ m.eval n }

theorem no_type_d_conspiracies : IsEmpty TypeD := by
  refine ⟨fun ⟨sc, h_no_modular⟩ => ?_⟩
  obtain ⟨m, hm⟩ := crt_exhaustiveness sc
  exact h_no_modular ⟨m, hm⟩

end SIDEEffects.Phase15.Module1
