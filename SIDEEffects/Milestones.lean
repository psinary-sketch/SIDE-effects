import Mathlib.Data.Nat.Prime.Basic
import SIDEEffects.Structural
/-!
  SIDE-EFFECTS — MILESTONES
  ==========================
  Three analytic existence statements for the additive-multiplicative
  problems, each an open conjecture stated as a `Prop`. The programme's
  structural Type-D exclusion is `Phase15/Module1.lean :
  no_type_d_conspiracies` (CRT exhaustiveness); `Structural.lean` carries
  the generic `no_type_d` lemma; no milestone uses either. The EXISTENCE
  statements would be proved through Mathlib infrastructure not yet bridged.
  Each milestone here (RESTATED at b648 under the author's ruling (R258)(2)):
    - states the real conjecture as a `Prop` (not a True placeholder)
    - is stated, not proved; open -- a `def`, with no proof and no `sorry`
    - documents which Mathlib infrastructure would prove it
  When a milestone is proved, a theorem concluding its `Prop` is added
  and the README/version tag updated. Until 2026-10-10 each stood as a
  `theorem` closed by `sorry`; that history is in this file's git log.
  J. York Seale | ORCID: 0009-0008-7993-0310
-/
namespace AddMult
/-- MILESTONE M3: infinitely many twin primes -- stated, not proved; open.
    The twin-prime conjecture as a `Prop`. Proving it would need the
    Hardy-Littlewood asymptotic π₂(N) ~ 2C₂ N / (log N)², which forces
    π₂(N) → ∞. Mathlib status: PrimeCounting infrastructure exists; the
    Hardy-Littlewood density theorem is not yet packaged. -/
def twin_primes_infinite : Prop :=
    ¬(∃ N : ℕ, ∀ p > N, ¬(Nat.Prime p ∧ Nat.Prime (p + 2)))
/-- MILESTONE M4: the binary Goldbach conjecture -- stated, not proved; open.
    Every even n ≥ 4 is the sum of two primes, as a `Prop`.
    Evenness expressed inline as `∃ k, n = 2 * k` to avoid
    dependency on the Mathlib Even/Odd parity infrastructure
    (whose location varies across Mathlib versions).
    Proving it would need the circle method, giving r(n) ≫ 1 for even
    n ≥ 4 (where r(n) counts representations as p + q with p, q prime).
    Mathlib status: circle method not yet formalized. -/
def goldbach : Prop :=
    ∀ n : ℕ, n ≥ 4 → (∃ k : ℕ, n = 2 * k) →
      ∃ p q : ℕ, Nat.Prime p ∧ Nat.Prime q ∧ p + q = n
/-- MILESTONE M5: infinitely many Sophie Germain primes -- stated, not proved; open.
    Infinitely many primes p such that 2p+1 is also prime, as a `Prop`.
    Proving it would need sieve bounds establishing positive density of
    Sophie Germain primes. Mathlib status: basic sieve infrastructure
    exists; the specific bounds are not yet packaged. -/
def sophie_germain_infinite : Prop :=
    ¬(∃ N : ℕ, ∀ p > N, ¬(Nat.Prime p ∧ Nat.Prime (2 * p + 1)))
end AddMult
/-!
  ## Status
  3 definitions, each a `Prop` stating an open conjecture; 0 sorry.
  Restated from `theorem ... := by sorry` at b648 under the author's
  ruling (R258)(2). `Module1.no_type_d_conspiracies` (CRT exhaustiveness)
  states `IsEmpty TypeD` over the programme's own couplings; no milestone
  uses it, and none of the three conjectures follows from it in Lean.
  ## How to prove a milestone
  1. Identify the Mathlib lemma(s) the conjecture needs
  2. Add a theorem concluding the milestone's `Prop`
  3. Update README and version tag
-/
