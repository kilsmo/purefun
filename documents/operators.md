# Operators

* All operators are **binary**

* All operators are **infix**

* All operators are **left-associative**

*  Operators have **fixed precedence levels** (higher binds tighter):

```
Level 6: ( )               grouping

Level 5: * / // %          multiplicative

Level 4: + -               additive

Level 3: == != < > <= >=   equality, comparisons

Level 2: &&                logical AND

Level 1: ||                logical OR
```

## Operator table

```
1.  +  Add (appends on strings)

2.  -  Subtract (not available on strings)

3.  *  Multiply

4.  /  Division (always returns num)

5.  // Int division (trunkates, always returns int)

6.  %  Int modulo (trunkates, always returns int)

7.  == returns true if two expressions are equal

8.  != returns true if two expressions are not equal

9.  <  returns true if left expression is smaller than right expression

10. >  return true if left expression is bigger than right expression

11. <= returns true if left expression is smaller than or equal to the right expression

12. >= returns true if left expression is bigger than or equal to the right expression

13. && returns true if both expressions return true, don't evaluate the right expression if the left expression is false.

14. || returns true if at least one of the expressions return true, don't evaluate the right expression if the left expression is true.

```

## Examples

```
2 + 3 -> 5

3 - 1 -> 2

2.5 + 3.5 -> 6.0

1.0 + 3.0 -> 4.0

3 * 2 -> 6

4.0 * 2.5 -> 10.0

3 / 2 -> 1.5

3 // 2 -> 1

4 / 2 -> 2.0

4 // 2 -> 2

4.5 % 2.0 -> not allowed

3 % 2 -> 1

5 % 2 -> 1

3 == (2 + 1) -> true

3 == (2 + 2) -> false

3 != (2 + 1) -> false

3 != (2 + 2) -> true

2 < 3 -> true

2 < 2 -> false

2 <= 2 -> true

2 > 2 -> false

2 >= 2 -> true

2 > 1 && 3 > 2 -> true

2 > 1 && 3 > 3 -> false

2 > 1 || 2 > 3 -> true

2 > 1 || 3 > 2 -> true

2 < 1 || 3 < 2 -> false

2 * 3 + 4 -> 10

2 + 3 * 4 -> 14




