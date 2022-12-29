import gg
import gx
import os

import guts
import shr

fn generate_swatch(val int) gx.Color {
    // h := rand.int_in_range(0, 360) or { panic("Unable to generate swatch") }
    l := (val * 9) / f32(100)
    return guts.hsl_to_rgb(109, 1, l)
}

struct App {
mut:
    gg            &gg.Context = unsafe { nil }
    state         guts.State = .waiting
    font_cfg      gx.TextCfg
    scale         int
    height        int
    width         int
    screen_height int
    screen_width  int
    font_size     int
    data          []string
    visible       [][]bool
    max_score     int
    max_score_row int
    max_score_col int
    cur_count     int
    cur_row       int
    cur_col       int
}

fn (app &App) scale(val int) int {
    return guts.padded(val * app.scale)
}

fn (app &App) draw() {
    for i in 0 .. app.height {
        for j in 0 .. app.width {
            val := app.data[i][j] - 0x30
            color := if app.visible[i][j] { generate_swatch(val) } else { gx.black }
            app.gg.draw_rect_filled(app.scale(j), app.scale(i), app.scale - 1, app.scale - 1, color)
        }
    }
    if app.cur_col < app.width && app.cur_row < app.height {
        app.gg.draw_rect_empty(app.scale(app.cur_col), app.scale(app.cur_row), app.scale, app.scale, gx.red)
    }
    app.gg.draw_rect_empty(app.scale(app.max_score_col) - 0, app.scale(app.max_score_row) - 0, app.scale, app.scale, gx.orange)
    app.gg.draw_rect_empty(app.scale(app.max_score_col) - 1, app.scale(app.max_score_row) - 1, app.scale + 2, app.scale + 2, gx.orange)
}

fn (mut app App) update() {
    if app.state != .running {
        return
    }

    visible, score := shr.visibility(app.data, app.cur_row, app.cur_col)

    if visible {
        app.cur_count++
    } else {
        app.visible[app.cur_row][app.cur_col] = false
    }

    if score > app.max_score {
        app.max_score = score
        app.max_score_row = app.cur_row
        app.max_score_col = app.cur_col
    }

    app.cur_col += 1
    if app.cur_col % app.width == 0 {
        app.cur_col = 0
        app.cur_row++
    }
    if app.cur_row > 0 && app.cur_row % app.height == 0 {
        app.state = .done
    }
}

fn (mut app App) reset() {
    app.cur_col = 1
    app.cur_row = 1
    app.cur_count = app.height * 2 + (app.width - 2) * 2
    app.visible = [][]bool{len:app.height, init:[]bool{len:app.width, init:true}}
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

fn main() {
    // lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    lines := os.read_lines('visualization.txt') or { panic(err) }

    height := lines.len
    width := lines[0].len

    scale, screen_height, screen_width, em_size := guts.screen_metrics(height, width)

    mut app := &App{
        gg: 0
        scale: scale
        height: height
        width: width
        screen_height: screen_height
        screen_width: screen_width
        font_size: em_size/30
        font_cfg: gx.TextCfg{ color: gx.white, size: em_size/30 }
        data: lines
        visible: [][]bool{len: height, init:[]bool{len:width, init:true}}
    }
    app.gg = gg.new_context(
        bg_color: gx.black
        width: screen_width + 400
        height: screen_height
        create_window: true
        window_title: 'Day 8: Treetop Tree House'
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
    app.update()
    app.draw()
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size * 0), 'Current: (${app.cur_col}, ${app.cur_row})', app.font_cfg)
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size * 1), 'State: ${app.state}', app.font_cfg)
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size * 2), 'Visible: ${app.cur_count}', app.font_cfg)
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size * 3), 'Max Score: ${app.max_score} @ (${app.max_score_col}, ${app.max_score_row})', app.font_cfg)
    app.gg.end()
}
