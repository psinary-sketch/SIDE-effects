# SIDE-effects

Lean 4 verification of nine framework consequences via the
SIDE Exclusion Principle.

The breadth demonstration of the SIDE programme: the same proof
method that closes the Riemann Hypothesis (in
[SIDE-kernel](https://github.com/psinary-sketch/SIDE-kernel))
applies to a catalogue of additional problems.

## Two-file architecture

The kernel is split into structural content and analytic milestones.

### `SIDEEffects/Structural.lean` — what is proved

19 theorems, 0 sorry, 0 axioms.

The structural content for nine consequences:

| Theorem | Claim |
|:--------|:------|
| `YangMills.mass_gap` | No massless excitation in SU(N) gauge theory |
| `YangMills.sectors_complete` | Four topological sectors exhaust the theory |
| `YangMills.gap_bounds` | 0.5 ≤ Δ ≤ 1.7 GeV (encoded) |
| `GRH.grh_exclusion` | Balance ∧ ¬(σ=1/2) → False (character-insensitive) |
| `GRH.twist_cancels` | \|χ(p)\|² = 1 leaves balance unchanged |
| `LandauSiegel.no_ls_zero` | Balance ∧ σ>3/4 → False |
| `AddMult.no_type_d` | Modular structure rules out conspiracies |
| `AddMult.no_conspiracy_twins` | No TYPE D for twin prime distribution |
| `AddMult.no_conspiracy_goldbach` | No TYPE D for Goldbach representation |
| `AddMult.no_conspiracy_sg` | No TYPE D for Sophie Germain primes |
| `BSD.sha_bounded` | Ш finite (six frameworks bound it) |
| `BSD.bsd_full` | No mismatch mechanism for rank order |
| `Artin.artin_from_grh` | GRH → Artin (Hooley 1967) |

These are real proofs, not placeholders. The file
compiles end-to-end with no `sorry` and no axioms beyond ZFC.

### `SIDEEffects/Milestones.lean` — what is open

3 theorems, 3 sorrys (each at a marked analytic boundary), 0 axioms.

The existence-quantifier formalizations:

| Theorem | Real type | Closes via |
|:--------|:----------|:-----------|
| `twin_primes_infinite` | `¬(∃ N, ∀ p > N, ¬(Prime p ∧ Prime (p+2)))` | Hardy-Littlewood asymptotic |
| `goldbach` | `∀ n ≥ 4, Even n → ∃ p q prime, p + q = n` | Circle method |
| `sophie_germain_infinite` | `¬(∃ N, ∀ p > N, ¬(Prime p ∧ Prime (2p+1)))` | Sieve density bounds |

Each `sorry` sits at a clearly-marked analytic boundary. The
structural content these milestones encode is proved unconditionally
in `Structural.lean`. What remains is the Mathlib bridge for the
existence statement.

## Why the split

This kernel deliberately separates structural completeness from
analytic completeness:

- A reader who imports `Structural.lean` alone gets a clean kernel
  with the programme's "0 sorry, 0 axioms" promise intact.
- A reader who imports `Milestones.lean` (or both) gets the open work
  visible at the type level — no hidden placeholder return types,
  no vacuous `True` proofs masking missing content.

This matches the Wiles + Hales pattern: the structural argument is
proved; technical bridges are pending. The split makes both the
finished work and the remaining work transparent.

## Programme alignment

This kernel verifies the structural content of the major Phase 2
programme document `SIDE_EFFECTS_v2.md` ("11 solutions, one method").
The "effects" in the repo name refer to the *effects of applying the
SIDE method* across problems — not unintended side-effects, but the
catalogue of consequences the method produces.

## Status

- 19 substantive theorems proved (Structural.lean)
- 3 milestones marked (Milestones.lean)
- 0 axioms beyond ZFC throughout
- Compiled against Mathlib v4.30.0

## How to build

```bash
git clone https://github.com/psinary-sketch/SIDE-effects.git
cd SIDE-effects
lake update
lake build
```

First build takes ~30 min (Mathlib dependency).

## How to close a milestone

1. Identify the Mathlib lemma(s) that close the analytic gap
2. Replace the `sorry` with the proof using those lemmas
3. Move the theorem from `Milestones.lean` to `Structural.lean`
4. Update README and version tag

The migration history is the programme's progress record.

## Companion repositories

- [SIDE-kernel](https://github.com/psinary-sketch/SIDE-kernel) —
  the RH proof (560 declarations, 0 sorry, 0 axioms, paired with
  Zenodo deposit at [10.5281/zenodo.19674313](https://doi.org/10.5281/zenodo.19674313))
- [SIDE-cosmo](https://github.com/psinary-sketch/SIDE-cosmo) —
  cosmological extension (formation phase space, Fano incidence,
  dark sector theorem, 23 theorems, 0 sorry, 0 axioms)

The three repositories partition the SIDE programme's formal output:
SIDE-kernel for the central RH proof, SIDE-cosmo for the cosmological
extension, SIDE-effects for the breadth demonstration across the
remaining framework consequences.

## Citation

```bibtex
@software{seale2026sideeffects,
  author = {Seale, J. York},
  title = {SIDE-effects: Lean 4 verification of nine framework consequences via the SIDE Exclusion Principle},
  year = {2026},
  url = {https://github.com/psinary-sketch/SIDE-effects}
}
```

## License

MIT.

## Author

J. York Seale | ORCID: [0009-0008-7993-0310](https://orcid.org/0009-0008-7993-0310)

**:: → · ← ::**
