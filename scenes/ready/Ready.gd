class_name Ready
extends Label


var is_ready: bool = false

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	visible = false
	is_ready = false
	

func toggle(should_play_sound: bool = true):
	visible = !visible
	is_ready = !is_ready
	
	if should_play_sound:
		AudioManager.play(Audio.READY)
	

func confirm():
	animation_player.play("ConfirmAnimation")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ConfirmAnimation":
		visible = false
		is_ready = false
		rect_scale.x = 1
		rect_scale.y = 1
		set("custom_colors/font_color", GameColor.FOREGROUND)
