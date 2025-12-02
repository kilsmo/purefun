# File Sections

## 1. Imports

Used to bring other modules or specific functions/types into scope.

```
'fun/io'
  print
  exit
  getCommandLineArguments

'./math.fun'
  add
  mul
```

## 2. Definitions

Contains type declarations and function definitions.
There are three function kinds available in the definitions section:

`pure` — side-effect free functions (can call `pure`/`tail` only)

`tail` — tail-recursive, side-effect free (optimized for recursion, can call `pure`/`tail` only)

`side` — functions that may perform side effects (I/O, randomness, state); can call any function kind

### 2.1 Example:

```
type Point
  x int
  y int

pure greet(name string): string
  'Hello, ' + name

tail sumList(l List<int>, acc int): int
  length(l) == 0
    acc
  _
    self(tail(l), acc + head(l))

side logMessage(msg string)
  print('[LOG] ' + msg)
```

Notes:

* `pure` and `tail` functions are deterministic and cannot call `side` functions.


* `side` functions run in the runtime and may call `pure`, `tail`, and other `side` functions.

## 3. Top-Level Expressions

Expressions that are executed immediately when the file is compiled into a program.

Top-level expressions may call side functions directly.

### 3.1 Example:

```
print('Starting program...')
logMessage('Program is starting...')
exit(program(getCommandLineArguments()))
```

If a file contains top-level expressions, it is compiled into an executable program.

Top-level expressions run in the runtime, so side functions are available here.

## 4. Compilation Rules

Compile any .fun file using:

`purefun myfile.fun`

All `.fun` files imported by `myfile.fun` are included in the binary.

Only the top-level expressions in `myfile.fun` are executed; top-level expressions in imported files are ignored.

This allows you to put tests in the top-level expressions of library files, then compile the library itself to run its tests without affecting other programs.
