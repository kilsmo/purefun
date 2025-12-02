# Atom Naming Convention

Atoms in PureFun use `snake_case` with a required prefix.
The prefix ensures that atom names never collide with:

* Built-in C functions (sin, cos, exp, …)

* PureFun user-defined functions (which use camelCase)

* Reserved or common identifiers in generated code

# 1. Rules

All atoms use the prefix pf_.

**Examples:**

* pf_sin

* pf_vec3_add

* pf_time_ms

Use snake_case after the prefix.
This makes atoms visually distinct from user-level PureFun functions (which use camelCase).

Do not use short unprefixed names.
For example:

sin → ❌ conflicts with C’s sin

math_sin → better but inconsistent with the rest of the system

pf_sin → ✔️ consistent, globally unique, safe

Atoms represent primitive or host-bound operations that are not expressible in PureFun alone (math intrinsics, vector ops, hardware I/O, system calls, etc.).

Their names must remain stable, predictable, and free from namespace conflicts.

## 2. Why snake_case?

* Atoms function as system-level primitives, not part of everyday PureFun code.

* snake_case visually signals that they belong to the runtime layer.

* Using a distinct naming style prevents confusion with:

  * user functions (camelCase)

  * type constructors (PascalCase)

  * .fun function declarations (camelCase)
