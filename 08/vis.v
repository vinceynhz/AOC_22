import gg
import gx
import math
import os

const (
    win_width  = 900
    padding = 10
)

fn hsl_to_rgb(_hue int, sat f32, light f32) gx.Color {
    mut hue := _hue / f32(60)
    mut t2 := f32(0)

    if light <= 0.5  {
        t2 = light * (sat + 1)
    } else {
        t2 = light + sat - (light * sat)
    }

    t1 := light * 2 - t2
    return gx.Color {
        r: u8(hue_to_rgb(t1, t2, hue + 2) * 255)
        g: u8(hue_to_rgb(t1, t2, hue    ) * 255)
        b: u8(hue_to_rgb(t1, t2, hue - 2) * 255)
    }
}

fn hue_to_rgb(t1 f32, t2 f32, _hue f32) f32 {
    mut hue := _hue
    if hue < 0 {
        hue += 6
    }
    if hue >= 6 {
        hue -= 6
    } 
    if hue < 1 {
        return (t2 - t1) * hue + t1
    } else if hue < 3 {
        return t2
    } else if hue < 4 {
        return (t2 - t1) * (4 - hue) + t1
    } 
    return t1
}

fn generate_swatch(val int) gx.Color {
    // h := rand.int_in_range(0, 360) or { panic("Unable to generate swatch") }
    l := (val * 9) / f32(100)
    return hsl_to_rgb(109, 1, l)
}

enum State {
    waiting
    running
    done
}

struct App {
mut:
    gg            &gg.Context = unsafe { nil }
    scale         int
    height        int
    width         int
    screen_height int
    screen_width  int
    font_size     int
    font_cfg      gx.TextCfg
    data          []string
    visible       [][]bool
    cur_count     int
    cur_row       int
    cur_col       int
    state         State = .waiting
}

fn (app &App) draw() {
    for i in 0 .. app.height {
        for j in 0 .. app.width {
            val := app.data[i][j] - 0x30
            color := if app.visible[i][j] { generate_swatch(val) } else { gx.white }
            app.gg.draw_rect_filled(j * app.scale + padding, i * app.scale + padding, app.scale - 1, app.scale - 1, color)
        }
    }
    app.gg.draw_rect_empty(app.cur_col * app.scale + padding , app.cur_row * app.scale + padding, app.scale, app.scale, gx.red)
}

fn (mut app App) update() {
    if app.state != .running {
        return
    }
    mut lv := true
    mut rv := true
    mut tv := true
    mut bv := true
    target := app.data[app.cur_row][app.cur_col]

    for ptr in 0 .. app.cur_col {
        // checking left side
        if app.data[app.cur_row][ptr] >= target {
            // found taller, not visible
            lv = false
        }
    }

    for ptr in app.cur_col + 1 .. app.width {
        // checking right side
        if app.data[app.cur_row][ptr] >= target {
            // found taller, not visible
            rv = false
        }
    }

    for ptr in 0 .. app.cur_row {
         // checking top side
        if app.data[ptr][app.cur_col] >= target {
            // found taller, not visible
            tv = false
        }   
    }

    for ptr in app.cur_row + 1 .. app.height {
         // checking bottom side
        if app.data[ptr][app.cur_col] >= target {
            // found taller, not visible
            bv = false
        }   
    }

    if lv || rv || tv || bv {
        // println('${i},${j} ${target.ascii_str()} - visible ${lv:-5} ${rv:-5} ${tv:-5} ${bv:-5}')
        app.cur_count++
    } else {
        app.visible[app.cur_row][app.cur_col] = false
        // println('${i},${j} ${target.ascii_str()} - not vbl ${lv:-5} ${rv:-5} ${tv:-5} ${bv:-5}')
    }

    app.cur_col+= 1
    if app.cur_col % (app.width - 1) == 0 {
        app.cur_col = 1
        app.cur_row++
    }
    if app.cur_row % (app.height - 1) == 0 {
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
        println("Enter: ${app.state}")
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

    mut scale := math.max(height, width)
    scale = (win_width - padding) / scale

    screen_width := scale * width + padding * 2
    screen_height := scale * height + padding * 2
    m := math.min(screen_height, screen_width)

    mut app := &App{
        gg: 0
        scale: scale
        height: height
        width: width
        screen_height: screen_height
        screen_width: screen_width
        font_size: m/10
        font_cfg: gx.TextCfg{ color: gx.black, size: m/30 }
        data: lines
        visible: [][]bool{len: height, init:[]bool{len:width, init:true}}
        cur_row: 1
        cur_col: 1
        cur_count: height * 2 + (width - 2) * 2

    }
    app.gg = gg.new_context(
        bg_color: gx.white
        width: screen_width + 200
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
    size := app.font_size / 3
    app.draw()
    app.gg.draw_text(app.screen_width + padding, padding, 'Part 1', app.font_cfg)
    app.gg.draw_text(app.screen_width + padding, padding + size, '(${app.cur_col}, ${app.cur_row})', app.font_cfg)
    app.gg.draw_text(app.screen_width + padding, padding + (2 * size), 'State: ${app.state}', app.font_cfg)
    app.gg.draw_text(app.screen_width + padding, padding + (3 * size), 'Visible: ${app.cur_count}', app.font_cfg)
    app.gg.end()
}
