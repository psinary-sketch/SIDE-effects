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

- **Additive-multiplicative / Type-D layer**: `no_type_d`
- **Shared engine**: `formation_seven`
- **Every other layer this list once named**: no theorem of this kernel. Those names were retired; they are preserved verbatim, with what the retirement ledger does and does not say about them, in the note at the foot of this file.

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

<!-- b368 currency block: layer-1 export list vs source -->

## Currency of the Layer-1 export list — checked 2026-09-08 against `afa9ccf`

*Appended, not edited. Nothing above this line has been changed. This block records the state of the "Theorems exported" list above as measured against the source at ref `main` = `afa9ccfbddc21e5bbd5ee2a4cbdf23f6a88498dd`, so a reader meets the measurement at the same time as the claim.*

**Of the 20 names the Layer-1 list above exports, 2 are declared in this kernel's own `.lean` files and 18 are not.** The 18 that are not were **retired** — each existed and was removed; none was invented, and none has a successor under another name in this kernel.

### Present in the source

- `no_type_d` — declared at `SIDEEffects/Structural.lean:54`. Axiom profile: **NO PRINTED PROFILE** (this kernel carries no printed profile file; none was computed here).
- `formation_seven` — declared at `SIDEEffects/Structural.lean:41`. Axiom profile: **NO PRINTED PROFILE** (this kernel carries no printed profile file; none was computed here).

### Retired, and named as retired by the retirement ledger

The ledger is the comment block headed `RETIREMENT LEDGER (audit Phase S.2–S.4)` in `SIDEEffects/Structural.lean`. These names appear in it explicitly:

- `mass_gap`
- `gap_bounds`
- `twist_cancels`
- `grh_exclusion`
- `no_ls_zero`
- `no_conspiracy_twins`
- `sha_bounded`
- `bsd_full`
- `artin_from_grh`

### Retired, but **not named** by the ledger — covered only by their layer's entry

These were removed too — the kernel's own `.lean` history shows each was present and is not now — but the ledger's entry for their layer does not list them by name. **The ledger is accurate about what it says and incomplete about what it names.**

- `all_gapped` — the ledger's entry for the Yang-Mills mass gap layer does not name it
- `all_excluded` — the ledger's entry for the Yang-Mills mass gap layer does not name it
- `sectors_complete` — the ledger's entry for the Yang-Mills mass gap layer does not name it
- `formation_preserved_grh` — the ledger's entry for the GRH layer does not name it
- `no_conspiracy_goldbach` — the ledger's entry for the Additive-multiplicative / Type-D layer does not name it
- `no_conspiracy_sg` — the ledger's entry for the Additive-multiplicative / Type-D layer does not name it
- `all_bound` — the ledger's entry for the BSD layer does not name it
- `all_mismatch_absent` — the ledger's entry for the BSD layer does not name it

### Retired, with **no ledger entry for their layer at all**

For the Shared engine the ledger has no entry. Neither these declarations nor their layer is recorded in it, and the repository's own `.lean` history — which shows each present in an earlier commit and absent now — is the whole of the evidence that they existed. **This is a sharper silence than the group above: there the ledger omits a name, here it omits a whole layer.**

- `side_exclusion` — NO LEDGER ENTRY FOR THIS LAYER; evidenced by the repository's own history

### What this block does and does not do

**It does not export anything.** Every name above appears under a status, not as an available theorem. **The list above this block is left exactly as it was**; this block is the currency note beside it, on the append-only pattern the programme's papers repository uses for its own ledgers.

**It does not retire, restore, rename or repair anything.** No `.lean` file was touched, no build was run, and no axiom profile was computed. **It does not claim the retirements were right** — only that they happened, and where they are recorded.

*Measured and appended by the PLACE TO STAND research seat, act b368 (2026-09-08), from this repository's own files at ref `main` = `afa9ccfbddc21e5bbd5ee2a4cbdf23f6a88498dd`. The measurement is reproducible: read the Layer-1 list, extract its backticked names, and search this kernel's six `.lean` files for a declaration of each.*

