/-!
  SIDE-EFFECTS — STRUCTURAL CONTENT
  ==================================
  Genuine logical content for the SIDE Exclusion method, plus an
  honest record of which framework-consequence skeletons have been
  RETIRED.

  History. Earlier revisions of this file carried propositional
  "structural skeletons" for nine framework consequences (Yang-Mills
  mass gap, GRH, Landau-Siegel, BSD Ш-finiteness, full BSD, Artin,
  and Type-D exclusion for Twin Primes / Goldbach / Sophie Germain).
  A Phase S.2–S.4 audit found those skeletons were either True-valued
  stubs (e.g. `gapped := fun _ => True`) or opaque-Prop templates
  (a theorem taking its conclusion's content as a `Prop` hypothesis
  and discharging by the supplied implication). They compiled with
  0 sorry and 0 axioms but said nothing about their named problems,
  so they have been retired here. Pointers to genuine content are
  given in the retirement ledger below.

  J. York Seale | ORCID: 0009-0008-7993-0310

  Genuine content elsewhere in this kernel:
    - Phase15/SIDEFramework.lean : the abstract SIDE exclusion engine
      (ExhaustiveCatalogue, NoneProduces, SIDE_exclusion, side_bridge).
    - Phase15/Module1.lean : genuine Type-D exclusion via CRT
      exhaustiveness (crt_exhaustiveness, no_type_d_conspiracies).
    - Milestones.lean : the full Twin / Goldbach / Sophie-Germain
      existence statements, openly `sorry` at the analytic boundary.

  Genuine GRH content is the separate SIDE-grh-transfer kernel (real
  exclusions over `DirichletCharacter ℂ n`), not re-proved here.
-/

set_option linter.unusedSectionVars false

-- ============================================================
-- GENUINE LOGICAL CONTENT
-- ============================================================

/-- Formation count for ξ(s): n₁+n₂+n₃+n₄ = 2+3+2+0 = 7. -/
theorem formation_seven : 2 + 3 + 2 + 0 = 7 := rfl

namespace AddMult

/-- A TYPE D conspiracy: a coupling that escapes the modular constraints. -/
def TypeD (α : Type) (coupling modular : α → Prop) : Prop :=
  ∃ a, coupling a ∧ ¬(modular a)

/-- Generic exclusion lemma: when modular structure explains all
    coupling, no TYPE D conspiracy exists. This is the real logical
    core. Its genuine arithmetic instance — CRT exhaustiveness over
    residue couplings — is `Phase15/Module1.lean : no_type_d_conspiracies`,
    NOT a `True`/`True` instantiation. -/
theorem no_type_d (α : Type) (coupling modular : α → Prop)
    (h : ∀ a, coupling a → modular a) :
    ¬(TypeD α coupling modular) := by
  intro ⟨a, hc, hnm⟩
  exact hnm (h a hc)

end AddMult

-- ============================================================
-- RETIREMENT LEDGER (audit Phase S.2–S.4)
-- ============================================================
-- The following framework-consequence skeletons were retired as
-- content-free (True-stub or opaque-Prop). Honest status of each
-- named problem and where genuine content lives, if anywhere:
--
--   Yang-Mills mass gap
--     Theorem OPEN; no genuine kernel proves the mass gap. Genuine
--     formation-level placement is SIDE-yang-mills-formation (mass gap
--     as n3 domain-Ostrowski / output stage 3), not the theorem.
--     (Retired: `gapped := True` on four sectors ⇒ `mass_gap : ¬Massless`;
--     `gap_bounds : 50 ≤ 170`. MetaKernel `ym_massless := False` likewise retired.)
--
--   GRH
--     Genuine cascade is the SIDE-grh-transfer kernel (real
--     `DirichletCharacter ℂ n` exclusions, scope = structural
--     exhaustiveness analog). (Retired: opaque-Prop `grh_exclusion`,
--     `twist_cancels : balance ↔ balance`.)
--
--   Landau-Siegel
--     Classical-reduction from GRH; no dedicated kernel. (Retired:
--     opaque-Prop `no_ls_zero`.)
--
--   Type-D — Twin Primes / Goldbach / Sophie Germain
--     Genuine structural exclusion is Phase15/Module1.lean
--     (`crt_exhaustiveness` ⇒ `no_type_d_conspiracies : IsEmpty TypeD`);
--     the analytic existence statements are openly `sorry` in
--     Milestones.lean. (Retired: `TypeD Nat (fun _ => True) (fun _ => True)`
--     ⇒ `no_conspiracy_twins/goldbach/sg`.)
--
--   BSD Ш-finiteness, full BSD
--     Theorem OPEN; no genuine kernel proves Ш-finiteness or full BSD.
--     Genuine formation-level content is SIDE-bsd-formation-transfer +
--     SIDE-bsd-multiplicity (tuple (2,3,2,0)=7 matching ξ, critical line,
--     root-number ±1 parity, framework counts), not the theorem.
--     (Retired: `bounds_sha := True`, `mismatch_absent := True` ⇒
--     `sha_bounded`, `bsd_full`. The `Sha_finite`/`sha_finite`/
--     `bsd_fully_closed`/`BSD_architecture_fully_closed` decls in those
--     formation kernels are likewise `True`-stubs.)
--
--   Artin primitive-root conjecture
--     Classical-reduction (Hooley 1967, conditional on GRH); no kernel.
--     (Retired: opaque-Prop modus-ponens `artin_from_grh`.)
--
--   side_exclusion (¬P → ¬P)
--     Retired as a trivial identity; the genuine exclusion engine is
--     `Phase15/SIDEFramework.lean : SIDE_exclusion`.
-- ============================================================
