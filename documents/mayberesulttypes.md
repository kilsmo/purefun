# Maybe and Result Types

Purefun provides two fundamental generic types for representing optional and fallible computations in a pure way: `Maybe` and `Result`.

## 1. Maybe

The `Maybe` variant represents an optional value. It is used when a value may or may not be present, without involving side effects.

```
variant Maybe[T]
  Something(value T)
  Nothing()
```

`Something(value)` holds an existing value of `type` T.
'Nothing()' represents the absence of a value.

### 1.1 Example

```
pure findFirstEven(l List[int]): Maybe[int]
  length(l) == 0
    Nothing()
  head(l) % 2 == 0
    Something(head(l))
  _
    self(tail(l))

findFirstEven([1, 3, 4, 7])
  Something(v)
    print("First even: " + v)
  Nothing()
    print("No even number found")
```

This design eliminates the need for null values and keeps all control flow explicit and pure.

## 2. Result

The Result variant represents either `Success` or `Failure` of a computation, usually with additional information about the failure.

```
variant Result[T, E]
  Success(value T)
  Failure(error E)
```

`Success(value)` holds a successful result of `type` T.
`Failure(error)` carries information about what went wrong, often a `string`.

### 2.1 Example:

```
pure divide(a num, b num): Result[num, string]
  b == 0
    Failure('division by zero')
  _
    Success(a / b)

match divide(10, 0)
  Success(v)
    print("Result: " + v)
  Failure(msg)
    print("Error: " + msg)
```

## 3. Relationship between Maybe and Result

`Maybe` is a simplified version of `Result`, where failure carries no information beyond “nothing.”
You can think of `Maybe[T]` as equivalent to `Result[T, Unit]` with no payload for failure.

Both types encourage explicit handling of missing values or errors without side effects, aligning with Purefun’s philosophy of predictable, expression-based design.
