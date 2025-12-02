# 📘 Purefun Import Specification

## 1. Overview

Purefun uses a string literal followed by an indented block to import functions and types from another module:

```
'<module-source>'
  <localName>
  <localPrefix>.<remoteName>
```

Each line inside the block describes one imported symbol and its local alias.

No keywords, no braces, no commas.

The indentation signals the import block.

## 2. Module Source Types

### 2.1 Local File Modules

Paths starting with `./` or `../` are local file modules.

Must include `.fun` extension.

Examples:

```
'./mathTools.fun'
'../utils/list.fun'
```

**Resolution:** relative to the importing file’s directory.

### 2.2 Standard Library Modules

Paths starting with fun/ are standard library modules.

No `.fun` extension needed.

Examples:

```
'fun/io'
  print
'fun/math'
  sin
  cos
'fun/string'
  revert
```

Resolution: built-in compiler modules; cannot be shadowed.

### 2.3 Package / Registry Modules (Future)

Paths of the form `<identifier>/<identifier>` refer to external packages.

Must **not** start with `./` or `fun/`.

Examples:

```
'json/codec'
'http/client'
'mycompany/tools'
```

## 3. Import Lines

Each indented line imports one symbol. This can be a **function or a type**.

### 3.1 Simple Import

`<name>`

Local name = `<name>`

Remote name = `<name>`

Example:

```
'fun/io'
  print
  readFile
```

Usage:

```
print("Hello")
readFile("file.txt")
```

### 3.2 Prefixed / Namespaced Import

`<prefix>.<remoteName>`

Local name = full prefix (e.g., `writer.Writer`)

Remote name = last identifier (after the dot)

Example:

```
'fun/io'
  writer.Writer
  reader.Reader
```

Usage:

```
w = writer.Writer()
r = reader.Reader()
```

### 3.3 Parsing Rules

For each import line:

```
if no dot:
    localName = line
    remoteName = line
else:
    split on last dot
    localName = line
    remoteName = last segment
```

**Remote names must be single identifiers** (no dots).

## 4. Naming Rules

* File names: `camelCase → mathTools.fun`

* Function names: `camelCase → addNumbers`

* Type names: `PascalCase → Writer, UserProfile`

* Import prefixes / namespaces: `camelCase → writer.Writer, json.decode`

## 5. Examples

### 5.1 Standard Library

```
'fun/io'
  print
  readFile
  writer.Writer
```

### 5.2 Local File

```
'./mathTools.fun'
  add
  algebra.sub
  matrix.Matrix
```

### 5.3 Package Module

```
'json/codec'
  decode
  encoder.Encoder
  pretty.format
```

## 6. Error Conditions

Compiler must report errors if:

1. Module source cannot be resolved.

2. Remote symbol does not exist.

3. Remote symbol contains a dot.

4. Two imports bind the same local name.

5. Circular imports exist.

6. Local or remote names are invalid identifiers.

7. Module path does not match one of the allowed forms.

## 7. Summary

* Minimal syntax: **string + indented list of symbols**

* Functions & types imported identically

* Dot used only to namespace / alias local names

* Clean, readable, no repetition, easy to parse

* Fully compatible with naming rules and Purefun style
