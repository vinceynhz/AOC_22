module shr

// count, change
pub fn parse_ins(line string) (int, int) {
    if line[0] == 110 {
        // noop
        return 1, 0 
    } else {
        // addx
        ins := line.split(' ')[1].int()
        return 2, ins
    }
}