# Purefun Coding Style Guide

This is the coding style guideline for Purefun. It focuses on clarity, consistency, and readability.

## Naming

### 1. Type names use PascalCase.

```
type UserProfile
```

### 2. Function names use camelCase.

```
pure calculateScore(val1 int, val2 int): int
```

### 3. Bindings and parameters use camelCase.

```
pure greetUser(userName string): string
  greetString = "Hello, " + userName
  greetString
```

### 4. Keywords are lowercase. Examples: `pure`, `type`.

```
pure isValid(x int): bool
  x > 0
```

### 5. Constants and global variables do not exist in Purefun.

### 6. Indentation and Line Length

* Block indentation: 2 spaces.

* Tabs are not allowed.

* Maximum line length: 80 characters.

* Line continuation:

* If a line must continue, indent all continuation lines 4 spaces more than the base indentation of the first line.

* Break lines at logical points (operators, commas, or between elements).

* Continuation lines should remain aligned for readability.

Examples:

```
pure complexCalculation(a int, b int, c int, d int): int
  a + b * c -
      d / (a + b) +
      e + f

pure numbers(): List[int]
  [1, 2, 3,
      4, 5, 6,
      7, 8, 9]

pure nested(a int, b int): int
  (a + b) * (a - b) +
      (a * a + b * b)
```

### 7. Strings

Single quotes for normal strings.

Double quotes if the string contains single quotes or nested quotes for better readability.

```
// Normal string
'hello'

// String with nested quotes
"'hello'"
```

### 8. Functions

Functions should be defined with the pure keyword, parameters, and return type.

Example of a simple function:

```
pure isEqual(val1 int, val2 int): bool
  val1 == val2
```

Multi-line expressions inside functions follow the line continuation rule.

### 9. Comments

Inline comments: use // and continue to the end of the line.

Doc comments: use /// placed above the function or type definition.

```
/// Returns true if two values are equal
pure isEqual(val1 int, val2 int): bool
  val1 == val2

pure example(): int
  1 + 2 // Simple addition
```

### 10. Linter

* A linter will make sure that naming, intendation, etc is correct, all code should follow the rules of the linter to be able to be commited.

### 11. General Guidelines

* Break long lines logically and readably, especially for expressions, function calls, and lists.

* Keep code consistent and predictable, which improves readability for all developers.
