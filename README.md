# Purefun 🩶
*A functional-first language for the developer’s heart*

> Purefun is not first and foremost a programming language.
> 
> It is a piece of art.
> 
> It does not aim at the brain — it aims at the developer’s heart.

## 1. Overview

Purefun is a functional-first, expression-oriented, and developer-centric language designed to bring joy, clarity, and simplicity to programming.
Every construct in Purefun is meant to feel natural and intentional — minimal syntax, strong semantics, and a deep emphasis on purity and readability.

Purefun programs may contain pure and side functions — representing two worlds: the world of calculation and the world of interaction.

## 2. File Structure

Each file may optionally begin with imports before all function/type definitions:

```
fun:math
  double
  sqrt
  
fun:io
  readFile
  writeFile
```

## 3. Functions

### 3.1 Function Declaration

Purefun has three function types:

* `pure` — no side effects  
* `side` — allows side effects (I/O, state, randomness, etc.)

Strings are delimited by single quotes (`'like this'`).
Double quotes are also allowed but equivalent.

Example:

```
pure greet(name string): string
  'Hello, ' + name
```

A pure function’s output depends solely on its inputs.

A side function may read from or write to the outside world:

```
side main()
  print(greet('world'))
```

**Note:** Parentheses are always required after a function name, even if it takes no parameters (e.g., side main()).

### 3.2 Recursive Functions

fun:list
  head
  isEmpty
  tail

```
pure sumList(l List<int>, acc int): int
  isEmpty(l) -> acc
  _ -> self(tail(l), acc + head(l))
```

Generic types use angle brackets (`<>`).

`self` refers to the current function and is used for explicit recursion.
`self` is optimized for constant stack usage.

## 4. Types

### 4.1 Type Declaration

Types are declared using the `type` keyword.
Purefun types are lightweight, immutable data records.

```
type Point
  x int
  y int
```

### 4.2 Nested Structures

Substructures can be defined inline:

```
type Person
  name string
  age int
  address
    street string
    city string
```

### 4.3 Construction

Types can be instantiated positionally or with named arguments:

**Inline tuple construction (allowed)**

```
john = Person('John', 42, ('Main St', 'Bigtown'))
```

**Named construction (recommended for clarity)**

```
john = Person(name: 'John', age: 42, address: (street: 'Main St', city: 'Bigtown'))
```

## 5. Expressions and Values

Everything in Purefun is an expression.
Blocks, conditionals, matches, and even imports evaluate to values.

Example:

```
pure describeAge(age int): string
  age < 13
    'child'
  age < 20
    'teen'
  _
    'adult'
```

# 6. Comments

There is only one supported way to write a comment. A comment starts with #, and only whitespaces (to get the comment on the same indentation as the code line) before the comment is allowed, nothing else.

The comment comments the line below, a comment can be multi-line, where all comment lines starts with #.

Example:

```
# This function doubles an integer
# i is an integer that should be doibled
pure double(i int) : int
  # This line doebles the value and returns it.
  i * 2
```

## 7. Control Flow

### 7.1 Conditional expressions (like cond or if, no keyword)

```
# if
x < 0
  'negative'

# else if
x == 0
  'zero'

# else
_
  'positive'
```

Alternative compact syntax:

```
x < 0 -> 'negative'
x == 0 -> 'zero'
_ -> 'positive'
```

Mixed syntax:

```
x < 0
  'negative'          
x == 0
  'zero'
_ -> 'positive'
```

Nested example:

```
x < 0
  y > 10
    'x negative, y larger than 10'
  _
    'x negative, y less than 11'
x == 0
  'zero'
_
  'positive'
```

### 7.2 Match Expressions (no keyword)

Standard syntax (two indentation levels):

```
color
  'red'
    'Stop'
  'green'
    'Go'
  _
    'Unknown'
```

Alternative compact syntax (one indentation level):

```
color
  'red' -> 'Stop'
  'green' -> 'Go'
  _ -> 'Unknown'
```

## 8. Reserved Words

**Core Modifiers**

```
pure, side, self, type
```

**Primitives**

```
int, num (floating-point), bool, string
```

**Generic Types**

```
List, Maybe, Map, Result
```

**Values**

```
true, false, _ (_ catches all values)
```

## 9. Indentation

Blocks are made with indentation, not inside curly braces or something similar.

Short blocks that fits on one line can be written like this without indentation.

```
x < 13 -> print('child')
```

**Indentation uses spaces (not tabs). Two spaces per level are required** and must be consistent within a file.

A block ends when indentation returns to or above the parent level.

```
x > 0
  'positive'
_
  '0 or negative'
```

### 9.1 Block Creators

**Functions**

```
pure, side
```

**Conditionals**

```
An expression starts a branch tree, so does an object.
```

**Types**

`type` declarations and substructures in a `type` declaration.

**Imports**

```
math:fun
  double
  sqrt

io:fun
  readFile
  writeFile
```

## 10. Try Purefun

```
fun:io
  'print'

pure double(i int): int
  i * 2

print('If you double 4 you get ' + double(4))
```

## 11. Philosophy

* **Purity with pragmatism** — everything pure by default, but side effects allowed when declared.
* **Structural Clarity** — code should read like prose and feel like composing ideas, not issuing commands.
* **Composability** — functions and types are the building blocks; simplicity is the tool.
* **Heart over ceremony** — Purefun is not designed to impress, but to express.

Purefun is not just written — it’s *composed*.

Purefun was created not to replace other languages, but to remind us why we fell in love with programming in the first place.

## 12. Status

Purefun is in active design.  

This document describes the initial language vision and may evolve through discussion and exploration.

Contributions welcome.

## 13. Why contribute?

Purefun is a language in design. If you want to contribute ideas, help refine syntax, or propose libraries, open an issue or start a discussion. No compiler is needed yet — your voice shapes the language.
