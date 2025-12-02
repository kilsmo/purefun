# Functions on Types

## rect.fun example

This code demonstrates best practice for grouping a type with corresponding pure functions.
The top-level expressions section shows how to use the functions.

### Import Section

```
'fun/io'
  print
```
### Definitions Section

```
type Rect
  width int
  height int

pure area(r Rect): int
  r.width * r.height

pure perimeter(r Rect): int
  2 * (r.width + r.height)

pure scale(r Rect, factor int): Rect
  Rect(r.width * factor, r.height * factor)
```

### Top-Level Expressions Section (optional)

Executed if this file is compiled as a program.

Top-level expressions must be declared side if using side-effect functions like print.

```
side main()
  r = Rect(3, 2)
  print(area(r)) # 6
  print(perimeter(r)) # 10
  r2 = scale(r, 3)
  print(area(r2)) # 54

main()
```

## Using rect.fun from another file

## usingrect.fun

Import Section

```
'./rect.fun'
  area
  perimeter
  scale
  Rect

'fun/io'
  print
```

### Functions and types section (only function in this example)

```
side main()
  r = Rect(3, 2)
  print(area(r)) # 6
  print(perimeter(r)) # 10
  r2 = scale(r, 3)
  print(area(r2)) # 54
```

### Top-Level Expressions Section

```
main()
```

### Notes

Top-level expressions in imported files are ignored; only the main compiled file’s top-level expressions are executed.

Pure functions remain deterministic and side-effect free, while side functions execute in the runtime.

This keeps the Purefun style clear, emphasizes the side requirement for runtime operations, and clarifies the import behavior.

Another way to write the same example of the Top-level expression is:

```
r = Rect(3, 2)
print(area(r)) # 6
print(perimeter(r)) # 10
r2 = scale(r, 3)
print(area(r2)) # 54
```

For this example, this code would be preferred over
over creating a `main` function that is called from
the Top-level expressions section. (the code becomes
easier to read)
