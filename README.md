# Advent-of-Code-2018
Advent of Code 2018

### --- Day 11: Chronal Charge ---
- Used the [Memoization](https://en.wikipedia.org/wiki/Memoization) principle : Usage of a look-up table to avoid re-computing values when iterating.

### --- Day 12: Subterranean Sustainability ---
- Decided to work with string in order to extends/reduce the state easily and avoid dealing with dynamic arrays.
- Wrote a custom string pattern matching function in order to apply each rules directly on the current state (*string.gsub* function doesn't recognize overlapping patterns in string)
