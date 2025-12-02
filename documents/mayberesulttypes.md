# Maybe and Result Types

Purefun provides two fundamental generic types for representing optional and fallible computations in a pure way: `Maybe` and `Result`.

## 1. Maybe

The `Maybe` type represents an optional value. It is used when a value may or may not be present, without involving side effects.

```
type Maybe[T]
  something(value T)
  nothing
```

`something(value)` holds an existing value of `type` T.
nothing represents the absence of a value.

### 1.1 Example

```
pure findFirstEven(l List[int]): Maybe[int]
  length(l) == 0
    nothing
  head(l) % 2 == 0
    something(head(l))
  _
    self(tail(l))

findFirstEven([1, 3, 4, 7])
  something(v)
    print("First even: " + v)
  nothing
    print("No even number found")
```

This design eliminates the need for null values and keeps all control flow explicit and pure.

## 2. Result

The Result type represents either `success` or `failure` of a computation, usually with additional information about the failure.

```
type Result[T, E]
  success(value T)
  failure(error E)
```

`success(value)` holds a successful result of `type` T.
`failure(error)` carries information about what went wrong, often a `string`.

### 2.1 Example:

```
pure divide(a num, b num): Result[num, string]
  b == 0
    failure("division by zero")
  _
    success(a / b)

match divide(10, 0)
  success(v)
    print("Result: " + v)
  failure(msg)
    print("Error: " + msg)
```

## 3. Relationship between Maybe and Result

`Maybe` is a simplified version of `Result`, where failure carries no information beyond “nothing.”
You can think of `Maybe[T]` as equivalent to `Result[T, Unit]` with no payload for failure.

Both types encourage explicit handling of missing values or errors without side effects, aligning with Purefun’s philosophy of predictable, expression-based design.

## 4. Naming and Style

The lowercase variant names (`something`, `nothing`, `success`, `failure`) follow Purefun’s convention:

* Types are capitalized (`Maybe`, `Result`).
* Constructors are lowercase, natural words.

This balance makes data flow readable and emphasizes the values themselves rather than syntax.
