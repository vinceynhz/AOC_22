# AOC_22

Solutions to the Advent of Code 2022 and some notes from the challenges.

My goals for the challenge (as of day 5):

> See the whole challenge through all the stars, get that abstract thinking for algorithms well oiled, and practice the language. 
> I'm digesting rust so even if I don't get a chance to try it during the AoC, I'll definitely come back and solve them again with rust.

This is the first time I do the Advent of Code challenges and I had a blast.

In the words of a coworker who is also doing this challenge:

> This is to recover the habit of coding just for fun

I started the challenges in Python because of ease of use and my current familiarity with the language. However, as that same coworker mentioned, this is a good opportunity to exercise in soemthing different.

As such, I picked V - https://vlang.io

I originally got interested in V because it's called like my initial, then I started doing stuff with it in 2021 when I coded a command line based adventure game.

Like all languages it has it's own paradigms. For example, python requires you to have disciplined indentation. On V you have to think how you attack a problem given that the language is designed to be safe, so all variables are immutable by default. You can specify mutable ones, but even then, the "mutability" is strictly scoped and it doesn't carry if you were to pass the variable to another function for example.

In more recent times I have started reading Go and Rust who also have this aspect of immutability. But it certainly has given me a new tool under my belt.

Each day in this repo has a `sol.v` file with my implementation of the solution, in addition to a `README.md` file to describe the approach I took and some general conclusions from that day's challenge.

On the days where there is a visualization, that code is under `vis.v` and a small shared module `shr` to have the same code between the solution and the visualization. A make file is provided to build and compile all the dependencies and it runs as:

```shell
$ make sol
$ make vis
```

---

Starting with the challenges on Day 8, some of the problems had some visual quality to them. Which gave me the idea to code for that graphic part. For example on the one for the trees, display the trees with a different value of green depends on their heights, and maybe even run the algorithm to solve the problems in a visual manner.

The one with the rope even more visual, run the simulation of each movement visually. Still using V for the whole event, I'll attempt to do the graphics also with it. The language offers a [built-in module for simple-yet-powerful graphics](https://modules.vlang.io/gg.html). Where applicable I'll the graphic code as well as the visualization images.

There is also a shared module for graphic utilities (guts in its short name) which is imported by those days who have visualization.

Take a look, check my approaches, send me a note if you want to talk about your own approach!
