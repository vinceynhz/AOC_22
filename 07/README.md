# Notes

On this one I ended up doing a small tree, with a very simplistic approach.

Each node is a directory and has: name, size, an array of subdirectories, and an optional link to the parent. Optional because the root dir (`/`) doesn't have a parent.

Depending on the language, you can declare the parent as a reference. At the moment I was working on this challenge, I did not know how to declare a non initialized reference in V, which was a bit of a pain. Later, after I finished the exercise in pythong, I figured how to do it and finished my code in V. 

Building the actual structure was very straightforward. Create a root node without any size and without any subdirs and without a parent. Have another reference to the current directory (think of the ouput of `pwd` in unix/linux) and go through all the commands.

If a change of directory (`cd`) just update the current directory reference either with the root directory (`/`), with the parent directory from the current one (`..`) or with one of the subdirectories by name. Potentially, the subdirs could have been a map to simplify access :thinking: (I implemented it this way later in V )

On the list of files I actually did nothing. Only when the line started with `dir` did I create a new directory in the current dir. Else I added the files size to the current directories size.

For the calculation of the sizes I did a recursive stuff once I had all the file structure built. In my python version this was done every time, but in V I did the calculation once and reused the value for both parts of the problem.

For the second part I calculated the space needed from the input data, and then walked the whole file system collecting all sizes that were >= than the space needed. Then just grabbed the minimum of those.
