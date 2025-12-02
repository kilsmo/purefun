# Atoms

Atoms are the lowest-level primitive operations available to the Purefun language. They are implemented in `C` (or platform-specific languages) and exposed to Purefun as built-in functions. Atoms are the bridge between Purefun and the underlying operating system or hardware.

There are two categories of atoms, Pure and Side-effects

## 1. Pure atoms

These have no side effects and always return the same output for the same input. They behave exactly like pure functions, but their logic is implemented in C for performance or platform access.

**Example:** mathematical functions (`sqrt`, `sin`, `cos`).


## 2. Side-effect atoms

These perform observable effects such as printing, reading input, file access, networking, timers, randomness, etc. They are only usable inside side functions and cannot appear inside a pure function.

Atoms are not written by application developers. They are part of the standard library (fun/) and are maintained by language and runtime contributors.

## 3. Pure Atoms, function list

These atoms behave like pure functions:

```
pure atom pf_sqrt(n num): num

pure atom pf_sin(a num): num

pure atom pf_cos(a num): num

pure atom pf_tan(a num): num

pure atom pf_abs(n num): num

pure atom pf_floor(n num): num

pure atom pf_ceil(n num): num

pure atom pf_round(n num): num

pure atom pf_pow(a num, b num): num

pure atom pf_string_length(s string): num

pure atom pf_string_concat(a string, b string): string

pure atom pf_string_slice(s string, start num, end num): string
```

Pure atoms are allowed anywhere a pure function can be used.

## 4. Side-effect Atoms, function list

These atoms can only be used inside side functions. They always return the hidden type unit, even though the type is not shown in Purefun syntax.

```
side atom pf_print_line(s string)
// Prints a line of text to the standard output.

side atom pf_read_line(): string
// Reads one line from standard input.

side atom pf_file_read(path string): string
// Reads the full contents of a file.

side atom pf_file_write(path string, contents string)
// Writes text to a file, replacing the previous contents.

side atom pf_random_num(): num
// Returns a random number.

side atom pf_current_time_ms(): num
// Returns current time in milliseconds.

side atom pf_sleep_ms(n num)
// Sleep/delay the current thread.
```

Side-effect atoms may not be called inside a pure function. They must be wrapped or sequenced inside side functions.

## 5. Atom Implementations

Each atom corresponds to a small C function that is part of the Purefun runtime. For portability:

* macOS, Linux, Windows implementations exist separately

* the Purefun compiler links the correct atom set for the target platform

* pure atoms usually share identical C implementations across platforms

* side-effect atoms often require platform-specific code (printing, files, timers)

Atoms are intentionally simple. More complex features (HTTP requests, JSON parsing, structured file formats, databases) will live in a higher layer called ppm, the Purefun Package Manager, where they can be composed out of atoms and pure functions.

## 6. Atom Purpose

Atoms exist for exactly three reasons:

* Provide minimal access to the real world

Without side-effect atoms, Purefun could not print, read input, or access files.

* Provide efficient low-level operations

Pure atoms allow Purefun to rely on fast, optimized platform math and string operations.

* Keep the core language small

Instead of building OS-specific features into the language, Purefun exposes only the minimum set of primitives and lets libraries build upward.

## 7. Pure fun functions using pure atoms

A pure fun function may freely call pure atoms, because they have no side effects.

Example (conceptual syntax):

```
pure lengthOfTwoStrings(a string, b string): num
  x = pf_string_length(a)
  y = pf_string_length(b)
  x + y
```

Here, `pf_string_length` is a `pure atom`.

The function remains pure and behaves like any pure user-defined function.

## 8. Side fun functions using side-effect atoms

A side fun function can call any side-effect atom. Because atoms return the hidden unit type, side functions implicitly sequence operations.

**Example:**

```
side say_hello(name string)
  pf_print_line("Hello, " + name)
```

Here pf_print_line is a side-effect atom.

## 9. How fun functions wrap atoms

Fun functions often serve as a more ergonomic interface around atoms.

For example:

fun/ defines `print(s string)` which calls the `atom pf_print_line(s string)`

fun/ defines `read()` which calls the `atom pf_read_line()`

This lets end users stay inside Purefun and never think about atoms at all.

**Example:**

```
side print_twice(s string)
  print(s)
  print(s)
```

Even though print_twice is written in Purefun, the final compiled output may inline or sequence the underlying C atom calls.

## 10. Why fun/ function wrap atoms instead of exposing them

There are three reasons:

* The atoms should not leak their platform differences or low-level details.

* Fun/ functions can ensure naming conventions, error handling, and type safety.

* Atoms may differ between platforms (Windows vs Linux vs macOS).
Fun/ hides these differences so user code does not change.

## 11. Rule Summary

* Pure fun functions → can call pure atoms, never side atoms

* Side fun functions → can call both pure and side atoms

* User code → never calls atoms directly

* fun/ → provides the public interface

* atoms/ → provides low-level C implementations
