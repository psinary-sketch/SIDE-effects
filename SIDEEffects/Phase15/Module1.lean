/-
  SIDE-effects Phase 1.5 — Module 1: CRT Exhaustiveness
  Version 3.1: end-to-end Option-1 closure (import + computability fixes).
  Positivity in the constructors -> no conditional hypotheses. to_modular is the
  single period-modulus coupling; correctness is one periodicity proof. The data
  witness is noncomputable (classical decidability for the residue filter); the
  theorems are unconditional.
  J. York Seale | ORCID: 0009-0008-7993-0310
-/

import Mathlib
import SIDEEffects.Phase15.SIDEFramework

namespace SIDEEffects.Phase15.Module1

/-! ## StructuralCoupling (positivity in the type) -/

inductive StructuralCoupling : Type where
  | residue (q : ℕ) (hq : 0 < q) (a : ZMod q) : StructuralCoupling
  | divisible (q : ℕ) (hq : 0 < q) : StructuralCoupling
  | coprime (m : ℕ) (hm : 0 < m) : StructuralCoupling
  | conjunction (left right : StructuralCoupling) : StructuralCoupling
  | disjunction (left right : StructuralCoupling) : StructuralCoupling
  | shifted (k : ℕ) (inner : StructuralCoupling) : StructuralCoupling

def StructuralCoupling.eval : StructuralCoupling → ℕ → Prop
  | .residue q _ a, n => (n : ZMod q) = a
  | .divisible q _, n => q ∣ n
  | .coprime m _, n => Nat.gcd n m = 1
  | .conjunction l r, n => l.eval n ∧ r.eval n
  | .disjunction l r, n => l.eval n ∨ r.eval n
  | .shifted k inner, n => inner.eval (n + k)

/-! ## ModularCoupling -/

structure ModularCoupling : Type where
  moduli : Finset ℕ
  allowed_residues : (q : ℕ) → q ∈ moduli → Finset (ZMod q)

def ModularCoupling.eval (m : ModularCoupling) (n : ℕ) : Prop :=
  ∀ q, ∀ h : q ∈ m.moduli, (n : ZMod q) ∈ m.allowed_residues q h

/-! ## Period -/

def StructuralCoupling.period : StructuralCoupling → ℕ
  | .residue q _ _ => q
  | .divisible q _ => q
  | .coprime m _ => m
  | .conjunction l r => Nat.lcm l.period r.period
  | .disjunction l r => Nat.lcm l.period r.period
  | .shifted _ inner => inner.period

theorem StructuralCoupling.period_pos : ∀ sc : StructuralCoupling, 0 < sc.period := by
  intro sc
  induction sc with
  | residue q hq a => simpa [StructuralCoupling.period] using hq
  | divisible q hq => simpa [StructuralCoupling.period] using hq
  | coprime m hm => simpa [StructuralCoupling.period] using hm
  | conjunction l r ihl ihr =>
      simp only [StructuralCoupling.period]
      exact Nat.pos_of_ne_zero (Nat.lcm_ne_zero ihl.ne' ihr.ne')
  | disjunction l r ihl ihr =>
      simp only [StructuralCoupling.period]
      exact Nat.pos_of_ne_zero (Nat.lcm_ne_zero ihl.ne' ihr.ne')
  | shifted k inner ih => simpa [StructuralCoupling.period] using ih

/-! ## Periodicity -/

theorem periodic_lift {f : ℕ → Prop} {p L : ℕ}
    (hp : ∀ n, f n ↔ f (n % p)) (hpL : p ∣ L) :
    ∀ n, f n ↔ f (n % L) := by
  intro n
  rw [hp n, hp (n % L), Nat.mod_mod_of_dvd n hpL]

