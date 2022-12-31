# Notes

This one I feel that the core was to understand the change in position of the head and then the distance to the tail.

The way I did it was to consider the position of the head as x,y and based on the instruction decide how that position would change:

* up: x, y-1
* down: x, y+1
* left: x-1, y
* right: x+1, y

Then calculate the adjustment to the next knot (in the first part just the tail, in the second part an iteration we'll discuss) after each step on the instruction (U 5, would have 5 steps up).

In pseudo code (my computer is elsewhere), it'd be something like this:

```
input h, t
diff_x = h.x - t.x
diff_y = h.y - t.y
if abs(diff_x) > 1 then
   // For any h, it can be 0, 1, and 2 spaces apart
   // from t, thus that we need to reduce that
   // distance by 1 based on the sign
   t.x += sign(diff_x)
if abs(diff_y) > 1 then
   t.y += sign(diff_y)
output t
```

And this can be used to update t after every new position of h:


```
for step in 0..steps 
   h = move(h, direction)
   t = adjust(h, t)
```

But this still has a catch, the diagonal adjustment. Let's consider this initial state:

```
...
...
.TH
```
And the instruction is to move up 2 steps:

```
Step 1
  move h up
...
..H
.T.
  adjust t (no change since it's still close to h)

Step 2
  move h up
..H
...
.T.
  adjust t (the adjustment is wrong)
..H       ..H
.T.  ---> ..T
...       ...
```

The way it is right now it will only push t up because the difference between x positions is still 1 which is valid. What we need to do is check the other position as well

```
input h, t
 diff_x = h.x - t.x
 diff_y = h.y - t.y
 if abs(diff_x) > 1 then
    // adjust diagonally if needed
    if h.y != t.y 
        t.y = sign(diff_y)
        // recalculate diff y!!!
        diff_y = h.y - t.y
    t.x += sign(diff_x)
 if abs(diff_y) > 1 then
    // adjust diagonally if needed, no need to
    // recalculate as we already move
    if h.x != t.x
        t.x = sign(diff_x)
    t.y += sign(diff_y)
 output t
```

The recalculation of the difference in y is not really needed in the first part because there is no way to get that far between the head and the tail. But let's look at the second part.

As it is, the same adjustment can now be used for any arbitrary length of rope (being the index 0 the head):

```
for step in 0..steps 
   rope[0] = move(rope[0], direction)
   for i in 0..knots
     rope[i] = adjust(rope[i-1], rope[i])
```

After certain motions let's say we have this state

```
.....
.....
....0
.321.
4....
```

If the head is moved up and up to knot 3

```
.....
....0
....1
..32.
4....
```

If we see, here is where the diagonal adjustment needs to recalculate because now 3 is in position 2,2 and 4 is in 0,0. You can verify that in your local without the adjustment and with the adjustment.

---

The challenge of the graphic part was the cartesian grid and the boundaries of what could be shown. The trick for me was the remapping of the coordinates for visual representation.

At the beginning of my analysis I put how `up` **decreases** `y` by one, while `down` **increases** `y` by one. This has to dow with the row/col system I had been handling up to now. Which in fact also corresponds to the way a screen draws `x, y` coordinates. For instance, `0, 0` is the top-left position of the window while `m, n` is `m` pixels right from the left border, and `n` pixels down from the top border.

```
(0, 0) ---- x axis ----> (m, 0)
  |                        |
  |                        |
  |                        |
  |                        |
y axis                   y axis
  |                        |
  |                        |
  |                        |
  v                        v
(0, n) ---- x axis ----> (m, n)
```


In the cartesian grid however, while the `x` axis remains the same (growing to the _right_), larger values in the `y` axis go _up_ instead of _down_:

```
(-m, n)                    (0, n)                   (m, n)
                              |
                              |
                              |
                            y axis
                              |
                              |
                              |
                              |
(-m, 0) <---- -x axis ---- (0, 0) ---- x axis ----> (m, 0)
                              |
                              |
                              |
                              |
                           -y axis
                              |
                              |
                              |
(-m, -n)                   (0, -n)                  (m, -n)
```

So I needed to solve that translation in addition to the partial view of the virtually infinite cartesian grid.

The first step was to assume that my _view_ in the screen is described by a minimum and a maximum in `x` and `y`. In the diagram above these values are:

* `-m` on the minimum x
* `-n` on the minimum y
* `m`  on the maximum x
* `n`  on the maximum y

Creating a correspondence between my intended cartesian coordinate as mapped to my screen coordinates:

```
Cartesian (x, y) |  Screen (i, j)
(-m,  n)         =  (0, 0)
( m,  n)         =  (m, 0)
(-m, -n)         =  (0, n)
( m, -n)         =  (m, n)
```

From which it is easy to see that for any cartesian coordinate `x, y` the corresponding `i, j` screen coordinate is determined by:

```
i = x - min_x
j = max_y - y
```

Let's apply it to our input coordinates:

```
Cartesian (-m, n)
x = -m, min_x = -m
y = n,  max_y = n

i = x - min_x
i = -m - (-m)
i = 0

j = max_y - y
j = n - n
j = 0

--> Screen (0, 0)
```

Another example:

```
Cartesian (0, 0)

x = 0, min_x = -m
y = 0, max_y = n

i = x - min_x
i = 0 - (-m)
i = m

j = max_y - y
j = n - 0
j = n

--> Screen (m, n)
```

With that we can map any position of the rope into the screen coordinates. 

Finally the update of the view of the screen. Every time I calculated a new position of the rope's head I checked if the new position was within 2 units from any of the boundaries, and if so, I would readjust my boundaries.

For example:

```
(-5, 5)                    (0, 5)                   (5, 5)
                              |
                              |        H = (2, 4)
                              |
                            y axis
                              |
                              |
                              |
                              |
(-5, 0) <---- -x axis ---- (0, 0) ---- x axis ----> (5, 0)
                              |
                              |
                              |
                              |
                           -y axis
                              |
                              |
                              |
(-5, -5)                   (0, -5)                  (5, -5)
```

In this situation, the head is located at `(2, 4)` after take a step. Since the `y` position is located within the 2 from the `max_y` bound `5`, so we need to update the `max_y` to `7`. Which means that the `min_y` should be now `-3` pushing our view _up_ by `2` units.