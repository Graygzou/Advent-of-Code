# Advent-of-Code-2018

You can find below a summary of all the strategies I used to resolve each day.

### --- Day 9: Marble Mania ---

### --- Day 10: The Stars Align ---
- Study the **bounding box** that includes all points and apply velocities on each points until the bounding box reaches his minimal area (i.e. it start expanding either vertically or horizontally).

### --- Day 11: Chronal Charge ---
- Used the [Memoization](https://en.wikipedia.org/wiki/Memoization) principle : Usage of a **lookup table** to avoid re-computing values when iterating.

- *Alternative solution :* Can use a [Summed-area table](https://en.wikipedia.org/wiki/Summed-area_table) to avoid computing rectangle area > 1 "from scratch". With this method, rectangle areas can be computed with only 4 array references regardless of the area size.
 
### --- Day 12: Subterranean Sustainability ---
- Decided to work with string in order to extends/reduce the state easily and avoid dealing with dynamic arrays.
- Wrote a custom **string pattern matching** function in order to apply each rules directly on the current state (*string.gsub* function doesn't recognize overlapping patterns in string : [link](https://stackoverflow.com/questions/3952360/n-digit-pattern-matching-in-lua))

### --- Day 13: Mine Cart Madness ---
