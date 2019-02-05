# Advent-of-Code-2018 in Lua

You can find below a summary of all the strategies I used to resolve each day. All my solutions are in Lua : it was a nice oppurtunity to learn this language from scratch !

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


### --- Day 20: A Regular Map ---
##### Part 1:
Found all possible "simple branch" which only contains directions (E,W,S,N). Solved the branch by choosing the biggest option and replace the branch by the solution inside the string. Did not include empty option in the process (I removed them from the string). Found another "simple branch" and repeat the process. This solution works because the final room isn't part of a empty option.
##### Part 2:
 - First approach : Converted all strings [A-Z] into number corresponding to the string length. The problem was : how to identify loops in empty option ? I had to post-process the string to divide the string length by 2 when finding empty option. But how to identify already opened doors ? I ended-up changing my approach.
 - Second approach : Mapped each letter (E,W,S,N) to the given direction (vector2). I put the starting point at (0,0). Then , I used a hashSet in order to register open doors (by sorting the origin and the destination based on their positions). I parsed the line from the beginning to the end in the reading order.
