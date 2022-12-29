module shr

import math

pub const changes = {
    // >>> ord('R')    82
    // >>> ord('U')    85
    // >>> ord('D')    68
    // >>> ord('L')    76 
    82: [0, 1],
    76: [0, -1],
    85: [1, 1]
    68: [1, -1]
}

pub fn adj_t(h []int, t []int) []int {
    mut result := t.clone()
    dif_x := h[0] - t[0]
    mut dif_y := h[1] - t[1]

    if math.abs(dif_x) > 1 {
        if h[1] != result[1] {
            result[1] += math.signi(dif_y)
            // recalculate
            dif_y = h[1] - result[1]
        }
        result[0] += math.signi(dif_x)
    }


    if math.abs(dif_y) > 1 {
        if h[0] != result[0] {
            result[0] += math.signi(dif_x)
        }
        result[1] += math.signi(dif_y)
    }

    return result
}
