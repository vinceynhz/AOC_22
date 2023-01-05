# Notes

The algorithm for this one did not have a lot of complexity other than understanding the moment in which the instructions are applied in relationship to the cycle.

Part two of this challenge required to output the simulation of the CRT to the command line (or any other similar media) to get the actual result. So in this case we needed to simulate not just the position of the sprite but the matching of the pixel being rendered against the sprite. 

Limiting the string to the CRT width is easily done with a mod operation over the cycle counter, and then just check if the cycle is within the boundaries of the sprite position. If so, render a `#` else just a space `.` to a string. At the end of a row (when the mod gives us 0) we print that string and clean it for the next row.

---

For the graphical part, I wanted the visualization to show the current position of the sprite, the current row being printed and the pixel being handled. Up to the point in which this visualization was created, I have built a set of good utilities to simplify rendering this matrix-like type of data in the screen so all of these tasks are quite straightforward.

I wanted to have a different input data than the one in the challenge because the visualization _is_ the result and I wouldn't want to give anything away. So I started writing a modified input that would render the following:

```
.##........##........##...##...##...##..
#..#......#..#......#..#.#..#.#..#.#..#.
####..##..#............#.#..#....#....#.
#..#.#..#.#....####...#..#..#...#....#..
#..#.#..#.#..#.......#...#..#..#....#...
#..#..##...##.......####..##..####.####.
```

I started with the command line version but I wasn't able to imagine the position of the sprite accurately on my mind to correctly add the instructions so I had to have the visualization before my visualization data :upside_down_face:

The biggest difference between the visualization and the command line version is that in the command line I printed each row as it was being completed so did not have to keep track of which "pixels" needed to be printed, whereas in the visualization, it was needed to store them for the graphics engine to render them at every cycle. A simple set did the job.

In this case the set corresponds to my "video memory" which pixels are on at any given moment... How in the world that actually works on a real device? I started watching the video linked in the AoC puzzle and it certainly is a feat of coding and enginnering to be able to synchonize the light beam and the machine cycles... 

While I was building my visualization input and as I was manually calculating the noops position of the sprite, the rows that I already had calculated were going slow and also I was constantly modifying the input, so I added some more keyboard events. 

I coded that letter <kbd>r</kbd> would reload the file and reset all values to start over (I guess I could just reload the file and continue from where we are). Then coded that letter <kbd>f</kbd> would run the simulation _fast_, while <kbd>s</kbd> would run it _slow_.

All of this was quite fun to play with. I am interested into try to add animations next.
