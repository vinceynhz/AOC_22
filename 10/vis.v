import guts
import shr 

import os
import gg
import gx
import datatypes

struct ModApp {
    guts.App
mut:
    speed      u64 = u64(3)
    data_path  string       
    data       []string
    sprite     int = 1
    cycle      int
    ip         int
    crt        datatypes.Set[string] = datatypes.Set[string]{}
    count      int
    change     int
}

fn (mut app ModApp) load() {
    app.data = os.read_lines(app.data_path) or { panic(err) }
}

fn (app &ModApp) draw() {
    // sprite
    app.gg.draw_rect_filled(app.padding + (app.scale * (app.sprite-1)), 0, (app.scale * 3), app.screen_height, gx.rgba(30, 30, 80, 250))

    // row
    if app.cycle < app.width * app.height {
        app.gg.draw_rect_filled(0, app.padding + (app.scale * int(app.cycle / app.width)), app.screen_width, app.scale, gx.rgba(50, 25, 0, 250))
    }

    for x in 0 .. app.width {
        app.gg.draw_text(app.scale(x) + 6, app.padding - app.font_size(.medium) - 5, '${x % 10}', app.color_font(.medium, gx.green))
        if x % 10 == 0 {
            app.gg.draw_text(app.scale(x) + 6, app.padding - ( app.font_size(.medium) * 2 ) - 5, '${x / 10}', app.color_font(.medium, gx.green))
        }
    }
    for y in 0 .. app.height {
        app.gg.draw_text(app.padding - app.font_size(.medium) - 5, app.scale(y), '${y % 10}', app.color_font(.medium, gx.green))
    }

    for x in 0 .. app.width {
        for y in 0 .. app.height {
            k := '${x},${y}'
            if app.crt.exists(k) {
                app.gg.draw_rect_filled(app.scale(x), app.scale(y), app.scale, app.scale, gx.green)
            }
            app.gg.draw_rect_empty(app.scale(x), app.scale(y), app.scale, app.scale, guts.grid_gray)
        }
    }

    if app.cycle < app.width * app.height {
        // pixel 
        app.gg.draw_rect_empty(app.scale(app.cycle % app.width), app.scale(app.cycle / app.width), app.scale, app.scale, gx.yellow)
    }
}

fn (mut app ModApp) update() {
    if app.state != .running {
        return
    }

    if app.ip < app.data.len - 1 && app.count == 0 {
        app.sprite += app.change
        app.count, app.change = shr.parse_ins(app.data[app.ip + 1])
        app.ip++
    }

    x := app.cycle % app.width
    y := int(app.cycle / app.width)

    if x == app.sprite - 1 || x == app.sprite || x == app.sprite + 1 {
        app.crt.add('${x},${y}')
    }

    app.cycle++
    app.count--

    if app.cycle == (app.width * app.height) - 1 {
        app.state = .done
        return
    }
}

fn (mut app ModApp) reset() {
    app.sprite = app.data[0].int()
    app.cycle = 0
    app.ip = 0
    app.count = 0
    app.change = 0
    if !app.crt.is_empty() {
        unsafe {
            mut els := &app.crt.elements
            els.free()
        }
        app.crt.clear()
    }
}

fn (mut app ModApp) on_key_handler(key gg.KeyCode) {
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
    } else if key == .r {
        app.load()
        app.reset()
        app.state = .waiting
    } else if key == .f {
        app.speed = u64(3)
    } else if key == .s {
        app.speed = u64(10)
    }
}

fn main() {
    // lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    // lines := os.read_lines('visualization.txt') or { panic(err) }

    height := 6
    width := 40
    pad := guts.padding + 50

    font_path := os.resource_abs_path(os.join_path('..', 'guts', 'RobotoMono-Regular.ttf'))

    scale, screen_height, screen_width, em_size := guts.padded_screen_metrics(height, width, pad)

    mut app := &ModApp{
        gg: 0
        padding: pad
        em_size: int(f32(em_size) * 3.5)
        scale: scale
        height: height
        width: width
        screen_height: screen_height
        screen_width: screen_width
        data_path: 'visualization.txt'
    }

    app.load()
    app.reset()

    app.gg = gg.new_context(
        bg_color: gx.black
        width: screen_width + 300
        height: screen_height
        create_window: true
        window_title: 'Day 10: Cathode-Ray Tube'
        frame_fn: frame
        event_fn: on_event
        user_data: app
        font_path: font_path
    )
    app.gg.run()
}

fn on_event(e &gg.Event, mut app &ModApp) {
    if e.typ == .key_down {
        app.on_key_handler(e.key_code)
    }
}

fn frame(mut app &ModApp) {
    app.gg.begin()
    if app.gg.frame % app.speed == 0 {
        app.update()
    }
    app.draw()

    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 0), 'State: ${app.state}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 1), 'Cycle: ${app.cycle + 1}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 2), 'IP: ${app.ip + 1} / ${app.data.len}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 3), 'Ins: ${app.data[app.ip]}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 4), 'Sprite: ${app.sprite}', app.font(.regular))
    app.gg.draw_text(guts.padded(app.screen_width), guts.padded(app.font_size(.regular) * 5), 'Row: ${app.cycle / app.width}', app.font(.regular))
    app.gg.end()
}
