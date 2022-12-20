# Notes

On this one, the key lies in array and string manipulations, very straightforward.

For part one I just split the string in half and looped the second half until I found the repeated character. 

In python you can build a set for the first half to make each search O(1), which probably makes each line O(N) where N is the half length of the line. Not doing so, makes each line O(N^2) since it has to iterate each character on the second half against all characters on ther first half. For this puzzle complexity is not a big deal since the data is very small and modern day processors are relatively fast.

> Revisiting this note on Day 20 of the challenge... Foreshadowing myself: yep, complexity is a factor.

For part two, grab three lines and use the largest one to find the repeated character in the other two. Trying to prevent as many `if...else` blocks, I decided to do a small logic on indexes to know which one was the longest of the three, but nothing too crazy. 

Again, sets could be used on all three to find the unique values and reduce the search, in fact if you can do set operations, a simple intersection should yield the repeated character. The factor for the efficientization of this puzzle is the cost of building a set, in comparison to the relatively small data sets.

The scoring part I did using the same ASCII inherent values used on [Day 2](https://github.com/vinceynhz/AOC_22/tree/main/02) plus some offset. +1 in the lower cases, +27 in the upper cases.
