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
1. + Add (appends on strings)

2. - Subtract (not available on strings)

3. * Multiply

4. / Division (always returns num)

5. // Int division (always returns int)

6. == returns true if two expressions are equal

7. != returns true if two expressions are not equal

8. && returns true if both expressions return true, don't evaluate the right expression if the left expression is false.

9. || returns true if at least one of the expressions return true, don't evaluate the right expression if the left expression is true.

```
