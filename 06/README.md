# Notes

Oh yeah! The communication system! I took this one as a sliding window, I think this is the first time I do one of those.

But basically you have to keep track of `N` values (where `N` is the window size), that get updated every item but also reset every `N`th item, and have a hook for the moment the window is about to close (i.e. about to reset a value)

In this case the window update only happened if the new value wasn't there already, and the hook was to check for the window that had exactly `N` length.

Since a repeated character will not get inserted, that will guarantee that only the unique window will have the right length.

Parameterizing that to allow for different `N` and that was it for both parts. I'm curious to see how others approached it :monocle_face:
