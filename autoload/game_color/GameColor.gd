extends Node


export var BACKGROUND_BLACK = Color("000000")
export var BACKGROUND_BLUE = Color("006db0")
export var BACKGROUND_CYAN = Color("007385")
export var BACKGROUND_GRAY = Color("3e474d")
export var BACKGROUND_GREEN = Color("4a5f4e")
export var BACKGROUND_MAGENTA = Color("a20350")
export var BACKGROUND_PINK = Color("ce918e")
export var BACKGROUND_PURPLE = Color("190331")
export var BACKGROUND_TAN = Color("c4ab7a")
export var BACKGROUND_YELLOW = Color("dd9a25")
const FOREGROUND: Color = Color("fdf5e3")
const FOCUS: Color = Color("b7fdf5e3")

const DEFAULT_THEME_INDEX = 7

var color_themes = [
	BACKGROUND_BLACK,
	BACKGROUND_BLUE,
	BACKGROUND_CYAN,
	BACKGROUND_GRAY,
	BACKGROUND_GREEN,
	BACKGROUND_MAGENTA,
	BACKGROUND_PINK,
	BACKGROUND_PURPLE,
	BACKGROUND_TAN,
	BACKGROUND_YELLOW
]


func update_color_theme(index: int):
	if index >= color_themes.size():
		VisualServer.set_default_clear_color(color_themes[DEFAULT_THEME_INDEX])
	else:
		var color_theme = color_themes[index]
		
		VisualServer.set_default_clear_color(color_theme)
