import gg
import gx
import os
import datatypes
import math

import guts
import shr

const grid_gray = gx.Color{
    r: 50, 
    g: 50, 
    b: 50,
}

const axis_gray = gx.Color{
    r: 80, 
    g: 80, 
    b: 80,
}

enum Font_Size {
    small
    regular
}

struct App {
mut:
    gg            &gg.Context = unsafe { nil }
    state         guts.State = .waiting
    em_size       int
    scale         int
    height        int
    width         int
    screen_height int
    screen_width  int
    data          []string
    cur_index     int
    rope          [][]int
    rope_size     int
    tails         datatypes.Set[string]
    dist          int
    coord         string
    change        []int
    max_x         int
    min_x         int
    max_y         int
    min_y         int
}

fn (app &App) scale(val int) int {
    return guts.padded(val * app.scale)
}

fn (app &App) plot_x(x int) int {
    return app.scale(x - app.min_x)
}

fn (app &App) plot_y(y int) int {
    return app.scale(app.max_y - y)
}

fn (app &App) in_bounds(x int, y int) bool {
    return app.min_x <= x && x <= app.max_x && app.min_y <= y && y <= app.max_y
}

fn (app &App) font(size Font_Size) gx.TextCfg {
    return gx.TextCfg{ color: gx.white, size: app.font_size(size) }
}

fn (app &App) font_size(size Font_Size) int {
    return match size {
        .small { app.em_size / 60 }
        .regular { app.em_size / 30 }
    }
}

fn (mut app App) update() {
    if app.state != .running {
        return
    }
    if app.dist == 0 {
        if app.cur_index == app.data.len {
            app.state = .done
            return
        }
        // we read a new line
        move := app.data[app.cur_index].split(' ')
        coord := move[0][0]
        app.coord = move[0]
        app.change = shr.changes[coord]
        app.dist = move[1].int()
        app.cur_index++
    }

    mut min_x := math.max_i32
    mut min_y := math.max_i32
    mut max_x := 0
    mut max_y := 0

    app.rope[0][app.change[0]] += app.change[1]

    if app.rope[0][0] > max_x {
        max_x = app.rope[0][0]
    }

    if app.rope[0][1] > max_y {
        max_y = app.rope[0][1]
    }

    if app.rope[0][0] < min_x {
        min_x = app.rope[0][0]
    }

    if app.rope[0][1] < min_y {
        min_y = app.rope[0][1]
    }

    for i in 1 .. app.rope.len {
        app.rope[i] = shr.adj_t(app.rope[i-1], app.rope[i])
        // if app.rope[i][0] > max_x {
        //     max_x = app.rope[i][0]
        // }

        // if app.rope[i][1] > max_y {
        //     max_y = app.rope[i][1]
        // }

        // if app.rope[i][0] < min_x {
        //     min_x = app.rope[i][0]
        // }

        // if app.rope[i][1] < min_y {
        //     min_y = app.rope[i][1]
        // }
    }
    t_key := '${app.rope[app.rope.len - 1]}'
    
    if !app.tails.exists(t_key) {
        app.tails.add(t_key)
    }

    app.update_bounds(min_x, min_y, max_x, max_y)
    app.dist --
}

fn (mut app App) reset() {
    app.update_max(app.width / 2, app.height * 3 / 4)
    app.cur_index = 0
    app.rope = [][]int {len: app.rope_size, init:[0, 0]}
    app.tails = datatypes.Set[string]{}    
    app.dist = 0
}

fn (mut app App) on_key_handler(key gg.KeyCode) {
    if key == .enter {
        // println("Enter: ${app.state}")
        if app.state == .done {
            app.reset()
        }
        app.state = match app.state {
            .waiting { .running }
            .running { .waiting }
            .done    { .waiting }
        }
    }
}

fn (mut app App) update_max(x int, y int) {
    app.max_x = x
    app.max_y = y
    app.min_x = x - app.width
    app.min_y = y - app.height
}

fn (mut app App) update_bounds(min_x int, min_y int, max_x int, max_y int) {
    if min_x < app.min_x + 2 {
        app.min_x = min_x - 2
        app.max_x = app.min_x + app.width
    } else if min_y < app.min_y + 2 {
        app.min_y = min_y - 2
        app.max_y = app.min_y + app.height
    } else if max_x > app.max_x - 2 {
        app.max_x = max_x + 2
        app.min_x = app.max_x - app.width
    } else if max_y > app.max_y - 2 {
        app.max_y = max_y + 2
        app.min_y = app.max_y - app.height
    }
}

