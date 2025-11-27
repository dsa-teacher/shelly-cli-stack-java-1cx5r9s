# Stack Implementation Hints

## General Approach
- A stack follows Last-In-First-Out (LIFO) principle
- Elements are added and removed from the same end (top)

## Sub-Challenge 1: Create Class
**Hint:** Define your data structure. Arrays/Lists work great for stacks.

**Common approaches:** Array, Dynamic Array, or Linked List

## Sub-Challenge 2: Push
**Hint:** Add to the top/end of your storage.

**Think about:** This should be a simple append operation.

## Sub-Challenge 3: Pop
**Hint:** Remove and return the top/last element.

**Edge case:** What should happen if the stack is empty?

## Sub-Challenge 4: Peek
**Hint:** Return the top element without removing it.

**Think about:** Similar to pop, but don't modify the stack.

**Edge case:** Handle empty stack appropriately.

## Sub-Challenge 5: Size
**Hint:** Return the count of elements currently in the stack.

**Think about:** Track this as you add/remove elements.

## Common Pitfalls
- Handling empty stack edge cases
- Modifying state during peek (peek should not remove!)
- Off-by-one errors with array indices

## Test Independence
Each challenge tests only its specific functionality:
- Challenge 1 (Create Class) tests basic instantiation
- Challenge 2 (Push) tests adding elements
- Challenge 3 (Pop) tests removing elements and verifies LIFO order
- Challenge 4 (Peek) tests viewing top without removal
- Challenge 5 (Size) tests element counting

**Recommendation:** Implement in order, as later challenges may use earlier methods.
