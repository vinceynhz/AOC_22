# Notes

This one was approached using the whole input file as a matrix of characters (or as an array of strings, semantics). 

Part one is a count of visible cells (trees) from the outer scope. The way I approached it was to do assume the tree was visible from all sides, and then check from that tree to the border on all four cardinal directions to find a taller tree. Which would mean that the tree is not visible from that direction:

```
+---------------------+
|          ^          |
|          |          |
|          ⁞          |
| <--- ... T ... ---> |
|          ⁞          |
|          |          |
|          v          |
+---------------------+
```

The problem with this approach though is that you have to check all four sides before deciding. If the logic is reversed and we assume that no tree is visible, we do the same iterations but we stop as soon as we find one path clear to the edge.

Part two did require to loop over each direction for each node. During discussion a colleague suggested taking advantage of language built in utilities.

For example in V we could use [`arrays.index_of_first`](https://modules.vlang.io/arrays.html#index_of_first) and use a simple function to find the first one which value is larger than the current one. However, even if our code is not doing the loops by hand, the language _will_ do them behind the scenes.

The matter of interest is how to keep the memory usage at a minimum. With manually doing all counting/sums/loops by hand we are making sure no unnecessary copies of data are being created. Slices as defined in [V](https://github.com/vlang/v/blob/master/doc/docs.md#array-slices) or [Rust](https://doc.rust-lang.org/std/primitive.slice.html) could be beneficial since we won't actually copy the data over and we won't modify it while searching. 

However this may work for horizontal directions, we don't have an easy way to grab slices over vertical locations that would not create a new array. Another colleague suggested using a column-wise matrix. So it would depend if the language supports a reference-based copy of the transposed matrix, or if you would end up with two copies of the matrix (which memory size and space will become important in the following days).

---

From the continued conversation with my coworkers, Haskell seems a powerful proponent for this kind of problems where matrix data is available and matrix operations are needed.

We discuss using some other constructs that in theory simplify the coding, but in the runtime it may not be as efficient. Like everything else in software development, it's a trade-off. 

What I've learned over the years is that the industry values efficient code insofar as it can find/replace people easily to maintain it. A superbly understood code that is reduced and efficientized to the point that it becomes more or less esoteric (for example [this mathematical way to calculate the result of a rock-paper-scissors game](https://github.com/vinceynhz/AOC_22/tree/main/02)), is less desirable than a full-fledged explanation even at the cost of performance.

* Runs fast but it takes time to learn/understand how to change it or fix it? No.
* Runs not as fast but anyone can pick it up very quickly? Yes, please.

Thus that this kind of problems are great to attack the downfalls from this seeming trade-off: on one hand, exercise abstract thinking, helping every person solving these challenges to keep that set of mental skills sharp; on the other hand, to actually keep considering efficient performant code, after a while, efficiency and performance is given up because the industry demands so, and it's quite easy to become complacent with our own code.

Finally, the same conversation introduced the topic of AIs for software development. The initial thought is of course one of wariness: "an AI could replace us".

Oooohh! But here's some questions, does the use of those tools give us any understanding of the problem? Can we build upon it on creative ways to keep furthering what engineering/software can be? [Are we heading to Geordie LaForge from Star Trek TNG, or to Wall-E](https://www.youtube.com/watch?v=48mf2QUtUmg)?

---

For the graphic part. I'm using V's gg module to handle that part.

The data is a matrix, so the first part is to calculate the scale for each position of the matrix from a predefined max width, and the size of the input data.

On this problem in particular the value of each cell in the matrix is a number `0-9` which then I use to calculate the light value of an HSL color that then is converted to RGB for final render in the screen.

The HSL -> RGB conversion I took shamelessly from the [w3schools on HSL Colors page](https://www.w3schools.com/colors/colors_hsl.asp) porting the code from JS to V.

I created a reduced version of my input data for the purposes of sharing the visualization code and the final video of its running. I have part one so far and I will update part two as soon as I have it. 



