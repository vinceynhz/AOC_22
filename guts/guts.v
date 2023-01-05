// [G]raphic [UT]ilitie[S]
module guts

import math
import gg
import gx

pub const (
    win_width  = 900
    padding = 10
    grid_gray = gx.Color{
        r: 50, 
        g: 50, 
        b: 50,
    }
    axis_gray = gx.Color{
        r: 80, 
        g: 80, 
        b: 80,
    }
)

pub enum State {
    waiting
    running
    done
}

pub enum Font_Size {
    small
    medium
    regular
}

pub struct App {
mut:
    gg            &gg.Context = unsafe { nil }
    state         State = .waiting
    padding       int = padding
    em_size       int
    scale         int
    height        int
    width         int
    screen_height int
    screen_width  int
}

pub fn (app &App) padded(val int) int {
    return val + app.padding
}

pub fn (app &App) scale(val int) int {
    return app.padded(val * app.scale)
}

pub fn (app &App) font(size Font_Size) gx.TextCfg {
    return app.color_font(size, gx.white)
}

pub fn (app &App) color_font(size Font_Size, color gx.Color) gx.TextCfg {
    return gx.TextCfg{ color: color, size: app.font_size(size) }
}

pub fn (app &App) font_size(size Font_Size) int {
    return match size {
        .small { app.em_size / 60 }
        .medium { app.em_size / 45 }
        .regular { app.em_size / 30 }
    }
}

pub fn hsl_to_rgb(_hue int, sat f32, light f32) gx.Color {
	mut hue := _hue / f32(60)
	mut t2 := f32(0)

	if light <= 0.5 {
		t2 = light * (sat + 1)
	} else {
		t2 = light + sat - (light * sat)
	}

	t1 := light * 2 - t2
	return gx.Color{
		r: u8(hue_to_rgb(t1, t2, hue + 2) * 255)
		g: u8(hue_to_rgb(t1, t2, hue) * 255)
		b: u8(hue_to_rgb(t1, t2, hue - 2) * 255)
	}
}

pub fn hue_to_rgb(t1 f32, t2 f32, _hue f32) f32 {
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

pub fn padded(val int) int {
	return val + padding
}

pub fn screen_metrics(height int, width int) (int, int, int, int) {
    return padded_screen_metrics(height, width, padding)
}

pub fn padded_screen_metrics(height int, width int, pad int) (int, int, int, int) {
    mut scale := math.max(height, width)
    scale = (win_width - padding) / scale
    screen_width := scale * width + pad * 2
    screen_height := scale * height + pad * 2
    em_size := math.min(screen_height, screen_width)
    return scale, screen_height, screen_width, em_size
}
