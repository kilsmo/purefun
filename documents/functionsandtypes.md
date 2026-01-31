# Functions and Types

This document explains how to write functions and types in Purefun, with examples and best practices. It builds on the concepts in funfiles.md.

## 1. Function Types

Purefun has three function types:

`pure` — deterministic, side-effect free. Can only call `pure` or `tail` functions. Use whenever possible.

`side` — allows side effects (I/O, randomness, state). Can call any function type.

# 1.1 Rules

* `pure` functions cannot call side functions.

* `side` functions run in the runtime and may call any other function type.

* `side` functions are the only way to interact with the outside world.

## 2. Function Syntax

### 2.1 Declaration

```
pure greet(name string): string

tail sumList(l List<int>, acc int): int

side logMessage(msg string)
```

### 2.2 Details:

* All functions require parentheses, even with no parameters.

* Parameters are declared as name type.

* Return type is mandatory and follows a colon, unless if there is no return value, then there is no colon and no type (only allowed for `side` functions).

* Generics are supported, e.g., `List<int>, Map<string,int>`.

* Recursive functions use `self(...)` to recurse in a stack-safe way.

### 2.3 Examples

```
pure greet(name string): string
  'Hello, ' + name

tail factorial(n int, acc int): int
  n <= 1
    acc
  _
    self(n - 1, acc * n)

side printHello()
  print('Hello from side function')
```

## 3 Types

Purefun types are immutable data records.

#### 3.1 Declaration

```
type Point
  x int
  y int
```

#### 3.2 Nested structures

```
type Person
  name string
  age int
  address
    street string
    city string
```

#### 3.3 Construction:

```
Positional: john = Person('John', 42, ('Main St', 'Bigtown'))

Named: john = Person(name: 'John', age: 42, address: (street: 'Main St', city: 'Bigtown'))
```

## 4. Expressions

Everything in Purefun is an expression.

Conditionals, matches, cond expressions, function calls all return values.

### 4.1 Examples:

```
pure describeAge(age int): string
  age < 13
    'child'
  age < 20
    'teen'
  _
    'adult'

pure trafficLight(color string): string
  color
    'red' -> 'Stop'
    'green' -> 'Go'
    _ -> 'Unknown'

pure positiveOrNegative(x int): string
  x < 0
    'negative'
  x == 0
    'zero'
  _
    'positive'

pure whichFruit(): string
  fruit = 'banana'

  fruit
    'apple' -> 'Red or green fruit'
    'banana' -> 'Yellow fruit'
    _ -> 'Unknown fruit'
```

## 5 Composition Tips

* Keep pure logic in pure/tail functions for clarity and efficiency.

* Use side functions only for I/O or stateful interactions.

* Organize code in files using the three-section structure: imports, definitions, top-level expressions.

* Top-level expressions can be used for tests or small programs but are only included in the binary if the file is compiled directly.

## 6 Examples / Mini-Programs

### 6.1 Example 1 — Hello world:

```
fun:io
  print

side main()
  print('Hello, world!')
```

### 6.2 Example 2 — Using pure program function:

```
fun:io
  exit
  getCommandLineArguments

:./math.fun
  add
  mul

pure program(args List<string>): int
  length(args) >= 2 -> 0
  _ -> -1

exit(program(getCommandLineArguments()))
```
