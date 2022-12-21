# Notes

This one was fun! Those stacks where fun to deal with. As we have mentioned before, the input is very, very forgiving, in this one you know before hand how many stacks you'll need.

Depending on which programming language you used, you may have stacks out of the box, or stack-like constructs. Although arrays and slices would also work fine. Java has Deques (Double Ended Queues), python has slices and no apparent regard for memory and V has a good abstraction for arrays and memory.

The input was fairly straightforward, if there is a `[` you have a stack line, if starts with `move` you have an instruction.

The catch was to create those first arrays/stacks/queues, and insert elements in such a way that the pops later would work fine. 

For the reading of a stack line, I used some forgiving details on the input so I could read a whole line and assign to the stacks with index `0 .. 9`, the character at `(index * 4) + 1`.

The moving on part one was fairly easy, just append at the end the one you took from the end of the other one.

The part two was also direct with the slices.

I did this one in python first and then I translated it to V
