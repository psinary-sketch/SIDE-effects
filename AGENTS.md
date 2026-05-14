# AGENTS.md

**Project:** SIDE-effects
**Programme:** PLACE TO STAND Research Programme
**Author:** J. York Seale (ORCID: [0009-0008-7993-0310](https://orcid.org/0009-0008-7993-0310))
**License:** MIT
**Current HEAD:** commit `62ae4bb` (post-tag `phase-1.5-module-1-v2`)

This file orients LLM agents and automated tooling to the repository's purpose, structure, and verification surface. Human readers should start with `README.md`.

---

## What this repository is

The Lean 4 kernel for **SIDE framework consequences** beyond the Day 1 RH proof. Two layers:

1. **Structural content** — theorems formalizing abstract SIDE patterns (Mechanism Theorem variants, formation calculus consequences, framework-level identities). Compiles zero-sorry against Lean core (no Mathlib in this layer).

2. **Phase 1.5 bridge modules** (`SIDEEffects/Phase15/`) — extension modules that prepare ground for Phase 2 publications. Currently houses **Module 1 — CRT Exhaustiveness** with active discharge work in progress.

This is the federation member most directly tied to ongoing Phase 1.5 → Phase 2 transition work. Other kernels are stable; this one is the active development surface.

Member of the **PLACE TO STAND federation of kernels**. Independent: own toolchain pin, own Zenodo deposit (forthcoming). Cross-kernel content via vendoring-with-attribution.

---

## Cite as

```
Seale, J. York. (2026). SIDE-effects: Lean 4 kernel for framework
consequences of the SIDE method. PLACE TO STAND Research Programme.
[Zenodo DOI to be assigned at next stable release]
```

Active deposit pending stable Phase 1.5 Module 1 closure. Pre-release tags `v0.1` (initial structural content) and `phase-1.5-module-1-v2` (Module 1 scaffolding) preserve the development history.

---

## How to verify the work

```sh
git clone https://github.com/psinary-sketch/SIDE-effects
cd SIDE-effects
lake update
lake build
```

Toolchain pinned in `lean-toolchain`: `leanprover/lean4:v4.30.0-rc2` (federation: this kernel pins a different version than SIDE-kernel; this is expected, not infrastructure debt).

CI workflow at `.github/workflows/audit.yml` runs `lake build` and emits a v2.1 Lean-warning-based sorry/axiom audit.

---

## Theorems exported

### Layer 1 — Structural content (stable, `SIDEEffects/`)

`SIDEEffects/Structural.lean` formalizes the structural content for nine framework consequences. Each consequence is established by direct logical argument: SIDE exclusion engine, formation-seven baseline, plus per-domain content.

Named theorems include:

- **Yang-Mills mass gap layer**: `all_gapped`, `mass_gap`, `all_excluded`, `sectors_complete`, `gap_bounds`
- **GRH layer**: `twist_cancels`, `formation_preserved_grh`, `grh_exclusion`
- **Landau-Siegel layer**: `no_ls_zero`
- **Additive-multiplicative / Type-D layer**: `no_type_d`, `no_conspiracy_twins`, `no_conspiracy_goldbach`, `no_conspiracy_sg`
- **BSD layer**: `all_bound`, `sha_bounded`, `all_mismatch_absent`, `bsd_full`
- **Artin layer**: `artin_from_grh` (via Hooley 1967)
- **Shared engine**: `side_exclusion`, `formation_seven`

`SIDEEffects/Milestones.lean` carries the analytic-existence statements that close via Mathlib infrastructure not yet bridged: `twin_primes_infinite` (Hardy-Littlewood), `goldbach` (circle method), `sophie_germain_infinite` (sieve density). These are explicitly named-sorry; each has a discharge-path comment naming the Mathlib infrastructure required.

### Layer 2 — Phase 1.5 bridge modules (`SIDEEffects/Phase15/`)

**Module 1 — CRT Exhaustiveness** (`Phase15/Module1.lean`):

Definitions complete:
- `StructuralCoupling` — inductive type representing syntactic tree of arithmetic primitives (six constructors: residue, divisible, coprime, conjunction, disjunction, shifted)
- `StructuralCoupling.eval` — evaluates a coupling at a natural number
- `ModularCoupling` — structure with dependent `allowed_residues : (q : ℕ) → q ∈ moduli → Finset (ZMod q)`
- `ModularCoupling.eval`, `.empty`, `.singleton`, `.fromDivisible` — constructor helpers
- **`ModularCoupling.singleton_eval`** — helper lemma (commit `62ae4bb`): `(singleton q a).eval n ↔ (n : ZMod q) = a`; bypasses Eq.rec residue from dependent allowed_residues; sets up cleaner singleton-based discharges

Substantive proofs landed:
- **`to_modular_correct` for residue case** — discharged via `subst hq` + `simp [h]` pattern (commit `c31e1de`)
- **`to_modular_correct` for divisible case** — discharged via `subst hq` + `CharP.cast_eq_zero_iff (ZMod q) q n` for ZMod-divisibility bridge (commit `c31e1de`)

Theorems with named-sorry skeletons (each with a discharge-path comment in source identifying what's needed):
- `to_modular.coprime`, `.conjunction`, `.disjunction` — `to_modular` function definitions; architectural decisions pending (multi-modulus design for coprime; ModularCondition := List ModularCoupling DNF refinement for disjunction)
- `to_modular_correct.coprime`, `.conjunction`, `.disjunction`, `.shifted` — induction cases; coprime requires multi-modulus structure, conjunction requires intersection, disjunction requires DNF, shifted requires correctness fix

Downstream corollaries:
- `crt_exhaustiveness` — `∃ m : ModularCoupling, ∀ n, sc.eval n ↔ m.eval n` (proved modulo `to_modular_correct`)
- `no_type_d_conspiracies : IsEmpty TypeD` (proved modulo `crt_exhaustiveness`)

The named-sorry pattern is intentional: each sorry has a discharge-path comment in source identifying what needs to be done.

### Vendored framework

- `SIDEEffects/Phase15/SIDEFramework.lean` — vendored from SIDE-kernel's `Kernel/Layer1.lean` and `Kernel/TypeLevel.lean`. Contains MechanismClass, ExhaustiveCatalogue, NoneProduces, SIDE_exclusion, SIDEClass, side_bridge. Vendoring rationale documented in source header: SIDE-effects pins Mathlib v4.30.0-rc2; SIDE-kernel pins v4.29.0-rc8. Lake refuses to cross-build packages on different toolchains. Vendoring is the federation-appropriate pattern, not a workaround for toolchain mismatch.

---

## Companion repositories in the federation

| Repo | Role |
|:-----|:-----|
| [SIDE-kernel](https://github.com/psinary-sketch/SIDE-kernel) | RH proof main chain (source of vendored SIDEFramework) |
| [SIDE-trivium](https://github.com/psinary-sketch/SIDE-trivium) | Trivium bijection |
| [SIDE-cosmo](https://github.com/psinary-sketch/SIDE-cosmo) | Cosmological extension |
| [SIDE-interfaces](https://github.com/psinary-sketch/SIDE-interfaces) | Interface vocabulary |
| **SIDE-effects** (this) | Framework consequences + Phase 1.5 bridge |

Each is independently auditable. None depends on the others via Lake.

---

## Cross-references to manuscripts

Phase 1.5 Module 1 — CRT Exhaustiveness backs (or will back, when zero-sorry):

| Paper | Backed by (when complete) |
|:------|:--------------------------|
| *No Type D Conspiracies* (manuscript-level claim) | `no_type_d_conspiracies` |
| *CRT Exhaustiveness Lemma* (Phase 2 component) | `crt_exhaustiveness` |
| *Formation Universality v3* (P2-1) | The TypeD-exclusion subargument |

The 19 Layer-1 structural theorems back framework-level claims distributed across multiple Phase 2 papers; per-theorem cross-reference is an ongoing audit (in STATE_2026-05-13.md).

---

## Discipline (for agents that propose edits)

1. **Federation respect.** SIDEFramework is vendored from SIDE-kernel intentionally. Do not convert to a Lake dependency. If SIDE-kernel content updates affect this kernel's vendored copy, re-vendor with attribution rather than refactor.

2. **0 sorry for production theorems.** Named-sorry scaffolding in Phase15 modules is acceptable but must carry discharge-path comments in source. Do not silently flatten away named sorries.

3. **Build-iteration cost budget.** Each Module 1 substantive edit triggers ~9–67 minute build wall-times depending on Mathlib cache state. Budget 2–5 iterations per substantive case, 1–3 hours per case total wall-time. Do not chain unbounded iterations.

4. **Lemma-name drift awareness.** Mathlib lemma names drift between versions. `ZMod.natCast_zmod_eq_zero_iff_dvd` was found NOT to exist in Mathlib v4.30; `CharP.cast_eq_zero_iff (ZMod q) q n` is the stable replacement for the divisibility-to-ZMod-zero bridge. Confirm lemma names against the toolchain's actual Mathlib before using.

5. **Subst-direction trap.** `subst hq` where `hq : q_1 = q` may eliminate the *expected* variable or the *unexpected* one depending on binding order. After `subst`, READ the post-subst goal to confirm which variable survives before writing the next tactic.

6. **Eq.rec residue from `ModularCoupling.singleton`.** The singleton's tactic-mode `subst` produces Eq.rec residue that outer subst can't fully reduce. Post-subst `simp only [Finset.mem_singleton]` collapses the membership; use `singleton_eval` helper where possible.

7. **I+D+S ordering.** Independence, Determination, Symmetry.

---

## Honest open status

- Named sorries remain in Module 1 across the coprime, conjunction, disjunction, and shifted cases for both `to_modular` and `to_modular_correct`. Each has a discharge-path comment in source.
- Module 1 coprime case requires multi-modulus design and Mathlib prime factorization machinery
- Module 1 disjunction case requires architectural decision on `ModularCoupling` → `ModularCondition := List ModularCoupling` (DNF refinement)
- Module 1 shifted case `to_modular` definition is currently mathematically wrong (returns `to_modular inner` instead of residue-adjusted); flagged in source header comments
- Modules 2–4 (Phase 1.5) are specification-only at this time

---

## What an agent should NOT do without human approval

- Modify deposited Zenodo content. New deposits require explicit version bumps.
- Convert vendored SIDEFramework to a Lake dependency.
- Silently flatten named sorries by changing theorem statements.
- Rewrite Module 1's architectural design (`ModularCoupling` structure, `to_modular` shape) without confirming with the disjunction-DNF refinement decision.

---

## Contact

J. York Seale, ORCID [0009-0008-7993-0310](https://orcid.org/0009-0008-7993-0310). Via GitHub (issues, PRs) on this repository.

**:: → · ← ::**