fn (app &App) draw_grid() {
    for x in 0 .. app.width {
        for y in 0 .. app.height {
            app.gg.draw_rect_empty(app.scale(x), app.scale(y), app.scale, app.scale, grid_gray)
        }
    }
    // put coords in all 4 corners
    app.gg.draw_text(app.scale(0) + 5, app.scale(0) + 5, '(${app.min_x}, ${app.max_y})', app.font(.small))
    app.gg.draw_text(app.scale(app.width) - 50, app.scale(0) + 5, '(${app.max_x}, ${app.max_y})', app.font(.small))
    app.gg.draw_text(app.scale(0) + 5, app.scale(app.height) - app.font_size(.small) - 5, '(${app.min_x}, ${app.min_y})', app.font(.small))
    app.gg.draw_text(app.scale(app.width) - 50, app.scale(app.height) - app.font_size(.small) - 5, '(${app.max_x}, ${app.min_y})', app.font(.small))
}

fn (app &App) draw_axis() {
    // X AXIS
    if app.min_y <= 0 && 0 <= app.max_y {
        oy := app.plot_y(0)
        app.gg.draw_line(app.scale(0), oy - 1, app.scale(app.width), oy - 1, axis_gray)
        app.gg.draw_line(app.scale(0), oy + 0, app.scale(app.width), oy + 0, axis_gray)
        app.gg.draw_line(app.scale(0), oy + 1, app.scale(app.width), oy + 1, axis_gray)
    }

    // Y AXIS
    if app.min_x <= 0 && 0 <= app.max_x {
        ox := app.plot_x(0)
        app.gg.draw_line(ox - 1, app.scale(0), ox - 1, app.scale(app.height), axis_gray)
        app.gg.draw_line(ox + 0, app.scale(0), ox + 0, app.scale(app.height), axis_gray)
        app.gg.draw_line(ox + 1, app.scale(0), ox + 1, app.scale(app.height), axis_gray)
    }
}

fn (app &App) draw_rope() {
    for i in 1 .. app.rope.len {
        app.gg.draw_circle_filled(app.plot_x(app.rope[app.rope.len - i][0]), app.plot_y(app.rope[app.rope.len - i][1]), 5, gx.gray)
    }
    app.gg.draw_circle_filled(app.plot_x(app.rope[0][0]), app.plot_y(app.rope[0][1]), 5, gx.orange)
    app.gg.draw_text(app.plot_x(app.rope[0][0]) + 5, app.plot_y(app.rope[0][1]) - app.font_size(.small) - 5, '(${app.rope[0][0]}, ${app.rope[0][1]})', app.font(.small))
}

fn (app &App) draw_tails() {
    for i, _ in app.tails.elements {
        coord := i[1..i.len-1].split(', ')
        x := coord[0].int()
        y := coord[1].int()
        if app.in_bounds(x, y) {
            app.gg.draw_circle_filled(app.plot_x(x), app.plot_y(y), 5, gx.yellow)
        }
    }
}

fn main() {
    // lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    lines := os.read_lines('visualization.txt') or { panic(err) }
    
    height := 40
    width := 40

    scale, screen_height, screen_width, em_size := guts.screen_metrics(height, width)

    println("scale: ${scale}, screen_height: ${screen_height}, screen_width: ${screen_width}, em_size: ${em_size}")

    mut app := &App{
        gg: 0
        em_size: em_size 
        scale: scale
        height: height
        width: width
        screen_height: screen_height
        screen_width: screen_width
        data: lines
        rope_size: 10
    }
    app.reset()
    app.gg = gg.new_context(
        bg_color: gx.black
        width: screen_width + 300
        height: screen_height
        create_window: true
        window_title: 'Day 9: Rope Bridge'
        frame_fn: frame
        event_fn: on_event
        user_data: app
    )
    app.gg.run()
}

fn on_event(e &gg.Event, mut app &App) {
    if e.typ == .key_down {
        app.on_key_handler(e.key_code)
    }
}

fn frame(mut app &App) {
    app.gg.begin()
    if app.gg.frame % 3 == 0 {
        app.update()
    }
    app.draw_grid()
    app.draw_axis()
    app.draw_tails()
    app.draw_rope()
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 0), 'State: ${app.state}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 1), 'Instructions: ${app.cur_index} / ${app.data.len}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 2), 'Current: ${app.coord} ${app.dist}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 3), 'Tails visited: ${app.tails.size()}', app.font(.regular))
    app.gg.end()

}
