# SIDE-effects

Lean 4 kernel for the SIDE Exclusion method: the abstract exclusion
engine, a genuine Type-D exclusion via CRT exhaustiveness, the open
additive-prime milestones, and an honest record of retired
framework-consequence skeletons.

This kernel is the breadth-demonstration arm of the SIDE programme.
The central Riemann Hypothesis proof lives in
[SIDE-kernel](https://github.com/psinary-sketch/SIDE-kernel); the
genuine GRH cascade lives in
[SIDE-grh-transfer](https://github.com/psinary-sketch/SIDE-grh-transfer).
This repository carries the method engine and the genuine pieces that
transfer here — not a verification of every named consequence (see the
retirement note below).

## Architecture

### `SIDEEffects/Phase15/SIDEFramework.lean` — the method engine

The abstract SIDE exclusion engine: `MechanismClass`,
`ExhaustiveCatalogue` with `covers_all`, `NoneProduces`,
`SIDE_exclusion`, and `side_bridge`. Genuine content, 0 sorry.

### `SIDEEffects/Phase15/Module1.lean` — genuine Type-D exclusion

`crt_exhaustiveness` (every structural residue coupling is realized by
a modular coupling, via periodic lift) and
`no_type_d_conspiracies : IsEmpty TypeD`. This is the real CRT-based
no-conspiracy result. Genuine content, 0 sorry.

### `SIDEEffects/Structural.lean` — logical core + retirement ledger

Two genuine logical theorems:

| Theorem | Claim |
|:--------|:------|
| `formation_seven` | the ξ(s) formation count 2+3+2+0 = 7 |
| `AddMult.no_type_d` | if modular structure explains all coupling, no TYPE D conspiracy exists (generic lemma; genuine instance is `Module1`) |

Earlier revisions of this file carried propositional skeletons for
nine framework consequences (Yang-Mills, GRH, Landau-Siegel, BSD,
Artin, and Type-D for Twin / Goldbach / Sophie Germain). A
Phase S.2–S.4 audit found those were True-valued stubs or opaque-Prop
templates — 0 sorry and 0 axioms, but no content about the named
problems — and they have been **retired**, each with a per-problem
pointer to genuine content (`SIDE-grh-transfer` for GRH; `Module1` for
Type-D) or an honest open/classical-reduction status (Yang-Mills, BSD,
Landau-Siegel, Artin). See the retirement ledger in the file header.

### `SIDEEffects/Milestones.lean` — what is open

3 theorems, 3 sorrys (each at a marked analytic boundary), 0 axioms.

| Theorem | Real type | Closes via |
|:--------|:----------|:-----------|
| `twin_primes_infinite` | `¬(∃ N, ∀ p > N, ¬(Prime p ∧ Prime (p+2)))` | Hardy-Littlewood asymptotic |
| `goldbach` | `∀ n ≥ 4, Even n → ∃ p q prime, p + q = n` | Circle method |
| `sophie_germain_infinite` | `¬(∃ N, ∀ p > N, ¬(Prime p ∧ Prime (2p+1)))` | Sieve density bounds |

Each `sorry` sits at a clearly-marked analytic boundary, with a
discharge-path comment naming the Mathlib infrastructure required. The
structural Type-D exclusion these milestones rest on is the genuine
`Module1.no_type_d_conspiracies`; what remains is the Mathlib bridge
for the existence statement.

## What this kernel does and does not claim

- It **does** verify the abstract SIDE exclusion engine
  (`SIDEFramework`), a genuine Type-D / CRT exhaustiveness result
  (`Module1`), and the formation arithmetic and generic exclusion
  lemma (`Structural`).
- It **does not** verify the nine framework consequences as named
  problems. The earlier "nine consequences, real proofs not
  placeholders" framing was retracted in the Phase S.2–S.4 audit; the
  consequence skeletons were content-free and have been retired.
- Genuine GRH content is the separate `SIDE-grh-transfer` kernel.
  Yang-Mills and BSD have genuine formation-level kernels (`SIDE-yang-mills-formation`; `SIDE-bsd-formation-transfer` / `-multiplicity`) but no kernel proving the Clay mass-gap / Ш-finiteness / full-BSD theorems, which stay open;
  Landau-Siegel and Artin are classical reductions from GRH.

## Status

- 2 genuine logical theorems + retirement ledger (`Structural.lean`)
- abstract SIDE exclusion engine (`Phase15/SIDEFramework.lean`)
- genuine Type-D / CRT exhaustiveness (`Phase15/Module1.lean`)
- 3 additive milestones marked open (`Milestones.lean`)
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

1. Identify the Mathlib lemma(s) that close the analytic boundary
2. Replace the `sorry` with the proof using those lemmas
3. Update README and version tag

The migration history is the programme's progress record.

## Companion repositories

- [SIDE-kernel](https://github.com/psinary-sketch/SIDE-kernel) —
  the RH proof (cited by named terminal: the three route terminals at pinned commits, `{propext, Classical.choice, Quot.sound}`, 0 sorry)
- [SIDE-grh-transfer](https://github.com/psinary-sketch/SIDE-grh-transfer) —
  the genuine GRH cascade (real `DirichletCharacter ℂ n` exclusions)
- [SIDE-cosmo](https://github.com/psinary-sketch/SIDE-cosmo) —
  cosmological extension (formation phase space, Fano incidence,
  dark sector)

## Citation

```bibtex
@software{seale2026sideeffects,
  author = {Seale, J. York},
  title = {SIDE-effects: Lean 4 kernel for the SIDE Exclusion method — abstract engine, Type-D/CRT exclusion, and additive-prime milestones},
  year = {2026},
  url = {https://github.com/psinary-sketch/SIDE-effects}
}
```

## License

MIT.

## Author

J. York Seale | ORCID: [0009-0008-7993-0310](https://orcid.org/0009-0008-7993-0310)

**:: → · ← ::**
