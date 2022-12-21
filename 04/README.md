# Notes

I feel that this one was very straightforward with logic around the ranges since we had lower and upper boundaries. On this one I did end up jotting down a small design.

Being each line: `w-x,y-z`

```
a. No overlap on either side
           w    x y  z
1st range: [....]
2nd range:        [..]

           y  z   w    x
1st range:        [....]
2nd range: [..]
       
b. Overlap
           w   yx z
1st range: [....]
2nd range:     [..]

              y wz   x
1st range:      [....]
2nd range:    [..]

c. Contained
           wy  zx
1st range: [....]
2nd range:  [..]

            yw  xz
1st range:   [..]
2nd range:  [....]
```

And from there is just simple comparisons.

I have to admit that I messed up the second part once because I forgot to account for the upper boundaries when comparing the overlaps.

If you see, `y < w` is true in several cases:

* where there is no overlap
* when there is overlap on the left side
* when the first is contained on the second

```
           y  z   w    x
1st range:        [....]
2nd range: [..]

              y wz   x
1st range:      [....]
2nd range:    [..]

            yw  xz
1st range:   [..]
2nd range:  [....]
```