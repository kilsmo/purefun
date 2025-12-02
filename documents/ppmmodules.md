# Purefun Module System & ppm Specification (Draft)

## 1. Module Basics

* A Purefun module is any `.fun` file intended for sharing via **ppm** (Purefun Package Manager).

* **All functions marked `pure` or `tail` are automatically exported**.

* **Side-effect functions and top-level expressions** are present in the module file but are not accessible through ppm.

* This ensures a clear separation:

  * **Pure/tail functions → reusable, safe**

  * **Impure helpers or top-level code → local/internal** only

## 2. Import Syntax

Modules (ppm or local) are imported using single-quoted paths:

```
'fun/io'
  print
  readFile

'./localModule.fun'
  localFunction
```

Rules:

* Same syntax for local files or ppm modules

* No differentiation for “side-effect” modules — purity is enforced at call sites

* Compiler rejects calls from pure/tail functions to impure functions

## 3. Implicit Export Rule

* **All `pure` and `tail` functions are exported implicitly.**

* No exports list is needed.

* Removing a pure function is a breaking change → requires major version bump.

* Adding a pure function → minor version bump.

* Changing the signature of a pure function → major version bump.

* Side-effect functions or top-level expressions do not affect versioning.

## 4. Versioning & Compatibility

* Module versions follow semantic versioning: `major.minor.patch`

* Consumers may specify:

  * `'1'` → any `1.x.x` version

  * `'1.3'` → any `1.3.x` version

  * `'1.3.7'` → exact version

* Deep dependencies are resolved automatically:

  * Minor/patch updates are safe due to purity guarantees

  * Major updates must be explicit

* **All ppm modules are guaranteed pure**, ensuring safe forward compatibility.

## 5. Local vs ppm Modules

* **Local** `.fun` **files** can contain side effects, top-level expressions, or impure helpers.

* Local modules can use pure functions from ppm modules freely.

* Pure/tail functions cannot call side-effectful code — enforced by compiler.

* No special syntax is required for local vs ppm modules.

## 6. Purity Enforcement

* Compiler ensures:

  * `pure` or `tail` functions do not call impure functions

  * All ppm-published functions are pure/tail

* This allows **any ppm module** to be fully trusted without inspecting internal code.

## 7. Ppm Module File Structure

* The entire `.fun` file is published as a module.

* The file can include:

  * Pure/tail functions (exported)

  * Impure helpers (hidden)

  * Top-level expressions (hidden)

* This simplifies publishing, reduces friction, and maintains trust.

## 8. Philosophy Summary

1. **Purity is the gatekeeper of reusability**.

2. **Implicit exports** make modules minimal and easy to consume.

3. **Side-effectful code stays local** — it cannot pollute the module ecosystem.

4. **Semantic versioning aligns with purity rules** for safe, deterministic dependency resolution.

5. **Simple syntax and enforcement** keeps the design Purefunny and minimal.