<!-- b369 (R4): the original list preserved verbatim, and the list repaired -->

## The Layer-1 export list as it stood at `5530d7c`, preserved verbatim — and repaired above

*Ruling (R4), 2026-09-08: **append-only is right for a ledger, where a reader reads the file; it is wrong for a list, where a reader reads the list.** The list above has therefore been **repaired in place**, and the original is preserved here, in the same file, quoted verbatim before the edit was made.*

### The original rows, verbatim — quoted here, and nowhere used as an export list

```markdown
- **Yang-Mills mass gap layer**: `all_gapped`, `mass_gap`, `all_excluded`, `sectors_complete`, `gap_bounds`
- **GRH layer**: `twist_cancels`, `formation_preserved_grh`, `grh_exclusion`
- **Landau-Siegel layer**: `no_ls_zero`
- **Additive-multiplicative / Type-D layer**: `no_type_d`, `no_conspiracy_twins`, `no_conspiracy_goldbach`, `no_conspiracy_sg`
- **BSD layer**: `all_bound`, `sha_bounded`, `all_mismatch_absent`, `bsd_full`
- **Artin layer**: `artin_from_grh` (via Hooley 1967)
- **Shared engine**: `side_exclusion`, `formation_seven`
```

Of the 20 names those rows exported, **2 are declared in this kernel's own `.lean` files and 18 are not** — re-derived at ref `main` = `5530d7c327e0d4d57b408fd3fb24be68f5c98722`, pinned against `ls-remote`, by extracting the backticked names and searching for a declaration of each. Every absent name existed and was removed; **none was invented, and none has a successor under another name in this kernel.**

### What the retirement ledger says, and where it says nothing

The ledger is the comment block headed `RETIREMENT LEDGER (audit Phase S.2–S.4)` in `SIDEEffects/Structural.lean`. **It does not speak for all of them, and this note does not speak for it.**

- **Named outright (10):** `mass_gap`, `gap_bounds`, `twist_cancels`, `grh_exclusion`, `no_ls_zero`, `no_conspiracy_twins`, `sha_bounded`, `bsd_full`, `artin_from_grh`, `side_exclusion`.
- **Named only by the ledger's slash abbreviation (2):** `no_conspiracy_goldbach`, `no_conspiracy_sg` — the ledger writes `no_conspiracy_twins/goldbach/sg`. **Reading that as naming these is a judgement, not a string match**, so they are listed apart rather than folded in with the names it writes out.
- **Covered only by their layer's entry (6):** `all_gapped`, `all_excluded`, `sectors_complete`, `formation_preserved_grh`, `all_bound`, `all_mismatch_absent` — the entry records that the layer's skeletons were retired without listing these by name. Their presence in an earlier commit and their absence now are visible in this repository's own history.
- **Not covered at all (0):** **none — every retired name is reached by the ledger, by its own name, by its abbreviation, or through its layer's entry.**

**Why the reason is not given here.** For no name in any group above does this kernel record *why* it went beyond what the entries quoted say. **This note does not supply one.** Ruling (R5): where the record is silent, the silence is reported rather than filled.

### What this block does and does not do

**It preserves; it does not restore.** The rows above are a quotation of a past state, not an export list. No name in them is available as a theorem.

**It does not retire, rename or repair anything in the source.** No `.lean` file was touched, no build was run, and no axiom profile was computed. **It does not claim the retirements were right** — only that they happened, and how far the kernel's own record accounts for them.

**And it supersedes two sentences in the block below it.** b368's currency note says that nothing above it had been changed and that the list was left exactly as it was. **Both were true when b368 wrote them and neither is true now**: ruling (R4) reversed the disposition, not the measurement. b368's block is left exactly as b368 wrote it; this paragraph is the correction, because a past record is named and superseded, never rewritten.

*Measured, preserved and repaired by the PLACE TO STAND research seat, act b369 (2026-09-08), from this repository's own files at ref `main` = `5530d7c327e0d4d57b408fd3fb24be68f5c98722`.*