theorem StructuralCoupling.eval_periodic :
    ∀ sc : StructuralCoupling, ∀ n, sc.eval n ↔ sc.eval (n % sc.period) := by
  intro sc
  induction sc with
  | residue q hq a =>
      intro n
      simp only [StructuralCoupling.eval, StructuralCoupling.period]
      have hcast : (n : ZMod q) = ((n % q : ℕ) : ZMod q) := by
        conv_lhs => rw [← Nat.mod_add_div n q]
        push_cast
        rw [ZMod.natCast_self]
        ring
      rw [hcast]
  | divisible q hq =>
      intro n; simp only [StructuralCoupling.eval, StructuralCoupling.period]
      exact (Nat.dvd_mod_iff (dvd_refl q)).symm
  | coprime m hm =>
      intro n; simp only [StructuralCoupling.eval, StructuralCoupling.period]
      rw [Nat.gcd_comm n m, Nat.gcd_rec]
  | conjunction l r ihl ihr =>
      intro n; simp only [StructuralCoupling.eval, StructuralCoupling.period]
      rw [periodic_lift ihl (Nat.dvd_lcm_left l.period r.period) n,
          periodic_lift ihr (Nat.dvd_lcm_right l.period r.period) n]
  | disjunction l r ihl ihr =>
      intro n; simp only [StructuralCoupling.eval, StructuralCoupling.period]
      rw [periodic_lift ihl (Nat.dvd_lcm_left l.period r.period) n,
          periodic_lift ihr (Nat.dvd_lcm_right l.period r.period) n]
  | shifted k inner ih =>
      intro n; simp only [StructuralCoupling.eval, StructuralCoupling.period]
      rw [ih (n + k), ih ((n % inner.period) + k)]
      have he : (n + k) % inner.period = ((n % inner.period) + k) % inner.period := by
        simp [Nat.add_mod]
      rw [he]

/-! ## Single-modulus coupling for a periodic predicate (classical filter) -/

noncomputable def ofPeriodic (L : ℕ) (hL : 0 < L) (P : ℕ → Prop) :
    ModularCoupling where
  moduli := {L}
  allowed_residues := fun q hq =>
    haveI : NeZero q := ⟨by rw [Finset.mem_singleton] at hq; subst hq; exact hL.ne'⟩
    haveI : DecidablePred (fun r : ZMod q => P r.val) := Classical.decPred _
    Finset.univ.filter (fun r : ZMod q => P r.val)

theorem ofPeriodic_eval (L : ℕ) (hL : 0 < L) (P : ℕ → Prop)
    (hper : ∀ n, P n ↔ P (n % L)) (n : ℕ) :
    (ofPeriodic L hL P).eval n ↔ P n := by
  haveI : NeZero L := ⟨hL.ne'⟩
  unfold ModularCoupling.eval
  constructor
  · intro h
    have hm := h L (Finset.mem_singleton_self L)
    simp only [ofPeriodic, Finset.mem_filter, Finset.mem_univ, true_and] at hm
    rw [ZMod.val_natCast] at hm
    exact (hper n).mpr hm
  · intro hP q hq
    have hq' : q = L := Finset.mem_singleton.mp hq
    subst hq'
    simp only [ofPeriodic, Finset.mem_filter, Finset.mem_univ, true_and]
    rw [ZMod.val_natCast]
    exact (hper n).mp hP

/-! ## to_modular and exhaustiveness (unconditional) -/

noncomputable def to_modular (sc : StructuralCoupling) : ModularCoupling :=
  ofPeriodic sc.period sc.period_pos sc.eval

theorem to_modular_correct (sc : StructuralCoupling) (n : ℕ) :
    sc.eval n ↔ (to_modular sc).eval n :=
  (ofPeriodic_eval sc.period sc.period_pos sc.eval sc.eval_periodic n).symm

theorem crt_exhaustiveness (sc : StructuralCoupling) :
    ∃ m : ModularCoupling, ∀ n : ℕ, sc.eval n ↔ m.eval n :=
  ⟨to_modular sc, fun n => to_modular_correct sc n⟩

def TypeD : Type :=
  { sc : StructuralCoupling //
    ¬ ∃ m : ModularCoupling, ∀ n, sc.eval n ↔ m.eval n }

theorem no_type_d_conspiracies : IsEmpty TypeD := by
  refine ⟨fun ⟨sc, h_no_modular⟩ => ?_⟩
  exact h_no_modular (crt_exhaustiveness sc)

end SIDEEffects.Phase15.Module1